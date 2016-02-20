// Copyright 2014 Tudor Timisescu (verificationgentleman.com)
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


class test2 extends test1;
  `uvm_component_utils(test2)

  function new(string name = "test2", uvm_component parent = null);
    super.new(name, parent);
  endfunction // new

  function void start_of_simulation_phase(uvm_phase phase);
    set_type_override_by_type(some_sequence::get_type(), some_other_sequence::get_type());
  endfunction // start_of_simulation_phase
  
endclass // test2
