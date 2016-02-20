#!/usr/bin/bash

test=drain_time_run_test

if [ "$#" == 1 ]; then
    test="$1"
fi

vsim -novopt -do "run -all" +UVM_TESTNAME=$test top
