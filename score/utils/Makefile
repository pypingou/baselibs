# Utils module Makefile
# Inherits from parent Makefile

include ../../Makefile

MODULE_PATH := //score/utils

.PHONY: all build test clean
all: build

build:
	$(call run_bazel,build $(MODULE_PATH)/...)

test:
	$(call run_bazel,test $(MODULE_PATH)/...)

test-unit:
	$(call run_bazel,test --test_tag_filters=unit $(MODULE_PATH)/...)

clean:
	$(call run_bazel,clean)