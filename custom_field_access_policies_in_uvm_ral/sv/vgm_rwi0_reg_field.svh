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


`ifndef VGM_RWI0_REG_FIELD
`define VGM_RWI0_REG_FIELD

// there is no post_predict() hook defined for uvm_reg_fields, although
// there are hooks for pre/post_read/write()
//
// this means we have to use callbacks which is kind of inconvienient
// because it will make everything slower
//
// can declare it inside the field class, but cannot add in new()
// have to do it in the register, which is kind of annoying because it's
// not fully encapsulated

class vgm_wri0_cbs extends uvm_reg_cbs;
  `uvm_object_utils(vgm_wri0_cbs)
  
  function new(string name = "vgm_wri0_cbs");
    super.new(name);
  endfunction
  
  virtual function void post_predict(input uvm_reg_field  fld,
                                     input uvm_reg_data_t previous,
                                     inout uvm_reg_data_t value,
                                     input uvm_predict_e  kind,
                                     input uvm_path_e     path,
                                     input uvm_reg_map    map);
    if (kind == UVM_PREDICT_WRITE && fld.get_access() == "RWI0" && value == 0)
      value = previous;
  endfunction
endclass


class vgm_rwi0_reg_field extends uvm_reg_field;
  `uvm_object_utils(vgm_rwi0_reg_field)
  
  local static bit m_wri0 = define_access("RWI0");  // when defining a new access policy, only use uppercase
  
  function new(string name = "vgm_rwi0_reg_field");
    super.new(name);
  endfunction
  
  // called only if doing an explicit reg.write() inside a reg sequence
  // it also just changes the value that will actually get written on the bus
  // in our case it would never write '0', but the previous value instead
  // not really doing any checking that writes of '0' are ignored
  
  //virtual task pre_write(uvm_reg_item rw);
  //  // prevent the write if trying to write 0
  //  if (rw.value[0] == 0) begin
  //    rw.value[0] = value;
  //  end
  //endtask
  
endclass

`endif // VGM_RWI0_REG_FIELD
