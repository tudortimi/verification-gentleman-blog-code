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


`ifndef EXAMPLE_REG_BLOCK_TYPE
`define EXAMPLE_REG_BLOCK_TYPE

class example_reg_block_type extends uvm_reg_block;
  `uvm_object_utils(example_reg_block_type)
  
  rand example_reg_type example_reg;
  
  function new(string name = "example_reg_block_type");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
  
  function void build();
    default_map = create_map("default_map", 'h0000, 4, UVM_LITTLE_ENDIAN);
    example_reg = example_reg_type::type_id::create("example_reg");
    example_reg.configure(this);
    example_reg.build();
    default_map.add_reg(example_reg, 'h0);
  endfunction
endclass

`endif // EXAMPLE_REG_BLOCK_TYPE
