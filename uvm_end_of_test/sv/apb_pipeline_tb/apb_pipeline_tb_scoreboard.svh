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


class scoreboard extends uvm_scoreboard;
  `uvm_analysis_imp_decl(_north)
  `uvm_analysis_imp_decl(_south)

  uvm_analysis_imp_north #(amiq_apb_mon_item, scoreboard) north_aimp;
  uvm_analysis_imp_south #(amiq_apb_mon_item, scoreboard) south_aimp;

  protected int unsigned num_seen_north_items;
  protected int unsigned num_seen_south_items;

  protected amiq_apb_mon_item item_stream[$];


  virtual function void write_north(amiq_apb_mon_item item);
    num_seen_north_items++;
    if (num_seen_north_items % 2 == 1)
      return;

    `uvm_info("WRNORTH", "Got a north item", UVM_NONE)
    item_stream.push_back(item);
  endfunction


  virtual function void write_south(amiq_apb_mon_item item);
    num_seen_south_items++;
    if (num_seen_south_items % 2 == 1)
      return;

    `uvm_info("WRSOUTH", "Got a south item", UVM_NONE)
    if (!item.compare(item_stream.pop_front()))
      `uvm_error("DUTERR", "Mismatch")
  endfunction


  virtual function void check_phase(uvm_phase phase);
    if (item_stream.size() != 0)
      `uvm_error("DUTERR", "There are still unchecked items")
  endfunction


  function new(string name, uvm_component parent);
    super.new(name, parent);
    north_aimp = new("north_aimp", this);
    south_aimp = new("south_aimp", this);
  endfunction

  `uvm_component_utils(apb_pipeline_tb::scoreboard)
endclass
