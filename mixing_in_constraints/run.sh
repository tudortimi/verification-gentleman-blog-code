#!/usr/bin/bash

qverilog +incdir+sv sv/vgm_ahb_pkg.sv +incdir+tests tests/tests.sv top.sv \
  -R +UVM_TESTNAME=$1 -
