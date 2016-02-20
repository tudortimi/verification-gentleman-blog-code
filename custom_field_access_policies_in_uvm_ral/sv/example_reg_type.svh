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


`ifndef EXAMPLE_REG_TYPE
`define EXAMPLE_REG_TYPE

class example_reg_type extends uvm_reg;
  `uvm_object_utils(example_reg_type)
  
  rand uvm_reg_field      field1;
  rand vgm_rwi0_reg_field field2;
  
  function new(string name = "example_reg_type");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction
  
  virtual function void build();
    field1 = uvm_reg_field::type_id::create("field1");
    field2 = vgm_rwi0_reg_field::type_id::create("field2");
    
    field1.configure(this,  16, 16, "RW",   0, 0, 1, 1, 0);
    field2.configure(this,  16,  0, "RWI0", 0, 0, 1, 1, 0);
    
    // register callback
    // - can't be done in vgm_rwi0_reg_field because it calls get_full_name()
    //   which requires the field's parent
    begin
      vgm_wri0_cbs wri0_cbs = new("wri0_cbs");
      uvm_reg_field_cb::add(field2, wri0_cbs);
    end
  endfunction
endclass

`endif // EXAMPLE_REG_TYPE
