#!/usr/bin/bash

rm -rf work
vlib work
vlog +incdir+../sv ../sv/vgm_ahb_pkg.sv ../sv/top.sv
