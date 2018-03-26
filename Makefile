TEST_DIR := $(shell pwd)/test

all : test

.PHONY : test
test :
	$(TEST_DIR)/test/test-license.sh
