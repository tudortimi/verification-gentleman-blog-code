#!/bin/bash

vsim -c -pedanticerrors -novopt -do "run -all" -solvefaildebug top
