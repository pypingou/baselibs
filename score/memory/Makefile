# Memory module Makefile
# Inherits from parent Makefile

include ../../Makefile

MODULE_PATH := //score/memory

.PHONY: all build test clean
all: build

build:
	$(call run_bazel,build $(MODULE_PATH)/...)

test:
	$(call run_bazel,test $(MODULE_PATH)/...)

test-unit:
	$(call run_bazel,test --test_tag_filters=unit $(MODULE_PATH)/...)

# Build specific targets
build-string-literal:
	$(call run_bazel,build $(MODULE_PATH):string_literal)

build-endianness:
	$(call run_bazel,build $(MODULE_PATH):endianness)

build-string-comparison:
	$(call run_bazel,build $(MODULE_PATH):string_comparison_adaptor)

build-split-string:
	$(call run_bazel,build $(MODULE_PATH):split_string_view)

build-pmr-ring-buffer:
	$(call run_bazel,build $(MODULE_PATH):pmr_ring_buffer)

# Run specific tests
test-endianness:
	$(call run_bazel,test $(MODULE_PATH):endianness_unit_test)

test-string-comparison:
	$(call run_bazel,test $(MODULE_PATH):string_comparison_adaptor_unit_test)

test-split-string:
	$(call run_bazel,test $(MODULE_PATH):split_string_view_unit_test)

test-pmr-ring-buffer:
	$(call run_bazel,test $(MODULE_PATH):pmr_ring_buffer_unit_test)

test-suite:
	$(call run_bazel,test $(MODULE_PATH):unit_test_suite)

clean:
	$(call run_bazel,clean)