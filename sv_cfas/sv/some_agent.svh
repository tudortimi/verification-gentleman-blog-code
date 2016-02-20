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


class some_agent extends uvm_env;
  `uvm_component_utils(some_agent)
  
  some_driver                driver;
  uvm_sequencer #(some_item) sequencer;

  function new(string name = "some_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction // new
  
  function void build_phase(uvm_phase phase);
    driver    = some_driver::type_id::create("driver", this);
    sequencer = uvm_sequencer #(some_item)::type_id::create("sequencer", this);
  endfunction // build_phase

  function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction // connect_phase
  
endclass // some_agent
