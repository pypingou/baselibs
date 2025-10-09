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
#include "score/memory/shared/shared_memory_resource.h"

#include "gtest/gtest.h"

#include <cstring>
#include <unistd.h>
#include <sys/stat.h>

namespace score::memory::shared::test
{

// Test the GetLockFilePath function which is public static
TEST(SharedMemoryFunctionalitySimpleTest, GetLockFilePathHandlesFullDevShmPaths)
{
    const char* input = "/dev/shm/subdir/file";
    const char* expected = "/dev/shm/subdir/file_lock";

    const auto result = SharedMemoryResource::GetLockFilePath(input);
    EXPECT_EQ(result, expected);
}

TEST(SharedMemoryFunctionalitySimpleTest, GetLockFilePathHandlesFullDevShmemPaths)
{
    const char* input = "/dev/shmem/subdir/file";
    const char* expected = "/dev/shmem/subdir/file_lock";

    const auto result = SharedMemoryResource::GetLockFilePath(input);
    EXPECT_EQ(result, expected);
}

TEST(SharedMemoryFunctionalitySimpleTest, GetLockFilePathHandlesSimpleNames)
{
    const char* input = "simple_name";

    const auto result = SharedMemoryResource::GetLockFilePath(input);
    EXPECT_TRUE(result.find("simple_name_lock") != std::string::npos);
    // Should start with the tmp prefix
    EXPECT_TRUE(result.find("/dev/shm") == 0 || result.find("/tmp") == 0);
}

TEST(SharedMemoryFunctionalitySimpleTest, GetLockFilePathHandlesEdgeCases)
{
    // Empty string
    const auto result1 = SharedMemoryResource::GetLockFilePath("");
    EXPECT_TRUE(result1.find("_lock") != std::string::npos);

    // Minimum valid subdirectory path
    const auto result2 = SharedMemoryResource::GetLockFilePath("/dev/shm/a/b");
    EXPECT_EQ(result2, "/dev/shm/a/b_lock");
}

} // namespace score::memory::shared::test