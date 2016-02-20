qverilog \
    +incdir+../vgm_ahb/sv ../vgm_ahb/sv/vgm_ahb.sv \
    +incdir+../vgm_apb/sv ../vgm_apb/sv/vgm_apb.sv \
    +incdir+../regs/sv ../regs/sv/regs.sv \
    +incdir+sv +incdir+.. sv/top.sv \
    -R +UVM_TESTNAME=$1
