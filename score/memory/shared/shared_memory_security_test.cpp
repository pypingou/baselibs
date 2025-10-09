/********************************************************************************
 * Copyright (c) 2025 Contributors to the Eclipse Foundation
 *
 * See the NOTICE file(s) distributed with this work for additional
 * information regarding copyright ownership.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Apache License Version 2.0 which is available at
 * https://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0
 ********************************************************************************/
#include "score/memory/shared/shared_memory_resource.cpp" // Access to internal functions

#include "gtest/gtest.h"

namespace score::memory::shared::test
{

/// Test fixture for security validation tests
class SharedMemorySecurityTest : public ::testing::Test
{
};

/// Test ValidateSharedMemoryPath function for various security scenarios
TEST_F(SharedMemorySecurityTest, ValidateSharedMemoryPathRejectsEmptyPath)
{
    EXPECT_FALSE(ValidateSharedMemoryPath(""));
}

TEST_F(SharedMemorySecurityTest, ValidateSharedMemoryPathRejectsDirectoryTraversal)
{
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/../etc/passwd"));
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/subdir/../../../etc/passwd"));
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/.."));
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/valid/../invalid"));
}

TEST_F(SharedMemorySecurityTest, ValidateSharedMemoryPathRejectsHiddenFiles)
{
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/.hidden"));
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/subdir/.secret"));
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/path/."));
}

TEST_F(SharedMemorySecurityTest, ValidateSharedMemoryPathRejectsDoubleSlashes)
{
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm//file"));
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/path//to//file"));
}

TEST_F(SharedMemorySecurityTest, ValidateSharedMemoryPathRejectsTrailingSlash)
{
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/directory/"));
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/"));
}

TEST_F(SharedMemorySecurityTest, ValidateSharedMemoryPathRejectsControlCharacters)
{
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/file\x01"));
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/file\x1F"));
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/file\x7F"));
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/shm/file\0hidden", 20)); // Null byte attack
}

TEST_F(SharedMemorySecurityTest, ValidateSharedMemoryPathRejectsInvalidPrefixes)
{
    EXPECT_FALSE(ValidateSharedMemoryPath("/tmp/file"));
    EXPECT_FALSE(ValidateSharedMemoryPath("/etc/passwd"));
    EXPECT_FALSE(ValidateSharedMemoryPath("relative/path"));
    EXPECT_FALSE(ValidateSharedMemoryPath("/dev/other/file"));
}

TEST_F(SharedMemorySecurityTest, ValidateSharedMemoryPathRejectsOverlongPaths)
{
    // Create a very long path (over 4096 characters)
    std::string long_path = "/dev/shm/";
    long_path.reserve(5000);
    while (long_path.size() < 4200) {
        long_path += "very_long_path_component/";
    }
    long_path += "file";

    EXPECT_FALSE(ValidateSharedMemoryPath(long_path));
}

TEST_F(SharedMemorySecurityTest, ValidateSharedMemoryPathAcceptsValidPaths)
{
    EXPECT_TRUE(ValidateSharedMemoryPath("/dev/shm/valid_file"));
    EXPECT_TRUE(ValidateSharedMemoryPath("/dev/shm/subdir/valid_file"));
    EXPECT_TRUE(ValidateSharedMemoryPath("/dev/shm/deep/nested/path/file"));
    EXPECT_TRUE(ValidateSharedMemoryPath("/dev/shmem/valid_file"));
    EXPECT_TRUE(ValidateSharedMemoryPath("/dev/shmem/subdir/valid_file"));
}

TEST_F(SharedMemorySecurityTest, RequiresSubdirectoryHandlingDetectsCorrectly)
{
    EXPECT_FALSE(RequiresSubdirectoryHandling("/lola-data-123"));
    EXPECT_FALSE(RequiresSubdirectoryHandling("/dev/shm"));
    EXPECT_FALSE(RequiresSubdirectoryHandling("/dev/shm/file"));

    EXPECT_TRUE(RequiresSubdirectoryHandling("/dev/shm/subdir/file"));
    EXPECT_TRUE(RequiresSubdirectoryHandling("/dev/shm/lola_qm/data"));
    EXPECT_TRUE(RequiresSubdirectoryHandling("/dev/shm/deep/nested/path"));
}

} // namespace score::memory::shared::test