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

#include <cstdlib>
#include <string>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>

namespace score::memory::shared::test
{

/// Test fixture for functionality tests
class SharedMemoryFunctionalityTest : public ::testing::Test
{
protected:
    void SetUp() override
    {
        // Create a unique test directory for each test using POSIX API
        test_base_dir_ = std::string("/tmp/shm_test_") + std::to_string(getpid()) + "_" + std::to_string(test_counter_++);
        ::mkdir(test_base_dir_.c_str(), 0755);
    }

    void TearDown() override
    {
        // Clean up test directory using POSIX API
        // Note: For simplicity, just remove the base directory
        // In a real implementation, we'd recursively remove contents
        ::rmdir(test_base_dir_.c_str());
    }

    std::string getTestPath(const std::string& filename) const
    {
        return test_base_dir_ + "/" + filename;
    }

    std::string getDevShmTestPath(const std::string& filename) const
    {
        return std::string("/dev/shm/test_") + std::to_string(getpid()) + "_" + filename;
    }

private:
    static inline int test_counter_ = 0;
    std::string test_base_dir_;
};

// ==================== CreateDirectoryIfNeeded() Tests ====================

TEST_F(SharedMemoryFunctionalityTest, CreateDirectoryIfNeededCreatesDirectory)
{
    const std::string dir_path = getTestPath("new_dir");
    const std::string file_path = dir_path + "/test_file";

    // Directory should not exist initially
    struct stat statbuf;
    EXPECT_NE(::stat(dir_path.c_str(), &statbuf), 0) << "Directory should not exist initially";

    // Create directory through the function
    const auto result = CreateDirectoryIfNeeded(file_path);
    EXPECT_TRUE(result.has_value()) << "Failed to create directory";

    // Directory should now exist
    EXPECT_EQ(::stat(dir_path.c_str(), &statbuf), 0) << "Directory should exist after creation";
    EXPECT_TRUE(S_ISDIR(statbuf.st_mode)) << "Path should be a directory";
}

TEST_F(SharedMemoryFunctionalityTest, CreateDirectoryIfNeededHandlesExistingDirectory)
{
    const std::string dir_path = getTestPath("existing_dir");
    const std::string file_path = dir_path + "/test_file";

    // Create directory manually first
    std::filesystem::create_directories(dir_path);
    EXPECT_TRUE(std::filesystem::exists(dir_path));

    // Function should succeed even if directory exists
    const auto result = CreateDirectoryIfNeeded(file_path);
    EXPECT_TRUE(result.has_value()) << "Failed when directory already exists: " << result.error();
}

TEST_F(SharedMemoryFunctionalityTest, CreateDirectoryIfNeededCreatesNestedDirectories)
{
    const std::string nested_path = getTestPath("level1/level2/level3");
    const std::string file_path = nested_path + "/test_file";

    // No directories should exist initially
    EXPECT_FALSE(std::filesystem::exists(getTestPath("level1")));

    // Create nested directory structure
    const auto result = CreateDirectoryIfNeeded(file_path);
    EXPECT_TRUE(result.has_value()) << "Failed to create nested directories: " << result.error();

    // All levels should now exist
    EXPECT_TRUE(std::filesystem::exists(getTestPath("level1")));
    EXPECT_TRUE(std::filesystem::exists(getTestPath("level1/level2")));
    EXPECT_TRUE(std::filesystem::exists(nested_path));
}

TEST_F(SharedMemoryFunctionalityTest, CreateDirectoryIfNeededHandlesNoDirectoryPath)
{
    // File with no directory component
    const auto result = CreateDirectoryIfNeeded("simple_file");
    EXPECT_TRUE(result.has_value()) << "Failed to handle simple filename";

    // Root file
    const auto result2 = CreateDirectoryIfNeeded("/root_file");
    EXPECT_TRUE(result2.has_value()) << "Failed to handle root file";
}

// ==================== OpenRegularFile() Tests ====================

TEST_F(SharedMemoryFunctionalityTest, OpenRegularFileSuccessfullyOpensFile)
{
    // Note: Using /dev/shm for testing as ValidateSharedMemoryPath requires it
    const std::string test_file = getDevShmTestPath("regular_file");

    // Clean up any existing file
    ::score::os::Unistd::instance().unlink(test_file.c_str());

    const auto result = OpenRegularFile(test_file,
                                       score::os::Fcntl::Open::kWriteOnly | score::os::Fcntl::Open::kCreateFile,
                                       score::os::Stat::Mode::kReadWriteUser);

    EXPECT_TRUE(result.has_value()) << "Failed to open regular file: " << result.error();

    if (result.has_value())
    {
        // Verify file was created and is accessible
        EXPECT_GT(result.value(), 0) << "Invalid file descriptor returned";

        // Clean up
        ::score::os::Unistd::instance().close(result.value());
        ::score::os::Unistd::instance().unlink(test_file.c_str());
    }
}

TEST_F(SharedMemoryFunctionalityTest, OpenRegularFileCreatesSubdirectories)
{
    const std::string test_file = getDevShmTestPath("subdir/nested/file");

    // Clean up any existing structure
    ::score::os::Unistd::instance().unlink(test_file.c_str());

    const auto result = OpenRegularFile(test_file,
                                       score::os::Fcntl::Open::kWriteOnly | score::os::Fcntl::Open::kCreateFile,
                                       score::os::Stat::Mode::kReadWriteUser);

    EXPECT_TRUE(result.has_value()) << "Failed to open file with subdirectories: " << result.error();

    if (result.has_value())
    {
        // Verify subdirectories were created
        EXPECT_TRUE(std::filesystem::exists("/dev/shm/test_" + std::to_string(getpid()) + "_subdir"));
        EXPECT_TRUE(std::filesystem::exists("/dev/shm/test_" + std::to_string(getpid()) + "_subdir/nested"));

        // Clean up
        ::score::os::Unistd::instance().close(result.value());
        ::score::os::Unistd::instance().unlink(test_file.c_str());
        // Note: Directories are left for system cleanup
    }
}

TEST_F(SharedMemoryFunctionalityTest, OpenRegularFileRejectsInvalidPaths)
{
    // Invalid path should be rejected by ValidateSharedMemoryPath
    const std::string invalid_path = "/tmp/invalid_path";

    const auto result = OpenRegularFile(invalid_path,
                                       score::os::Fcntl::Open::kWriteOnly | score::os::Fcntl::Open::kCreateFile,
                                       score::os::Stat::Mode::kReadWriteUser);

    EXPECT_FALSE(result.has_value()) << "Should reject invalid paths";
    EXPECT_EQ(result.error().getErrno(), EINVAL) << "Should return EINVAL for invalid paths";
}

TEST_F(SharedMemoryFunctionalityTest, OpenRegularFileAppliesSecurityFlags)
{
    const std::string test_file = getDevShmTestPath("security_test");

    // Clean up any existing file
    ::score::os::Unistd::instance().unlink(test_file.c_str());

    const auto result = OpenRegularFile(test_file,
                                       score::os::Fcntl::Open::kWriteOnly | score::os::Fcntl::Open::kCreateFile,
                                       score::os::Stat::Mode::kReadWriteUser);

    EXPECT_TRUE(result.has_value()) << "Failed to open file: " << result.error();

    if (result.has_value())
    {
        // Test that O_CLOEXEC is applied by checking fcntl flags
        const auto fcntl_result = ::score::os::Fcntl::instance().fcntl(result.value(), F_GETFD);
        EXPECT_TRUE(fcntl_result.has_value()) << "Failed to get file descriptor flags";

        if (fcntl_result.has_value())
        {
            EXPECT_NE((fcntl_result.value() & FD_CLOEXEC), 0) << "O_CLOEXEC flag should be set";
        }

        // Clean up
        ::score::os::Unistd::instance().close(result.value());
        ::score::os::Unistd::instance().unlink(test_file.c_str());
    }
}

// ==================== GetLockFilePath() Tests ====================

TEST_F(SharedMemoryFunctionalityTest, GetLockFilePathHandlesFullDevShmPaths)
{
    const std::string input = "/dev/shm/subdir/file";
    const std::string expected = "/dev/shm/subdir/file_lock";

    const std::string result = SharedMemoryResource::GetLockFilePath(input);
    EXPECT_EQ(result, expected);
}

TEST_F(SharedMemoryFunctionalityTest, GetLockFilePathHandlesFullDevShmemPaths)
{
    const std::string input = "/dev/shmem/subdir/file";
    const std::string expected = "/dev/shmem/subdir/file_lock";

    const std::string result = SharedMemoryResource::GetLockFilePath(input);
    EXPECT_EQ(result, expected);
}

TEST_F(SharedMemoryFunctionalityTest, GetLockFilePathHandlesSimpleNames)
{
    const std::string input = "simple_name";
    const std::string expected = std::string{kTmpPathPrefix} + "simple_name_lock";

    const std::string result = SharedMemoryResource::GetLockFilePath(input);
    EXPECT_EQ(result, expected);
}

TEST_F(SharedMemoryFunctionalityTest, GetLockFilePathHandlesEdgeCases)
{
    // Empty string
    const std::string result1 = SharedMemoryResource::GetLockFilePath("");
    const std::string expected1 = std::string{kTmpPathPrefix} + "_lock";
    EXPECT_EQ(result1, expected1);

    // Just /dev/shm/ (too short for full path logic)
    const std::string result2 = SharedMemoryResource::GetLockFilePath("/dev/shm/");
    const std::string expected2 = std::string{kTmpPathPrefix} + "/dev/shm/_lock";
    EXPECT_EQ(result2, expected2);

    // Minimum valid full path
    const std::string result3 = SharedMemoryResource::GetLockFilePath("/dev/shm/a");
    const std::string expected3 = std::string{kTmpPathPrefix} + "/dev/shm/a_lock";
    EXPECT_EQ(result3, expected3);

    // Minimum valid subdirectory path
    const std::string result4 = SharedMemoryResource::GetLockFilePath("/dev/shm/a/b");
    const std::string expected4 = "/dev/shm/a/b_lock";
    EXPECT_EQ(result4, expected4);
}

// ==================== Integration Tests ====================

TEST_F(SharedMemoryFunctionalityTest, HybridApproachLogicConsistency)
{
    // Test that RequiresSubdirectoryHandling and GetLockFilePath logic align

    struct TestCase {
        std::string path;
        bool should_require_subdir_handling;
        std::string expected_lock_prefix;
    };

    const std::vector<TestCase> test_cases = {
        {"/lola-data-123", false, std::string{kTmpPathPrefix}},
        {"/dev/shm/file", false, std::string{kTmpPathPrefix}},
        {"/dev/shm/subdir/file", true, "/dev/shm/subdir/file"},
        {"/dev/shm/deep/nested/path", true, "/dev/shm/deep/nested/path"},
        {"/dev/shmem/file", false, std::string{kTmpPathPrefix}},
        {"/dev/shmem/subdir/file", true, "/dev/shmem/subdir/file"}
    };

    for (const auto& test_case : test_cases)
    {
        const bool requires_subdir = RequiresSubdirectoryHandling(test_case.path);
        EXPECT_EQ(requires_subdir, test_case.should_require_subdir_handling)
            << "RequiresSubdirectoryHandling mismatch for: " << test_case.path;

        const std::string lock_path = SharedMemoryResource::GetLockFilePath(test_case.path);
        EXPECT_TRUE(lock_path.find(test_case.expected_lock_prefix) == 0)
            << "GetLockFilePath prefix mismatch for: " << test_case.path
            << " (got: " << lock_path << ", expected prefix: " << test_case.expected_lock_prefix << ")";
    }
}

// ==================== Error Handling Tests ====================

TEST_F(SharedMemoryFunctionalityTest, CreateDirectoryIfNeededHandlesPermissionDenied)
{
    // Try to create directory in a location where we don't have permissions
    // Note: This test may be skipped if running as root
    const std::string protected_path = "/root/test_dir/file";

    const auto result = CreateDirectoryIfNeeded(protected_path);

    // Should either fail with permission denied, or succeed if running as root
    if (!result.has_value())
    {
        // If it fails, it should be due to permission issues
        EXPECT_TRUE(result.error() == Error::Code::kPermissionDenied ||
                   result.error() == Error::Code::kFileDoesNotExist)
            << "Unexpected error: " << result.error();
    }
    // If it succeeds, we're probably running as root - clean up
    else
    {
        std::filesystem::remove_all("/root/test_dir");
    }
}

TEST_F(SharedMemoryFunctionalityTest, OpenRegularFileHandlesDirectoryExists)
{
    const std::string dir_path = getDevShmTestPath("existing_dir");
    const std::string file_path = dir_path; // Try to open directory as file

    // Create directory first
    std::filesystem::create_directories(dir_path);
    EXPECT_TRUE(std::filesystem::is_directory(dir_path));

    const auto result = OpenRegularFile(file_path,
                                       score::os::Fcntl::Open::kWriteOnly | score::os::Fcntl::Open::kCreateFile,
                                       score::os::Stat::Mode::kReadWriteUser);

    // Should fail and convert EISDIR to EINVAL
    EXPECT_FALSE(result.has_value()) << "Should fail when trying to open directory as file";
    if (!result.has_value())
    {
        EXPECT_EQ(result.error().getErrno(), EINVAL)
            << "Should convert EISDIR to EINVAL, got: " << result.error();
    }

    // Clean up
    std::filesystem::remove_all(dir_path);
}

// ==================== Boundary Condition Tests ====================

TEST_F(SharedMemoryFunctionalityTest, RequiresSubdirectoryHandlingBoundaryConditions)
{
    // Test exact boundary conditions for path length and structure

    // Exactly 9 characters - "/dev/shm/" - should be false (no subdirs)
    EXPECT_FALSE(RequiresSubdirectoryHandling("/dev/shm/"));

    // 10 characters with file - "/dev/shm/a" - should be false (no subdirs)
    EXPECT_FALSE(RequiresSubdirectoryHandling("/dev/shm/a"));

    // 11 characters with subdir - "/dev/shm/a/" - should be false (ends with slash)
    EXPECT_FALSE(RequiresSubdirectoryHandling("/dev/shm/a/"));

    // 12 characters with subdir + file - "/dev/shm/a/b" - should be true
    EXPECT_TRUE(RequiresSubdirectoryHandling("/dev/shm/a/b"));

    // Less than 9 characters
    EXPECT_FALSE(RequiresSubdirectoryHandling("/dev/shm"));
    EXPECT_FALSE(RequiresSubdirectoryHandling(""));

    // Different prefix but similar length
    EXPECT_FALSE(RequiresSubdirectoryHandling("/dev/null/a/b"));
}

} // namespace score::memory::shared::test