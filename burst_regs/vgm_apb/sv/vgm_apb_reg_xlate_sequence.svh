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


class reg_xlate_sequence extends uvm_reg_sequence #(uvm_sequence #(transfer));
  function new(string name = "reg_xlate_sequence");
    super.new(name);
  endfunction


  virtual task do_reg_item(uvm_reg_item rw);
    transfer t = transfer::type_id::create("transfer");

    foreach (rw.value[i]) begin
      if (!t.randomize() with {
        if (rw.kind inside { UVM_READ, UVM_BURST_READ })
          direction == READ;
        else
          direction == WRITE;
        address == rw.offset + 4 * i;
        data == rw.value[i];
      })
        `uvm_fatal("RNDERR", "Randomization error")
      `uvm_send(t)
    end
  endtask


  `uvm_object_utils(reg_xlate_sequence)
endclass
