// Copyright 2016 Tudor Timisescu (verificationgentleman.com)
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


module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "tests/test.svh"
  `include "tests/test_objection.svh"
  `include "tests/test_delay.svh"
  `include "tests/test_drain_time.svh"
  `include "tests/test_phase_ready_to_end.svh"


  bit reset_n = 1;
  bit clk;

  always #1 clk = ~clk;

  initial begin
    reset_n <= 0;
    @(negedge clk);
    @(negedge clk);
    reset_n <= 1;
  end


  amiq_apb_if north_if (.clk(clk));
  assign north_if.reset_n = reset_n;
  assign north_if.ready = 1;
  assign north_if.slverr = 0;

  amiq_apb_if south_if (.clk(clk));
  assign south_if.reset_n = reset_n;
  assign south_if.addr = 0;
  assign south_if.write = 1;
  assign south_if.prot = 0;
  assign south_if.strb = '1;


  initial begin
    uvm_config_db #(virtual amiq_apb_if)::set(null, "uvm_test_top.tb_env",
      "north_vif", north_if);
    uvm_config_db #(virtual amiq_apb_if)::set(null, "uvm_test_top.tb_env",
      "south_vif", south_if);

    run_test("test_delay");
  end


  apb_pipeline dut(
    reset_n,
    clk,
    north_if.sel[0],
    north_if.enable,
    north_if.wdata,
    south_if.sel[0],
    south_if.enable,
    south_if.wdata
  );
endmodule
