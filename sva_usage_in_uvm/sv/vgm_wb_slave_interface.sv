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


interface vgm_wb_slave_interface(input bit RST_I, input bit CLK_I);
  logic CYC_I;
  logic STB_I;
  logic [32:0] ADR_I;
  logic ACK_O;

  default clocking @(posedge CLK_I);
  endclocking

  bit m_is_pipelined;


  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `define error(MSG) \
    begin \
      if (uvm_report_enabled(UVM_NONE, UVM_ERROR, "WBSLV")) \
        proxy.uvm_report_error("WBSLV", MSG, UVM_NONE, \
          `uvm_file, `uvm_line); \
    end


  cyc_held_until_end : assert property (
    $rose(STB_I) |-> CYC_I
      ##0 (ACK_O or ##1 CYC_I throughout
        (!m_is_pipelined && STB_I || ACK_O) [->1])
  )
  else
    `error("CYC_I must be held until transfer end");

  stb_held_until_ack : assert property (
    disable iff (m_is_pipelined)
      $rose(STB_I) |->
        STB_I throughout ACK_O [->1]
  )
  else
    `error("STB_I must be held until ACK_O");

  adr_not_unknown : assert property (
    STB_I |-> !$isunknown(ADR_I)
  )
  else
    `error("ADR_I must be at a known level during a transfer")


  typedef class checker_proxy;
  checker_proxy proxy;

  class checker_proxy extends vgm_wb::checker_proxy;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    virtual function void set_pipelined(bit is_pipelined);
      m_is_pipelined = is_pipelined;
    endfunction
  endclass

  class sva_checker_wrapper extends vgm_wb::sva_checker_wrapper;
    virtual function checker_proxy get_proxy(string name, uvm_component parent);
      if (proxy == null)
        proxy = new(name, parent);
      return proxy;
    endfunction
  endclass

  sva_checker_wrapper checker_wrapper = new();


  `undef error
endinterface
