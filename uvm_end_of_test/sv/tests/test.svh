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


class test extends uvm_test;
  apb_pipeline_tb::env tb_env;

  virtual function void build_phase(uvm_phase phase);
    tb_env = apb_pipeline_tb::env::type_id::create("tb_env", this);
  endfunction


  typedef class no_delay_apb_item;
  typedef class no_wait_apb_item;

  virtual function void start_of_simulation_phase(uvm_phase phase);
    amiq_apb_pkg::amiq_apb_master_drv_item::type_id::set_type_override(
      no_delay_apb_item::get_type());
    amiq_apb_pkg::amiq_apb_slave_drv_item::type_id::set_type_override(
      no_wait_apb_item::get_type());
  endfunction


  virtual task run_phase(uvm_phase phase);
    apb_pipeline_tb::pipeline_sequence seq =
      apb_pipeline_tb::pipeline_sequence::type_id::create("seq", this);

    phase.raise_objection(this);

    #1; // Race condition w.r.t. reset
    seq.start(tb_env.master_agent.sequencer);

    phase.drop_objection(this);
  endtask


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  `uvm_component_utils(test)


  class no_delay_apb_item extends amiq_apb_pkg::amiq_apb_master_drv_item;
    constraint no_delay {
      trans_delay == 0;
    }

    function new(string name = "no_delay_apb_item");
      super.new(name);
    endfunction

    `uvm_object_utils(no_delay_apb_item)
  endclass


  class no_wait_apb_item extends amiq_apb_pkg::amiq_apb_slave_drv_item;
    constraint no_delay {
      wait_time == 1;
    }

    function new(string name = "no_wait_apb_item");
      super.new(name);
    endfunction

    `uvm_object_utils(no_wait_apb_item)
  endclass
endclass
