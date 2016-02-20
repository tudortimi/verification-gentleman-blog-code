#!/usr/bin/bash

rm -rf work
vlib work
vlog +incdir+sv sv/drain_time_pkg.sv sv/top.sv
