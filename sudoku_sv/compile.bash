#!/bin/bash

if [ ! -d work ]; then
    vlib work
fi

vlog sv/sudoku.sv

