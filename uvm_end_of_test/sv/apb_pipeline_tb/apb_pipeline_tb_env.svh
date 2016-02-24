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


class env extends uvm_env;
  amiq_apb_master_agent_config master_cfg;
  amiq_apb_master_agent master_agent;

  amiq_apb_slave_agent_config slave_cfg;
  amiq_apb_slave_agent slave_agent;

  scoreboard sb;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(input uvm_phase phase);
    build_master();
    build_slave();

    sb = scoreboard::type_id::create("sb", this);
  endfunction


  virtual function void connect_phase(uvm_phase phase);
    master_agent.monitor.output_port.connect(sb.north_aimp);
    slave_agent.monitor.output_port.connect(sb.south_aimp);
  endfunction


  protected virtual function void build_master();
    master_cfg = amiq_apb_master_agent_config::type_id::create("master_cfg",
      this);
    master_cfg.set_number_of_slaves(1);
    master_cfg.set_dut_vif(get_vif("north_vif"));
    uvm_config_db #(amiq_apb_agent_config)::set(this, "master_agent",
      "agent_config", master_cfg);
    master_agent = amiq_apb_master_agent::type_id::create("master_agent", this);
  endfunction


  protected virtual function void build_slave();
    slave_cfg = amiq_apb_slave_agent_config::type_id::create("slave_cfg",
      this);
    slave_cfg.set_dut_vif(get_vif("south_vif"));
    slave_cfg.set_slave_index(0);
    uvm_config_db #(amiq_apb_agent_config)::set(this, "slave_agent",
      "agent_config", slave_cfg);
    slave_agent = amiq_apb_slave_agent::type_id::create("slave_agent", this);
  endfunction


  protected function virtual amiq_apb_if get_vif(string key);
    virtual amiq_apb_if vif;
    if (!uvm_config_db#(virtual amiq_apb_if)::get(this, "", key, vif))
      `uvm_fatal(get_name(), $sformatf("Could not get %s", key))
    return vif;
  endfunction


  `uvm_component_utils(apb_pipeline_tb::env)
endclass
