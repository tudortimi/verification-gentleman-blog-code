#!/usr/bin/bash

vsim -novopt -do "run -all" +UVM_TESTNAME=example_reg_test top
