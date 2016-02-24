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


class test_phase_ready_to_end extends test;
  typedef class scoreboard_with_phase_ready_to_end;


  virtual function void build_phase(uvm_phase phase);
    apb_pipeline_tb::scoreboard::type_id::set_type_override(
      scoreboard_with_phase_ready_to_end::get_type());
    super.build_phase(phase);
  endfunction


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  `uvm_component_utils(test_phase_ready_to_end)


  class scoreboard_with_phase_ready_to_end extends apb_pipeline_tb::scoreboard;
    virtual function void phase_ready_to_end(uvm_phase phase);
      if (phase.get_name != "run")
        return;

      if (item_stream.size() != 0) begin
        phase.raise_objection(this);
        fork
          delay_phase_end(phase);
        join_none
      end
    endfunction


    virtual task delay_phase_end(uvm_phase phase);
      wait (item_stream.size() == 0);
      phase.drop_objection(this);
    endtask


    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    `uvm_component_utils(scoreboard_with_phase_ready_to_end)
  endclass
endclass
