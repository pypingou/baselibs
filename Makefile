# *******************************************************************************
# Copyright (c) 2025 Contributors to the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Apache License Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0
#
# SPDX-License-Identifier: Apache-2.0
# *******************************************************************************

# Native Makefile for score-baselibs project
# Compiles C++ code directly with gcc/g++, no Bazel required

# Compiler Configuration
CXX ?= g++
CC ?= gcc
AR ?= ar

# Directories
ROOT_DIR := $(shell pwd)
BUILD_DIR := $(ROOT_DIR)/build
SRC_DIR := $(ROOT_DIR)
INCLUDE_DIRS := $(ROOT_DIR) $(ROOT_DIR)/score/language/futurecpp/include $(ROOT_DIR)/score/static_reflection_with_serialization/visitor/include $(ROOT_DIR)/score/static_reflection_with_serialization/serialization/include

# Install paths
PREFIX ?= /usr/local
LIBDIR ?= $(PREFIX)/lib
INCLUDEDIR ?= $(PREFIX)/include
DOCDIR ?= $(PREFIX)/share/doc/score-baselibs
DATADIR ?= $(PREFIX)/share/score-baselibs

# Compiler Flags (based on Bazel analysis)
CXXFLAGS := -std=c++17 -Wall -Wno-error=deprecated-declarations -Wno-error=narrowing
CXXFLAGS += -O2 -DNDEBUG -fPIC
CXXFLAGS += $(addprefix -I,$(INCLUDE_DIRS))

CFLAGS := -std=c11 -Wall -O2 -DNDEBUG -fPIC
CFLAGS += $(addprefix -I,$(INCLUDE_DIRS))

# Test Flags
TEST_CXXFLAGS := $(CXXFLAGS) -DGTEST_HAS_STD_WSTRING=0

# Create build directories
$(shell mkdir -p $(BUILD_DIR)/score/memory)
$(shell mkdir -p $(BUILD_DIR)/score/memory/shared)
$(shell mkdir -p $(BUILD_DIR)/score/memory/shared/flock)
$(shell mkdir -p $(BUILD_DIR)/score/memory/shared/sealedshm/sealedshm_wrapper)
$(shell mkdir -p $(BUILD_DIR)/score/memory/shared/typedshm/typedshm_wrapper)
$(shell mkdir -p $(BUILD_DIR)/score/utils)
$(shell mkdir -p $(BUILD_DIR)/score/utils/src)
$(shell mkdir -p $(BUILD_DIR)/score/datetime_converter)
$(shell mkdir -p $(BUILD_DIR)/score/containers)
$(shell mkdir -p $(BUILD_DIR)/score/bitmanipulation)
$(shell mkdir -p $(BUILD_DIR)/score/filesystem)
$(shell mkdir -p $(BUILD_DIR)/score/filesystem/details)
$(shell mkdir -p $(BUILD_DIR)/score/filesystem/factory)
$(shell mkdir -p $(BUILD_DIR)/score/filesystem/filestream)
$(shell mkdir -p $(BUILD_DIR)/score/filesystem/file_utils)
$(shell mkdir -p $(BUILD_DIR)/score/filesystem/iterator)
$(shell mkdir -p $(BUILD_DIR)/score/concurrency)
$(shell mkdir -p $(BUILD_DIR)/score/concurrency/future)
$(shell mkdir -p $(BUILD_DIR)/score/concurrency/thread_load_tracking)
$(shell mkdir -p $(BUILD_DIR)/score/concurrency/timed_executor)
$(shell mkdir -p $(BUILD_DIR)/score/json)
$(shell mkdir -p $(BUILD_DIR)/score/json/examples)
$(shell mkdir -p $(BUILD_DIR)/score/json/internal/model)
$(shell mkdir -p $(BUILD_DIR)/score/json/internal/parser/nlohmann)
$(shell mkdir -p $(BUILD_DIR)/score/json/internal/parser/vajson)
$(shell mkdir -p $(BUILD_DIR)/score/json/internal/writer/json_serialize)
$(shell mkdir -p $(BUILD_DIR)/score/mw/log)
$(shell mkdir -p $(BUILD_DIR)/score/mw/log/configuration)
$(shell mkdir -p $(BUILD_DIR)/score/mw/log/detail)
$(shell mkdir -p $(BUILD_DIR)/score/mw/log/detail/file_logging)
$(shell mkdir -p $(BUILD_DIR)/score/mw/log/detail/slog)
$(shell mkdir -p $(BUILD_DIR)/score/result)
$(shell mkdir -p $(BUILD_DIR)/score/result/details/expected)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/scoped_function)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/scoped_function/details)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/aborts_upon_exception)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/coverage_termination_handler)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/safe_math)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/safe_math/details)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/safe_math/details/absolute)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/safe_math/details/addition_subtraction)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/safe_math/details/cast)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/safe_math/details/comparison)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/safe_math/details/division)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/safe_math/details/multiplication)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/safe_math/details/negate)
$(shell mkdir -p $(BUILD_DIR)/score/language/safecpp/safe_math/details/type_traits)
$(shell mkdir -p $(BUILD_DIR)/score/analysis/tracing)
$(shell mkdir -p $(BUILD_DIR)/score/analysis/tracing/common/shared_list)
$(shell mkdir -p $(BUILD_DIR)/score/analysis/tracing/common/flexible_circular_allocator)
$(shell mkdir -p $(BUILD_DIR)/score/analysis/tracing/common/interface_types)
$(shell mkdir -p $(BUILD_DIR)/score/analysis/tracing/generic_trace_library/interface_types)
$(shell mkdir -p $(BUILD_DIR)/score/analysis/tracing/generic_trace_library/interface_types/chunk_list)
$(shell mkdir -p $(BUILD_DIR)/score/analysis/tracing/generic_trace_library/interface_types/error_code)
$(shell mkdir -p $(BUILD_DIR)/score/analysis/tracing/generic_trace_library/stub_implementation)
$(shell mkdir -p $(BUILD_DIR)/score/quality)
$(shell mkdir -p $(BUILD_DIR)/score/quality/compiler_warnings)
$(shell mkdir -p $(BUILD_DIR)/score/os)
$(shell mkdir -p $(BUILD_DIR)/score/os/linux)
$(shell mkdir -p $(BUILD_DIR)/score/os/linux/utils)
$(shell mkdir -p $(BUILD_DIR)/score/language/futurecpp/src)
$(shell mkdir -p $(BUILD_DIR)/score/os/qnx)
$(shell mkdir -p $(BUILD_DIR)/score/os/qnx/types)
$(shell mkdir -p $(BUILD_DIR)/score/os/posix)
$(shell mkdir -p $(BUILD_DIR)/score/os/utils)
$(shell mkdir -p $(BUILD_DIR)/score/os/utils/acl)
$(shell mkdir -p $(BUILD_DIR)/score/os/utils/inotify)
$(shell mkdir -p $(BUILD_DIR)/score/os/utils/interprocess)
$(shell mkdir -p $(BUILD_DIR)/score/os/utils/qnx/resource_manager/src)
$(shell mkdir -p $(BUILD_DIR)/tests)

# Source Files
MEMORY_SOURCES := score/memory/endianness.cpp score/memory/string_comparison_adaptor.cpp score/memory/split_string_view.cpp \
                 score/memory/shared/atomic_indirector.cpp \
                 score/memory/shared/flock/exclusive_flock_mutex.cpp score/memory/shared/flock/flock_mutex_and_lock.cpp \
                 score/memory/shared/flock/flock_mutex.cpp score/memory/shared/flock/shared_flock_mutex.cpp \
                 score/memory/shared/i_shared_memory_factory.cpp score/memory/shared/i_shared_memory_resource.cpp \
                 score/memory/shared/lock_file.cpp score/memory/shared/managed_memory_resource.cpp \
                 score/memory/shared/map.cpp score/memory/shared/memory_region_bounds.cpp \
                 score/memory/shared/memory_region_map.cpp \
                 score/memory/shared/memory_resource_proxy.cpp score/memory/shared/memory_resource_registry.cpp \
                 score/memory/shared/new_delete_delegate_resource.cpp score/memory/shared/offset_ptr_bounds_check.cpp \
                 score/memory/shared/offset_ptr.cpp score/memory/shared/pointer_arithmetic_util.cpp \
                 score/memory/shared/polymorphic_offset_ptr_allocator.cpp \
                 score/memory/shared/sealedshm/sealedshm_wrapper/sealed_shm.cpp \
                 score/memory/shared/shared_memory_error.cpp score/memory/shared/shared_memory_factory.cpp \
                 score/memory/shared/shared_memory_factory_impl.cpp \
                 score/memory/shared/shared_memory_resource.cpp score/memory/shared/string.cpp \
                 score/memory/shared/typedshm/typedshm_wrapper/typed_memory.cpp score/memory/shared/vector.cpp
MEMORY_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(MEMORY_SOURCES))

UTILS_SOURCES := score/utils/string_hash.cpp score/utils/pimpl_ptr.cpp score/datetime_converter/time_conversion.cpp \
                score/utils/src/PayloadValidation.cpp
UTILS_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(UTILS_SOURCES))

# Container module
CONTAINERS_SOURCES := score/containers/dynamic_array.cpp score/containers/intrusive_list.cpp
CONTAINERS_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(CONTAINERS_SOURCES))

# Bitmanipulation module
BITMANIPULATION_SOURCES := score/bitmanipulation/bit_manipulation.cpp score/bitmanipulation/bitmask_operators.cpp
BITMANIPULATION_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(BITMANIPULATION_SOURCES))

# Filesystem module (complete coverage, excluding mock and fake files)
FILESYSTEM_SOURCES := score/filesystem/error.cpp score/filesystem/file_status.cpp score/filesystem/path.cpp \
                     score/filesystem/details/standard_filesystem.cpp \
                     score/filesystem/filesystem_struct.cpp score/filesystem/i_standard_filesystem.cpp \
                     score/filesystem/factory/filesystem_factory.cpp score/filesystem/factory/i_filesystem_factory.cpp \
                     score/filesystem/filestream/bad_string_stream_collection.cpp score/filesystem/filestream/file_buf.cpp \
                     score/filesystem/filestream/file_factory.cpp \
                     score/filesystem/filestream/file_stream.cpp score/filesystem/filestream/i_file_factory.cpp \
                     score/filesystem/filestream/i_string_stream_collection.cpp score/filesystem/filestream/simple_string_stream_collection.cpp \
                     score/filesystem/file_utils/file_utils.cpp \
                     score/filesystem/file_utils/i_file_utils.cpp \
                     score/filesystem/iterator/directory_entry.cpp score/filesystem/iterator/directory_iterator.cpp \
                     score/filesystem/iterator/recursive_directory_iterator.cpp
FILESYSTEM_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(FILESYSTEM_SOURCES))

# Concurrency module (complete coverage, excluding mock files)
CONCURRENCY_SOURCES := score/concurrency/clock.cpp score/concurrency/condition_variable.cpp score/concurrency/executor.cpp \
                      score/concurrency/notification.cpp score/concurrency/task.cpp score/concurrency/delayed_task.cpp \
                      score/concurrency/destruction_guard.cpp \
                      score/concurrency/interruptible_interprocess_condition_variable.cpp \
                      score/concurrency/interruptible_wait.cpp score/concurrency/long_running_threads_container.cpp \
                      score/concurrency/periodic_task.cpp score/concurrency/shared_task_result.cpp \
                      score/concurrency/simple_task.cpp score/concurrency/synchronized_queue.cpp \
                      score/concurrency/task_result_base.cpp score/concurrency/task_result.cpp score/concurrency/thread_pool.cpp \
                      score/concurrency/future/base_interruptible_future.cpp score/concurrency/future/base_interruptible_promise.cpp \
                      score/concurrency/future/base_interruptible_state.cpp score/concurrency/future/error.cpp \
                      score/concurrency/future/interruptible_future.cpp score/concurrency/future/interruptible_promise.cpp \
                      score/concurrency/future/interruptible_shared_future.cpp score/concurrency/future/interruptible_state.cpp \
                      score/concurrency/thread_load_tracking/thread_load_tracking.cpp score/concurrency/thread_load_tracking/thread_load_tracking_token.cpp \
                      score/concurrency/timed_executor/concurrent_timed_executor.cpp score/concurrency/timed_executor/delayed_task.cpp \
                      score/concurrency/timed_executor/periodic_task.cpp score/concurrency/timed_executor/timed_executor.cpp \
                      score/concurrency/timed_executor/timed_task.cpp
CONCURRENCY_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(CONCURRENCY_SOURCES))

# JSON module (expanded coverage - now including nlohmann JSON parser, excluding examples)
JSON_SOURCES := score/json/i_json_parser.cpp score/json/i_json_writer.cpp score/json/json_parser.cpp \
               score/json/json_writer.cpp score/json/json_serializer.cpp \
               score/json/internal/model/any.cpp score/json/internal/model/error.cpp \
               score/json/internal/model/lossless_cast.cpp score/json/internal/model/null.cpp score/json/internal/model/number.cpp \
               score/json/internal/writer/json_serialize/json_serialize.cpp \
               score/json/internal/parser/nlohmann/nlohmann_parser.cpp score/json/internal/parser/nlohmann/json_builder.cpp
JSON_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(JSON_SOURCES))

# OS module (Linux-focused build - excluding QNX-specific, mock, and fake files)
OS_SOURCES := $(filter-out %_test.cpp score/os/qnx_pthread.cpp,$(wildcard score/os/*.cpp)) \
              $(filter-out %_test.cpp,$(wildcard score/os/linux/*.cpp)) \
              $(filter-out %_test.cpp,$(wildcard score/os/linux/utils/*.cpp)) \
              $(filter-out %_test.cpp,$(wildcard score/os/posix/*.cpp)) \
              $(filter-out %_test.cpp score/os/utils/path_qnx.cpp score/os/utils/tcp_keep_alive_qnx.cpp score/os/utils/thread_qnx.cpp,$(wildcard score/os/utils/*.cpp)) \
              $(filter-out %_test.cpp %mock%.cpp,$(wildcard score/os/utils/acl/*.cpp)) \
              $(filter-out %_test.cpp %mock%.cpp,$(wildcard score/os/utils/inotify/*.cpp)) \
              $(filter-out %_test.cpp,$(wildcard score/os/utils/interprocess/*.cpp))
OS_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(OS_SOURCES))

# Logging module (massive expansion - excluding QNX-specific slog files)
LOG_SOURCES := score/mw/log/irecorder_factory.cpp score/mw/log/log_common.cpp score/mw/log/logger_container.cpp \
               score/mw/log/logger.cpp score/mw/log/logging.cpp score/mw/log/log_level.cpp \
               score/mw/log/log_stream.cpp score/mw/log/log_stream_error.cpp score/mw/log/log_stream_factory.cpp \
               score/mw/log/recorder.cpp score/mw/log/runtime.cpp score/mw/log/slot_handle.cpp \
               score/mw/log/configuration/invconfig.cpp score/mw/log/configuration/configuration_file_discoverer.cpp \
               score/mw/log/configuration/iconfiguration_file_discoverer.cpp score/mw/log/configuration/configuration.cpp \
               score/mw/log/configuration/itarget_config_reader.cpp score/mw/log/configuration/nvconfig.cpp \
               score/mw/log/configuration/target_config_reader.cpp score/mw/log/detail/dlt_argument_counter.cpp \
               score/mw/log/detail/circular_allocator.cpp score/mw/log/detail/recorder_factory.cpp \
               score/mw/log/detail/log_record.cpp score/mw/log/detail/file_logging/text_message_builder.cpp \
               score/mw/log/detail/file_logging/dlt_message_builder.cpp \
               score/mw/log/detail/file_logging/file_recorder_factory.cpp score/mw/log/detail/file_logging/file_recorder.cpp \
               score/mw/log/detail/logging_identifier.cpp score/mw/log/detail/log_entry.cpp \
               score/mw/log/detail/backend.cpp score/mw/log/detail/composite_recorder.cpp \
               score/mw/log/detail/dlt_format.cpp score/mw/log/detail/empty_recorder.cpp \
               score/mw/log/detail/empty_recorder_factory.cpp score/mw/log/detail/error.cpp \
               score/mw/log/detail/file_logging/console_recorder_factory.cpp \
               score/mw/log/detail/file_logging/file_output_backend.cpp score/mw/log/detail/file_logging/imessage_builder.cpp \
               score/mw/log/detail/file_logging/non_blocking_writer.cpp score/mw/log/detail/file_logging/slot_drainer.cpp \
               score/mw/log/detail/file_logging/text_format.cpp score/mw/log/detail/file_logging/text_recorder.cpp \
               score/mw/log/detail/initialization_reporter.cpp score/mw/log/detail/istatistics_reporter.cpp \
               score/mw/log/detail/statistics_reporter.cpp \
               score/mw/log/detail/thread_local_guard.cpp score/mw/log/detail/verbose_payload.cpp
LOG_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(LOG_SOURCES))

# Analysis/Tracing module
ANALYSIS_SOURCES := score/analysis/tracing/common/shared_list/shared_list.cpp \
                   score/analysis/tracing/common/flexible_circular_allocator/lockless_flexible_circular_allocator.cpp \
                   score/analysis/tracing/common/flexible_circular_allocator/custom_polymorphic_offset_ptr_allocator.cpp \
                   score/analysis/tracing/common/flexible_circular_allocator/flexible_circular_allocator_interface.cpp \
                   score/analysis/tracing/common/flexible_circular_allocator/error_code.cpp \
                   score/analysis/tracing/common/flexible_circular_allocator/flexible_circular_allocator.cpp \
                   score/analysis/tracing/common/interface_types/shared_memory_location_helpers.cpp \
                   score/analysis/tracing/common/interface_types/shared_memory_location.cpp \
                   score/analysis/tracing/common/interface_types/shared_memory_chunk.cpp \
                   score/analysis/tracing/common/interface_types/types.cpp \
                   score/analysis/tracing/generic_trace_library/interface_types/ara_com_properties.cpp \
                   score/analysis/tracing/generic_trace_library/interface_types/ara_com_meta_info.cpp \
                   score/analysis/tracing/generic_trace_library/interface_types/chunk_list/shm_data_chunk_list.cpp \
                   score/analysis/tracing/generic_trace_library/interface_types/chunk_list/local_data_chunk_list.cpp \
                   score/analysis/tracing/generic_trace_library/interface_types/error_code/error_code.cpp \
                   score/analysis/tracing/generic_trace_library/stub_implementation/generic_trace_api_stub.cpp
ANALYSIS_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(ANALYSIS_SOURCES))

# Language/SafeCpp module
SAFECPP_SOURCES := score/language/safecpp/scoped_function/details/invoker.cpp \
                  score/language/safecpp/scoped_function/details/is_callable_from.cpp \
                  score/language/safecpp/scoped_function/details/type_erasure_pointer.cpp \
                  score/language/safecpp/scoped_function/details/scope_state.cpp \
                  score/language/safecpp/scoped_function/details/parametrization_helper.cpp \
                  score/language/safecpp/scoped_function/details/modify_return_type.cpp \
                  score/language/safecpp/scoped_function/details/function_wrapper.cpp \
                  score/language/safecpp/scoped_function/details/allocator_aware_type_erasure_pointer.cpp \
                  score/language/safecpp/scoped_function/details/instrumented_memory_resource.cpp \
                  score/language/safecpp/scoped_function/details/scoped_function_invoker.cpp \
                  score/language/safecpp/scoped_function/details/allocator_aware_erased_type.cpp \
                  score/language/safecpp/scoped_function/details/call_and_return_modified.cpp \
                  score/language/safecpp/scoped_function/details/modify_signature.cpp \
                  score/language/safecpp/scoped_function/details/allocator_wrapper.cpp \
                  score/language/safecpp/scoped_function/move_only_scoped_function.cpp \
                  score/language/safecpp/scoped_function/scope.cpp \
                  score/language/safecpp/scoped_function/copyable_scoped_function.cpp \
                  score/language/safecpp/aborts_upon_exception/aborts_upon_exception.cpp \
                  score/language/safecpp/safe_math/safe_math.cpp \
                  score/language/safecpp/safe_math/error.cpp \
                  score/language/safecpp/safe_math/details/absolute/absolute.cpp \
                  score/language/safecpp/safe_math/details/cast/cast.cpp \
                  score/language/safecpp/safe_math/details/type_traits/type_traits.cpp \
                  score/language/safecpp/safe_math/details/multiplication/multiplication.cpp \
                  score/language/safecpp/safe_math/details/division/division.cpp \
                  score/language/safecpp/safe_math/details/negate/negate.cpp \
                  score/language/safecpp/safe_math/details/addition_subtraction/addition_subtraction.cpp \
                  score/language/safecpp/safe_math/details/comparison/comparison.cpp \
                  score/language/safecpp/safe_math/details/floating_point_environment.cpp \
                  score/language/safecpp/coverage_termination_handler/coverage_termination_handler.cpp
SAFECPP_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(SAFECPP_SOURCES))

# Quality module
QUALITY_SOURCES := score/quality/compiler_warnings/warnings.cpp
QUALITY_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(QUALITY_SOURCES))

# Result module (re-enabled for testing)
RESULT_SOURCES := score/result/result.cpp score/result/error.cpp score/result/error_code.cpp \
                 score/result/details/expected/expected.cpp score/result/details/expected/extensions.cpp \
                 score/result/error_domain.cpp
RESULT_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(RESULT_SOURCES))

# FutureCpp module (C++ language extensions and backports)
FUTURECPP_CPP_SOURCES := score/language/futurecpp/src/assert.cpp score/language/futurecpp/src/charconv.cpp \
                        score/language/futurecpp/src/hash.cpp score/language/futurecpp/src/intrusive_forward_list.cpp \
                        score/language/futurecpp/src/jthread.cpp score/language/futurecpp/src/memory_resource.cpp \
                        score/language/futurecpp/src/stop_token.cpp score/language/futurecpp/src/string.cpp
FUTURECPP_C_SOURCES := score/language/futurecpp/src/math.c
FUTURECPP_CPP_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(FUTURECPP_CPP_SOURCES))
FUTURECPP_C_OBJECTS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(FUTURECPP_C_SOURCES))
FUTURECPP_OBJECTS := $(FUTURECPP_CPP_OBJECTS) $(FUTURECPP_C_OBJECTS)

# RESULT_SOURCES := $(filter-out %_test.cpp,$(wildcard score/result/*.cpp))
# RESULT_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(RESULT_SOURCES))
# Note: Result module disabled due to compilation issues with unexpected<E>::swap

# Test Sources
MEMORY_TEST_SOURCES := score/memory/endianness_test.cpp score/memory/string_comparison_adaptor_test.cpp score/memory/split_string_view_test.cpp score/memory/pmr_ring_buffer_test.cpp
MEMORY_TEST_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(MEMORY_TEST_SOURCES))

# Libraries (shared)
LIBRARY_VERSION := 0.0.5
MEMORY_LIB := $(BUILD_DIR)/libscore_memory.so.$(LIBRARY_VERSION)
UTILS_LIB := $(BUILD_DIR)/libscore_utils.so.$(LIBRARY_VERSION)
CONTAINERS_LIB := $(BUILD_DIR)/libscore_containers.so.$(LIBRARY_VERSION)
BITMANIPULATION_LIB := $(BUILD_DIR)/libscore_bitmanipulation.so.$(LIBRARY_VERSION)
FILESYSTEM_LIB := $(BUILD_DIR)/libscore_filesystem.so.$(LIBRARY_VERSION)
CONCURRENCY_LIB := $(BUILD_DIR)/libscore_concurrency.so.$(LIBRARY_VERSION)
JSON_LIB := $(BUILD_DIR)/libscore_json.so.$(LIBRARY_VERSION)
OS_LIB := $(BUILD_DIR)/libscore_os.so.$(LIBRARY_VERSION)
LOG_LIB := $(BUILD_DIR)/libscore_log.so.$(LIBRARY_VERSION)
ANALYSIS_LIB := $(BUILD_DIR)/libscore_analysis.so.$(LIBRARY_VERSION)
SAFECPP_LIB := $(BUILD_DIR)/libscore_safecpp.so.$(LIBRARY_VERSION)
QUALITY_LIB := $(BUILD_DIR)/libscore_quality.so.$(LIBRARY_VERSION)
RESULT_LIB := $(BUILD_DIR)/libscore_result.so.$(LIBRARY_VERSION)
FUTURECPP_LIB := $(BUILD_DIR)/libscore_futurecpp.so.$(LIBRARY_VERSION)

# Default target
.PHONY: all
all: libs

# Build all libraries
.PHONY: libs
libs: $(MEMORY_LIB) $(UTILS_LIB) $(CONTAINERS_LIB) $(BITMANIPULATION_LIB) $(FILESYSTEM_LIB) $(CONCURRENCY_LIB) $(JSON_LIB) $(OS_LIB) $(LOG_LIB) $(ANALYSIS_LIB) $(SAFECPP_LIB) $(QUALITY_LIB) $(RESULT_LIB) $(FUTURECPP_LIB)
# Note: All modules now successfully compile

# Memory module
$(MEMORY_LIB): $(MEMORY_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_memory.so.0 -o $@ $^
	@ln -sf libscore_memory.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_memory.so.0
	@ln -sf libscore_memory.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_memory.so

# Utils module
$(UTILS_LIB): $(UTILS_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_utils.so.0 -o $@ $^
	@ln -sf libscore_utils.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_utils.so.0
	@ln -sf libscore_utils.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_utils.so

# Containers module
$(CONTAINERS_LIB): $(CONTAINERS_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_containers.so.0 -o $@ $^
	@ln -sf libscore_containers.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_containers.so.0
	@ln -sf libscore_containers.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_containers.so

# Bitmanipulation module
$(BITMANIPULATION_LIB): $(BITMANIPULATION_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_bitmanipulation.so.0 -o $@ $^
	@ln -sf libscore_bitmanipulation.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_bitmanipulation.so.0
	@ln -sf libscore_bitmanipulation.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_bitmanipulation.so

# Filesystem module
$(FILESYSTEM_LIB): $(FILESYSTEM_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_filesystem.so.0 -o $@ $^
	@ln -sf libscore_filesystem.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_filesystem.so.0
	@ln -sf libscore_filesystem.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_filesystem.so

# Concurrency module
$(CONCURRENCY_LIB): $(CONCURRENCY_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_concurrency.so.0 -o $@ $^
	@ln -sf libscore_concurrency.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_concurrency.so.0
	@ln -sf libscore_concurrency.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_concurrency.so

# JSON module
$(JSON_LIB): $(JSON_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_json.so.0 -o $@ $^
	@ln -sf libscore_json.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_json.so.0
	@ln -sf libscore_json.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_json.so

# OS module
$(OS_LIB): $(OS_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_os.so.0 -o $@ $^
	@ln -sf libscore_os.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_os.so.0
	@ln -sf libscore_os.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_os.so

# Logging module
$(LOG_LIB): $(LOG_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_log.so.0 -o $@ $^
	@ln -sf libscore_log.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_log.so.0
	@ln -sf libscore_log.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_log.so

# Analysis module
$(ANALYSIS_LIB): $(ANALYSIS_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_analysis.so.0 -o $@ $^
	@ln -sf libscore_analysis.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_analysis.so.0
	@ln -sf libscore_analysis.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_analysis.so

# SafeCpp module
$(SAFECPP_LIB): $(SAFECPP_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_safecpp.so.0 -o $@ $^
	@ln -sf libscore_safecpp.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_safecpp.so.0
	@ln -sf libscore_safecpp.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_safecpp.so

# Quality module
$(QUALITY_LIB): $(QUALITY_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_quality.so.0 -o $@ $^
	@ln -sf libscore_quality.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_quality.so.0
	@ln -sf libscore_quality.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_quality.so

# Result module
$(RESULT_LIB): $(RESULT_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_result.so.0 -o $@ $^
	@ln -sf libscore_result.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_result.so.0
	@ln -sf libscore_result.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_result.so

# FutureCpp module
$(FUTURECPP_LIB): $(FUTURECPP_OBJECTS)
	@echo "Creating shared library $@"
	$(CXX) -shared -Wl,-soname,libscore_futurecpp.so.0 -o $@ $^
	@ln -sf libscore_futurecpp.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_futurecpp.so.0
	@ln -sf libscore_futurecpp.so.$(LIBRARY_VERSION) $(BUILD_DIR)/libscore_futurecpp.so

# Compile C++ source files
$(BUILD_DIR)/%.o: %.cpp
	@echo "Compiling $<"
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Compile C source files
$(BUILD_DIR)/%.o: %.c
	@echo "Compiling $<"
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# Test targets (requires GoogleTest)
.PHONY: test-memory
test-memory: $(MEMORY_LIB)
	@echo "Memory module tests require GoogleTest - install libgtest-dev"
	@echo "Test sources: $(MEMORY_TEST_SOURCES)"

# Clean
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

# Create source distribution tarball
# Usage: make dist [VERSION=x.y.z] or make dist x.y.z
.PHONY: dist
dist:
	@if [ "$(filter-out dist,$(MAKECMDGOALS))" ]; then \
		VERSION="$(filter-out dist,$(MAKECMDGOALS))"; \
	else \
		VERSION=$${VERSION:-1.0.0}; \
	fi; \
	NAME="score-baselibs"; \
	TARBALL="$$NAME-$$VERSION.tar.gz"; \
	echo "Creating source tarball: $$TARBALL (version: $$VERSION)"; \
	$(MAKE) clean; \
	git archive --format=tar --prefix="$$NAME-$$VERSION/" HEAD | gzip > "$$TARBALL"; \
	echo "Created: $$TARBALL"; \
	echo "To build RPM: rpmbuild -ta $$TARBALL"

# Build source RPM package
# Usage: make srpm [VERSION=x.y.z] or make srpm x.y.z
.PHONY: srpm
srpm:
	@if [ "$(filter-out srpm,$(MAKECMDGOALS))" ]; then \
		VERSION="$(filter-out srpm,$(MAKECMDGOALS))"; \
	else \
		VERSION=$${VERSION:-1.0.0}; \
	fi; \
	NAME="score-baselibs"; \
	TARBALL="$$NAME-$$VERSION.tar.gz"; \
	echo "Building source RPM for version: $$VERSION"; \
	if [ ! -f "$$TARBALL" ]; then \
		echo "Creating tarball first..."; \
		$(MAKE) dist $$VERSION; \
	fi; \
	echo "Building SRPM from $$TARBALL"; \
	TEMP_DIR=$$(mktemp -d) && \
	cd "$$TEMP_DIR" && \
	cp "$(ROOT_DIR)/$$TARBALL" . && \
	cp "$(ROOT_DIR)/score-baselibs.spec" . && \
	tar -xzf "$$TARBALL" && \
	cp "score-baselibs.spec" "$$NAME-$$VERSION/" && \
	tar -czf "$$TARBALL" "$$NAME-$$VERSION/" && \
	rpmbuild --define "_sourcedir $$TEMP_DIR" --define "_srcrpmdir $(ROOT_DIR)" -bs "score-baselibs.spec" && \
	cd "$(ROOT_DIR)" && \
	rm -rf "$$TEMP_DIR"

# Handle version argument as a target (prevents make from complaining)
%:
	@:

# Install target
.PHONY: install
install: libs
	@echo "Installing score-baselibs to $(DESTDIR)$(PREFIX)"
	# Create directories
	install -d $(DESTDIR)$(LIBDIR)
	install -d $(DESTDIR)$(INCLUDEDIR)
	install -d $(DESTDIR)$(DOCDIR)
	install -d $(DESTDIR)$(DATADIR)

	# Install shared libraries with proper versioning
	install -m 755 build/libscore_memory.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/
	install -m 755 build/libscore_utils.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/
	install -m 755 build/libscore_containers.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/
	install -m 755 build/libscore_bitmanipulation.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/
	install -m 755 build/libscore_filesystem.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/
	install -m 755 build/libscore_concurrency.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/
	install -m 755 build/libscore_json.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/
	install -m 755 build/libscore_os.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/
	install -m 755 build/libscore_log.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/
	install -m 755 build/libscore_analysis.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/
	install -m 755 build/libscore_safecpp.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/
	install -m 755 build/libscore_quality.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/
	install -m 755 build/libscore_result.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/
	install -m 755 build/libscore_futurecpp.so.$(LIBRARY_VERSION) $(DESTDIR)$(LIBDIR)/

	# Create symlinks for development and runtime
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_memory.so.$(LIBRARY_VERSION) libscore_memory.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_memory.so.$(LIBRARY_VERSION) libscore_memory.so
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_utils.so.$(LIBRARY_VERSION) libscore_utils.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_utils.so.$(LIBRARY_VERSION) libscore_utils.so
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_containers.so.$(LIBRARY_VERSION) libscore_containers.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_containers.so.$(LIBRARY_VERSION) libscore_containers.so
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_bitmanipulation.so.$(LIBRARY_VERSION) libscore_bitmanipulation.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_bitmanipulation.so.$(LIBRARY_VERSION) libscore_bitmanipulation.so
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_filesystem.so.$(LIBRARY_VERSION) libscore_filesystem.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_filesystem.so.$(LIBRARY_VERSION) libscore_filesystem.so
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_concurrency.so.$(LIBRARY_VERSION) libscore_concurrency.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_concurrency.so.$(LIBRARY_VERSION) libscore_concurrency.so
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_json.so.$(LIBRARY_VERSION) libscore_json.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_json.so.$(LIBRARY_VERSION) libscore_json.so
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_os.so.$(LIBRARY_VERSION) libscore_os.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_os.so.$(LIBRARY_VERSION) libscore_os.so
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_log.so.$(LIBRARY_VERSION) libscore_log.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_log.so.$(LIBRARY_VERSION) libscore_log.so
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_analysis.so.$(LIBRARY_VERSION) libscore_analysis.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_analysis.so.$(LIBRARY_VERSION) libscore_analysis.so
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_safecpp.so.$(LIBRARY_VERSION) libscore_safecpp.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_safecpp.so.$(LIBRARY_VERSION) libscore_safecpp.so
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_quality.so.$(LIBRARY_VERSION) libscore_quality.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_quality.so.$(LIBRARY_VERSION) libscore_quality.so
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_result.so.$(LIBRARY_VERSION) libscore_result.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_result.so.$(LIBRARY_VERSION) libscore_result.so
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_futurecpp.so.$(LIBRARY_VERSION) libscore_futurecpp.so.0
	cd $(DESTDIR)$(LIBDIR) && ln -sf libscore_futurecpp.so.$(LIBRARY_VERSION) libscore_futurecpp.so

	# Install headers - preserve directory structure
	find score -name "*.h" -o -name "*.hpp" | while read header; do \
		install -D -m 644 "$$header" "$(DESTDIR)$(INCLUDEDIR)/$$header"; \
	done

	# Install FutureCpp headers from include directory
	find score/language/futurecpp/include -name "*.h" -o -name "*.hpp" | while read header; do \
		target_path=$$(echo "$$header" | sed 's|score/language/futurecpp/include/||'); \
		install -D -m 644 "$$header" "$(DESTDIR)$(INCLUDEDIR)/$$target_path"; \
	done

	# Install documentation
	install -m 644 README.md $(DESTDIR)$(DOCDIR)/
	install -m 644 LICENSE $(DESTDIR)$(DOCDIR)/
	install -m 644 NOTICE $(DESTDIR)$(DOCDIR)/

	# Install Makefiles for users
	install -m 644 Makefile $(DESTDIR)$(DATADIR)/Makefile.example
	install -m 644 Makefile.bazel $(DESTDIR)$(DATADIR)/

	# Update ldconfig cache for new shared libraries
	@echo "Updating library cache..."
	ldconfig || true

# Uninstall target
.PHONY: uninstall
uninstall:
	@echo "Uninstalling Score BaseLibs shared libraries..."
	# Remove shared libraries
	rm -f $(DESTDIR)$(LIBDIR)/libscore_memory.so*
	rm -f $(DESTDIR)$(LIBDIR)/libscore_utils.so*
	rm -f $(DESTDIR)$(LIBDIR)/libscore_containers.so*
	rm -f $(DESTDIR)$(LIBDIR)/libscore_bitmanipulation.so*
	rm -f $(DESTDIR)$(LIBDIR)/libscore_filesystem.so*
	rm -f $(DESTDIR)$(LIBDIR)/libscore_concurrency.so*
	rm -f $(DESTDIR)$(LIBDIR)/libscore_json.so*
	rm -f $(DESTDIR)$(LIBDIR)/libscore_os.so*
	rm -f $(DESTDIR)$(LIBDIR)/libscore_log.so*
	rm -f $(DESTDIR)$(LIBDIR)/libscore_analysis.so*
	rm -f $(DESTDIR)$(LIBDIR)/libscore_safecpp.so*
	rm -f $(DESTDIR)$(LIBDIR)/libscore_quality.so*
	rm -f $(DESTDIR)$(LIBDIR)/libscore_result.so*
	rm -f $(DESTDIR)$(LIBDIR)/libscore_futurecpp.so*
	# Remove headers
	rm -rf $(DESTDIR)$(INCLUDEDIR)/score
	# Remove documentation and data
	rm -rf $(DESTDIR)$(DOCDIR)
	rm -rf $(DESTDIR)$(DATADIR)
	# Update ldconfig cache
	ldconfig || true
	@echo "Uninstallation complete."

# Install external dependencies info
.PHONY: deps-info
deps-info:
	@echo "External dependencies needed:"
	@echo "  - GoogleTest (for tests): apt-get install libgtest-dev"
	@echo "  - Boost container: apt-get install libboost-dev"
	@echo "  - nlohmann JSON: apt-get install nlohmann-json3-dev"

# Module-specific builds
.PHONY: build-memory
build-memory: $(MEMORY_LIB)

.PHONY: build-utils
build-utils: $(UTILS_LIB)

.PHONY: build-containers
build-containers: $(CONTAINERS_LIB)

.PHONY: build-bitmanipulation
build-bitmanipulation: $(BITMANIPULATION_LIB)

.PHONY: build-filesystem
build-filesystem: $(FILESYSTEM_LIB)

.PHONY: build-concurrency
build-concurrency: $(CONCURRENCY_LIB)

.PHONY: build-json
build-json: $(JSON_LIB)

.PHONY: build-os
build-os: $(OS_LIB)

.PHONY: build-log
build-log: $(LOG_LIB)

.PHONY: build-analysis
build-analysis: $(ANALYSIS_LIB)

.PHONY: build-safecpp
build-safecpp: $(SAFECPP_LIB)

.PHONY: build-quality
build-quality: $(QUALITY_LIB)

.PHONY: build-result
build-result: $(RESULT_LIB)

.PHONY: build-futurecpp
build-futurecpp: $(FUTURECPP_LIB)

# Debug info
.PHONY: debug-info
debug-info:
	@echo "Build directory: $(BUILD_DIR)"
	@echo "Memory sources: $(MEMORY_SOURCES)"
	@echo "Memory objects: $(MEMORY_OBJECTS)"
	@echo "Include dirs: $(INCLUDE_DIRS)"
	@echo "CXX flags: $(CXXFLAGS)"

# Show help
.PHONY: help
help:
	@echo "Score-baselibs Native Makefile"
	@echo ""
	@echo "Main targets:"
	@echo "  all              - Build all shared libraries (default)"
	@echo "  libs             - Build all shared libraries"
	@echo "  install          - Install shared libraries, headers, and symlinks"
	@echo "  uninstall        - Remove installed libraries and headers"
	@echo "  clean            - Clean build artifacts"
	@echo "  dist [VERSION]   - Create source distribution tarball"
	@echo "  srpm [VERSION]   - Build source RPM package"
	@echo "                     Usage: make dist/srpm 1.2.3 or VERSION=1.2.3 make dist/srpm"
	@echo ""
	@echo "Module builds:"
	@echo "  build-memory        - Build memory module"
	@echo "  build-utils         - Build utils module"
	@echo "  build-containers    - Build containers module"
	@echo "  build-bitmanipulation - Build bitmanipulation module"
	@echo "  build-filesystem    - Build filesystem module"
	@echo "  build-concurrency   - Build concurrency module"
	@echo "  build-json          - Build JSON module"
	@echo "  build-os            - Build OS module"
	@echo "  build-log           - Build logging module"
	@echo "  build-analysis      - Build analysis/tracing module"
	@echo "  build-safecpp       - Build language/safecpp module"
	@echo "  build-quality       - Build quality module"
	@echo "  build-result        - Build result module"
	@echo "  build-futurecpp     - Build language/futurecpp module"
	@echo ""
	@echo "Testing:"
	@echo "  test-memory      - Info about memory tests"
	@echo ""
	@echo "Utilities:"
	@echo "  deps-info        - Show external dependencies"
	@echo "  debug-info       - Show build configuration"
	@echo ""
	@echo "This Makefile builds shared libraries (.so) with proper versioning."
	@echo "Compiles C++ directly with gcc/g++, no Bazel required."

# Pattern rules for compilation
$(BUILD_DIR)/%.o: %.cpp
	@echo "Compiling $<"
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: %.c
	@echo "Compiling $< (C)"
	$(CC) $(CFLAGS) -c $< -o $@