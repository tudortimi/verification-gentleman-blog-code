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


class reg_adapter extends uvm_reg_adapter;
  function new(string name = "reg_adapter");
    super.new(name);
  endfunction

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    burst b = burst::type_id::create("burst");
    if (!b.randomize() with {
      address == rw.addr;
      kind == SINGLE;
      direction == rw.kind == UVM_READ ? READ : WRITE;
      data[0] == rw.data;
    })
      `uvm_fatal("RANDERR", "Randomization error")
    return b;
  endfunction

  virtual function void bus2reg(uvm_sequence_item bus_item,
    ref uvm_reg_bus_op rw);
  endfunction

  `uvm_object_utils(reg_adapter)
endclass
