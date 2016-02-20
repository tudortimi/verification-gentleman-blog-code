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


class no_stb_until_ack_error_catcher extends uvm_report_catcher;
  function new(string name);
    super.new(name);
  endfunction

  function action_e catch();
    if (get_severity() == UVM_ERROR && uvm_is_match("*STB_I*", get_message()))
      set_severity(UVM_WARNING);
    return THROW;
  endfunction
endclass


class test extends uvm_test;
  vgm_wb::agent slave_if0_agent;
  vgm_wb::agent slave_if1_agent;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    slave_if0_agent = vgm_wb::agent::type_id::create("slave_if0_agent", this);
    slave_if1_agent = vgm_wb::agent::type_id::create("slave_if1_agent", this);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    no_stb_until_ack_error_catcher catcher = new("catcher");
    uvm_report_cb::add(slave_if0_agent.sva_checker, catcher);
  endfunction

  virtual function void start_of_simulation_phase(uvm_phase phase);
    slave_if1_agent.sva_checker.set_pipelined(1);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    repeat (15)
      #2;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(test)
endclass
