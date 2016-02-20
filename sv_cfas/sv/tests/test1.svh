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


class test1 extends uvm_test;
  `uvm_component_utils(test1)
  
  some_agent agent;
  
  function new(string name = "test1", uvm_component parent = null);
    super.new(name, parent);
  endfunction // new

  function void build_phase(uvm_phase phase);
    agent = some_agent::type_id::create("env", this);
  endfunction // build_phase
  
  task run_phase(uvm_phase phase);
    some_sequence seq = some_sequence::type_id::create("seq");
    if (!seq.randomize())
      `uvm_error("RANDERR", "Randomization error")
    seq.start(agent.sequencer);
  endtask

endclass // test1
