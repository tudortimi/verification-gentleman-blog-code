#!/usr/bin/bash

if [[ "$1" == "" ]]; then
    echo "No top file specified"
    exit 1
fi

top=$1

qverilog \
    +incdir+sv \
    sv/drivable_pkg.sv \
    sv/insurable_pkg.sv \
    sv/$top.sv
