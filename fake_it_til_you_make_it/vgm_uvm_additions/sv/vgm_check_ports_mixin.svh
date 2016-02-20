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


class vgm_check_ports_mixin #(type T = uvm_component) extends T;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    check_ports();
  endfunction
  
  function void check_ports();
    `uvm_info("VGM", "I'm checking if all of my ports are connected", UVM_LOW);
  endfunction
  
endclass
