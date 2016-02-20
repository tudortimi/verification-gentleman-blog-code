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


import uvm_pkg::*;
`include "uvm_macros.svh"

import vgm_reg_utils::*;

typedef enum bit[2:0] {
  CONTINUE = 3'b001, STOP = 3'b010, START = 3'b100 } operation_e;


class dummy_reg extends uvm_reg;
  function new(string name = "dummy_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction
endclass



class multiply_mapped_enum_field extends vgm_reg_enum_field #(operation_e);
  `uvm_object_utils(multiply_mapped_enum_field)


  function new(string name = "multiply_mapped_enum_field");
    super.new(name);
  endfunction


  protected virtual function operation_e bits2enum(uvm_reg_data_t value);
    if (value[2])
      return START;
    if (value[1])
      return STOP;
    if (value[0])
      return CONTINUE;
    `uvm_fatal("VALERR", { "In field '", get_name(), "': ",
      $sformatf("Illegal value 'b%0b", value) })
  endfunction


  protected virtual function uvm_reg_data_t enum2bits(operation_e value);
    if(!std::randomize(enum2bits) with {
      enum2bits[`UVM_REG_DATA_WIDTH - 1:3] == 0;
      value == START -> enum2bits[2] == 1;
      value == STOP -> enum2bits[2:1] == 2'b01;
      value == CONTINUE -> enum2bits[2:0] == 3'b001;
    })
      `uvm_fatal("RANDERR", "Randomization error")
  endfunction
endclass



module top;
  initial begin
    automatic dummy_reg parent = new("parent");
    automatic multiply_mapped_enum_field field = new("field");
    field.configure(parent, 3, 0, "RW", 0, STOP, 1, 1, 0);

    field.set(3'b100);
    $display("value = %p", field.get_enum());

    field.set_enum(START);
    $display("value = %3b", field.get());
  end
endmodule
