#!/bin/bash

test_name="test1"

if [[ "$1" != "" ]]; then
    test_name="$1"
fi

qverilog +define+UVM_NO_DEPRECATED +incdir+sv +incdir+sv/tests sv/some_pkg.sv sv/tests/tests_pkg.sv sv/top.sv -R +UVM_TESTNAME=$test_name -solvefaildebug
