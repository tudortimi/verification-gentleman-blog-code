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


`ifndef EXAMPLE_REG_ITEM
`define EXAMPLE_REG_ITEM

class example_reg_item extends uvm_sequence_item;
  `uvm_object_utils(example_reg_item)
  
  int unsigned addr;
  int unsigned data;
  bit write;
  
  function new(string name = "example_reg_item");
    super.new(name);
  endfunction
endclass


class example_reg_adapter extends uvm_reg_adapter;
  `uvm_object_utils(example_reg_adapter)
  
  function new(string name = "example_reg_adapter");
    super.new(name);
  endfunction
  
  virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    example_reg_item item;
    if (!$cast(item, bus_item)) begin
      `uvm_fatal("WRONG_TYPE", "Provided bus_item is not of the correct type")
      return;
    end
    rw.kind = item.write ? UVM_WRITE : UVM_READ;
    rw.addr = item.addr;
    rw.data = item.data;
    rw.status = UVM_IS_OK;
  endfunction
  
  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    // not needed
    return null;
  endfunction
endclass

`endif // EXAMPLE_REG_ITEM
