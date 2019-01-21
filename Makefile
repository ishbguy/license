UNIT_TEST := $(PWD)/baux/bin/baux-test.sh
TEST_DIR := $(PWD)/test

all : test

.PHONY : test
test :
	$(UNIT_TEST) $(TEST_DIR)
