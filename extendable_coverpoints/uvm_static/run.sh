qverilog \
  +incdir+sv sv/test.sv sv/top.sv -novopt \
  -R \
    +UVM_TESTNAME=test_cov_collectors -gui -do "run -all"
