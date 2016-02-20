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

  function new(string name, uvm_component parent);
    super.new(name, parent);
    model = new("model");
    model.build();
    model.lock_model();
    model.default_map.set_auto_predict();
  endfunction
endclass


virtual class test_ahb_base extends test_base;
  vgm_ahb::master_agent ahb_agent;
  ahb_reg_adapter reg_adapter;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    dut = generic_dut::type_id::create("dut", this);
    ahb_agent = vgm_ahb::master_agent::type_id::create("ahb_agent", this);
    reg_adapter = ahb_reg_adapter::type_id::create("reg_adapter");
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    ahb_agent.driver.socket.connect(dut.socket);
    model.default_map.set_sequencer(ahb_agent.sequencer, reg_adapter);
  endfunction
endclass


virtual class test_apb_base extends test_base;
  vgm_apb::master_agent apb_agent;
  apb_reg_adapter reg_adapter;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    dut = generic_dut::type_id::create("dut", this);
    apb_agent = vgm_apb::master_agent::type_id::create("apb_agent", this);
    reg_adapter = apb_reg_adapter::type_id::create("reg_adapter");
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    apb_agent.driver.socket.connect(dut.socket);
    model.default_map.set_sequencer(apb_agent.sequencer, reg_adapter);
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
