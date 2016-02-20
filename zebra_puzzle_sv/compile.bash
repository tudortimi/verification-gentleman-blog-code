#!/bin/bash

if [ ! -d work ]; then
    vlib work
fi

vlog -pedanticerrors sv/zebra_puzzle.sv
