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


class some_sequence extends uvm_sequence #(some_item);
  `uvm_object_utils(some_sequence)
  
  rand int unsigned num_items;
  rand some_item req;

  constraint max_items_c {
    num_items >= 5;
    num_items <= 10;
  }
  
  constraint only_comms_c {
    req.mode inside { TX_SHORT, TX_LONG, RX_SHORT, RX_LONG };
  };

  function new(string name = "some_sequence");
    super.new(name);
  endfunction
  
  function void pre_randomize();
    req = some_item::type_id::create("req");
  endfunction // pre_randomize
  
  task body();
    start_item(req);
    if (!req.randomize() with { mode == CONFIG; })
      `uvm_error("RANDERR", "Randomization error")
    finish_item(req);

    // start num_items comms
    repeat (num_items) begin
      start_item(req);
      if (!this.randomize(req))
        `uvm_error("RANDERR", "Randomization error")

      // randomize allocates a new object, even though the standard forbids it
      // - happens on two different simulators
      req.set_item_context(this, get_sequencer);
      
      finish_item(req);
    end

    start_item(req);
    if (!req.randomize() with { mode == SHUTDOWN; })
      `uvm_error("RANDERR", "Randomization error")
    finish_item(req);
  endtask // body
  
endclass // some_sequence
