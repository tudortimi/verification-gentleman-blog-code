vlog +incdir+uvm uvm/uvm.sv

# I need to split the UVC compiles into two to make sure correct include files
# get picked up. It would have been so nice if the directory of the package
# were also automatically considered.
vlog +incdir+vgm_ahb vgm_ahb/vgm_ahb.sv
vlog +incdir+vgm_axi vgm_axi/vgm_axi.sv

qverilog +incdir+tb tb/tb.sv tb/top.sv
