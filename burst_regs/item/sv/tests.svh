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


virtual class test_base extends uvm_test;
  generic_dut dut;

  regs::some_reg_block model;
  uvm_sequencer #(uvm_reg_item) reg_sequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    model = new("model");
    model.build();
    model.lock_model();
    model.default_map.set_auto_predict();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    dut = generic_dut::type_id::create("dut", this);
    reg_sequencer = uvm_sequencer #(uvm_reg_item)::type_id::create(
      "reg_sequencer", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    model.default_map.set_sequencer(reg_sequencer);
  endfunction
endclass


virtual class test_ahb_base extends test_base;
  vgm_ahb::master_agent ahb_agent;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ahb_agent = vgm_ahb::master_agent::type_id::create("ahb_agent", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ahb_agent.driver.socket.connect(dut.socket);
  endfunction

  virtual function void start_of_simulation_phase(uvm_phase phase);
    vgm_ahb::reg_xlate_sequence reg2ahb_seq =
      vgm_ahb::reg_xlate_sequence::type_id::create("reg2ahb_seq");
    reg2ahb_seq.reg_seqr = reg_sequencer;
    uvm_config_db #(uvm_sequence_base)::set(ahb_agent.sequencer, "run_phase",
      "default_sequence", reg2ahb_seq);
  endfunction
endclass


virtual class test_apb_base extends test_base;
  vgm_apb::master_agent apb_agent;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_agent = vgm_apb::master_agent::type_id::create("apb_agent", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    apb_agent.driver.socket.connect(dut.socket);
  endfunction

  virtual function void start_of_simulation_phase(uvm_phase phase);
    vgm_apb::reg_xlate_sequence reg2apb_seq =
      vgm_apb::reg_xlate_sequence::type_id::create("reg2apb_seq");
    reg2apb_seq.reg_seqr = reg_sequencer;
    uvm_config_db #(uvm_sequence_base)::set(apb_agent.sequencer, "run_phase",
      "default_sequence", reg2apb_seq);
  endfunction
endclass



class test_ahb_single_write extends test_ahb_base;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    write_some_reg0 seq = new("seq");
    seq.model = model;

    phase.raise_objection(this);
    seq.start(null);
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(test_ahb_single_write)
endclass


class test_ahb_burst_write extends test_ahb_base;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    write_some_regs seq = new("seq");
    seq.model = model;

    phase.raise_objection(this);
    seq.start(null);
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(test_ahb_burst_write)
endclass



class test_apb_single_write extends test_apb_base;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    write_some_reg0 seq = new("seq");
    seq.model = model;

    phase.raise_objection(this);
    seq.start(null);
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(test_apb_single_write)
endclass


class test_apb_burst_write extends test_apb_base;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    write_some_regs seq = new("seq");
    seq.model = model;

    phase.raise_objection(this);
    seq.start(null);
    #100;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(test_apb_burst_write)
endclass
