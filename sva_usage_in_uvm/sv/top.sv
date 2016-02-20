// Copyright 2015 Tudor Timisescu (verificationgentleman.com)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import uvm_pkg::*;
`include "uvm_macros.svh"

`include "test.svh"


module top;
  bit rst, clk;
  always #1 clk = ~clk;
  default clocking @(posedge clk);
  endclocking

  vgm_wb_slave_interface slave_if0(rst, clk);

  initial begin
    slave_if0.STB_I = 0;
    slave_if0.ADR_I = 0;
    slave_if0.ACK_O = 0;

    ##1 slave_if0.CYC_I <= 1;
        slave_if0.STB_I <= 1;
    ##2 slave_if0.ACK_O <= 1;
    ##1 slave_if0.STB_I <= 0;
        slave_if0.ACK_O <= 0;
        slave_if0.CYC_I <= 0;

    ##5 slave_if0.CYC_I <= 1;
        slave_if0.STB_I <= 1;
    ##3 slave_if0.STB_I <= 0;
        slave_if0.CYC_I <= 0;
  end


  vgm_wb_slave_interface slave_if1(rst, clk);

  initial begin
    slave_if1.STB_I = 0;
    slave_if1.ADR_I = 0;
    slave_if1.ACK_O = 0;

    ##5 slave_if1.CYC_I <= 1;
        slave_if1.STB_I <= 1;
    ##3 slave_if1.STB_I <= 0;
        slave_if1.CYC_I <= 0;

    ##1 slave_if1.CYC_I <= 1;
        slave_if1.STB_I <= 1;
        slave_if1.ADR_I <= 'x;
        slave_if1.ACK_O <= 1;
    ##1 slave_if1.STB_I <= 0;
        slave_if1.ACK_O <= 0;
        slave_if1.CYC_I <= 0;
  end


  initial
    run_test();

  initial begin
    uvm_config_db #(virtual vgm_wb_slave_interface)::set(null, "*", "vif",
      slave_if0);

    uvm_config_db #(vgm_wb::sva_checker_wrapper)::set(null, "*.slave_if0_agent",
      "checker_wrapper", slave_if0.checker_wrapper);
    uvm_config_db #(vgm_wb::sva_checker_wrapper)::set(null, "*.slave_if1_agent",
      "checker_wrapper", slave_if1.checker_wrapper);
  end
endmodule
