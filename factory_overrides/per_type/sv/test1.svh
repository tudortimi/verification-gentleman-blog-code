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


class main_ahb_sequence extends ahb_sequence_base;
  `uvm_object_utils(main_ahb_sequence)

  rand int unsigned count;

  constraint count_range {
    count inside { [10:20] };
  }

  function new(string name = "main_ahb_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat (count) begin
      ahb_item item;
      `uvm_do(item)
    end
  endtask
endclass



class test1 extends test_base;
  `uvm_component_utils(test1)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_config_db #(uvm_object_wrapper)::set(this, "ahb.sequencer.run_phase",
      "default_sequence", main_ahb_sequence::get_type());
  endfunction
endclass
