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


class burst extends uvm_sequence_item;
  rand direction_e direction;
  rand kind_e kind;
  rand address_t address;
  rand data_t data[];

  constraint aligned_address {
    address[1:0] == 0;
  }

  constraint data_size {
    kind == SINGLE -> data.size() == 1;
    kind == INCR4 -> data.size() == 4;
  }

  function new(string name = "burst");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(burst)
    `uvm_field_enum(direction_e, direction, UVM_ALL_ON)
    `uvm_field_enum(kind_e, kind, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_array_int(data, UVM_ALL_ON)
  `uvm_object_utils_end
endclass


class transfer extends uvm_sequence_item;
  rand direction_e direction;
  rand address_t address;
  rand data_t data;

  function new(string name = "transfer");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(transfer)
    `uvm_field_enum(direction_e, direction, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end
endclass
