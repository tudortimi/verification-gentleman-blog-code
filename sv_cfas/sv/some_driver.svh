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


class some_driver extends uvm_driver #(some_item);
  `uvm_component_utils(some_driver)

  function new(string name = "some_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction // new
 
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get(req);
      req.print();
    end
  endtask // run_phase
  
endclass
