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


class test_objection extends test;
  typedef class scoreboard_with_objection;


  virtual function void build_phase(uvm_phase phase);
    apb_pipeline_tb::scoreboard::type_id::set_type_override(
      scoreboard_with_objection::get_type());
    super.build_phase(phase);
  endfunction


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  `uvm_component_utils(test_objection)


  class scoreboard_with_objection extends apb_pipeline_tb::scoreboard;
    virtual function void write_north(amiq_apb_pkg::amiq_apb_mon_item item);
      uvm_phase run_phase;

      super.write_north(item);
      if (num_seen_north_items % 2 == 1)
        return;

      run_phase = uvm_run_phase::get();
      run_phase.raise_objection(this);
    endfunction


    virtual function void write_south(amiq_apb_pkg::amiq_apb_mon_item item);
      uvm_phase run_phase;

      super.write_south(item);
      if (num_seen_south_items % 2 == 1)
        return;

      run_phase = uvm_run_phase::get();
      run_phase.drop_objection(this);
    endfunction


    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    `uvm_component_utils(scoreboard_with_objection)
  endclass
endclass
