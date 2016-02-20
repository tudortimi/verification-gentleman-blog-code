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


class random_access_sequence extends uvm_sequence #(vgm_ahb_item);
  `uvm_object_utils(random_access_sequence)


  function new(string name = "random_access_sequence");
    super.new(name);
  endfunction


  virtual task body();
    req = vgm_ahb_item::type_id::create("req");

    for (int i = 0; i < 30; i++) begin
      start_item(req);
      if (!req.randomize())
        `uvm_error("RANDERR", "Randomization error")
      finish_item(req);
    end
  endtask
endclass



class test_random_access extends vgm_ahb_base_test;
  `uvm_component_utils(test_random_access)


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  task run_phase(uvm_phase phase);
    random_access_sequence seq = random_access_sequence::type_id::create("seq");
    seq.start(sequencer);
  endtask
endclass
