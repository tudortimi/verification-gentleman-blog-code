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


class write_ahb_item extends ahb_item;
  `uvm_object_utils(write_ahb_item)

  constraint write {
    direction == WRITE;
  }

  function new(string name = "write_ahb_item");
    super.new(name);
  endfunction
endclass



class read_ahb_item extends ahb_item;
  `uvm_object_utils(read_ahb_item)

  constraint read {
    direction == READ;
  }

  function new(string name = "read_ahb_item");
    super.new(name);
  endfunction
endclass



class test2 extends test1;
  `uvm_component_utils(test2)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    ahb_item::type_id::set_inst_override(write_ahb_item::get_type(),
      "ahb0.sequencer.*", this);
    ahb_item::type_id::set_inst_override(read_ahb_item::get_type(),
      "ahb1.sequencer.*", this);
  endfunction
endclass
