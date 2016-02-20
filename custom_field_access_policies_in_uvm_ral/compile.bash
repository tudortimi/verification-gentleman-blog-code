#!/usr/bin/bash

rm -rf work
vlib work
vlog +incdir+sv sv/example_reg_pkg.sv sv/top.sv
