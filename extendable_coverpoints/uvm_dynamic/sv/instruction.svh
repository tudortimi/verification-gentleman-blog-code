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


class instruction extends uvm_sequence_item;
  rand operation_e operation;
  rand register_e op1;
  rand register_e op2;
  rand register_e dest;

  `uvm_object_utils_begin(instruction)
    `uvm_field_enum(operation_e, operation, UVM_ALL_ON)
    `uvm_field_enum(register_e, op1, UVM_ALL_ON)
    `uvm_field_enum(register_e, op2, UVM_ALL_ON)
    `uvm_field_enum(register_e, dest, UVM_ALL_ON)
  `uvm_object_utils_end


  function new(string name = "instruction");
    super.new(name);
  endfunction
endclass
