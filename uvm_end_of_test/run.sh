#!/bin/env bash

opts=`getopt -o g --long gui -n '$0' -- "$@"`
eval set -- "$opts"


gui_args=""

while true ; do
    case "$1" in
        -g|--gui) gui_args="-gui -linedebug -input debug.tcl" ; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done


if [ "$#" -gt 1 ]; then
    echo "Illegal number of arguments"
    exit 1
fi

test="test"

if [ "$#" -eq 1 ]; then
    test="$1"
fi


irun \
    -nowarn TSNSPK:DSEMEL:DSEM2009 \
    \
    -uvm \
    \
    -define AMIQ_APB_MAX_SEL_WIDTH=1 \
    -incdir dependencies/amiq_apb/sv \
    dependencies/amiq_apb/sv/amiq_apb_pkg.sv \
    \
    -incdir sv/apb_pipeline_tb \
    sv/apb_pipeline_tb/apb_pipeline_tb.sv \
    -incdir sv \
    sv/apb_pipeline.sv \
    sv/top.sv \
    $gui_args \
    +UVM_TESTNAME=$test
