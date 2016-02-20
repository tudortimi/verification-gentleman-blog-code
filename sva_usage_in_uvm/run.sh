#!/usr/bin/bash

if [[ "$#" -ne 1 ]]; then
  echo "No test specified"
  exit 1
fi

test=$1


qverilog \
  -novopt \
  +incdir+sv \
  sv/vgm_wb.sv \
  sv/vgm_wb_slave_interface.sv \
  sv/top.sv \
  -R +UVM_TESTNAME=$test -
