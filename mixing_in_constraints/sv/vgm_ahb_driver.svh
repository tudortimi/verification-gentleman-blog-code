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


class vgm_ahb_driver extends uvm_driver #(vgm_ahb_item);
  `uvm_component_utils(vgm_ahb_driver)


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get(req);
      $display(req.convert2string());
    end
  endtask
endclass
