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


typedef class ext_reg_block;


class shadow_mem extends uvm_mem;
  function new(string name = "shadow_mem");
    super.new(name, 4, 32);
  endfunction


  virtual task update_regs(
    output uvm_status_e      status,
    input  uvm_path_e        path   = UVM_DEFAULT_PATH,
    input  uvm_reg_map       map = null,
    input  uvm_sequence_base parent = null,
    input  int               prior = -1,
    input  uvm_object        extension = null,
    input  string            fname = "",
    input  int               lineno = 0
  );
    uvm_reg_data_t values[4];
    ext_reg_block model;

    if (!$cast(model, get_parent()))
      `uvm_fatal("CASTERR", "Cast error")

    foreach (values[i])
      values[i] = model.SOME_REGS[i].get();

    burst_write(status, model.SOME_REGS[0].get_offset(), values, path, map,
      parent, prior, extension, fname, lineno);
  endtask


  `uvm_object_utils(shadow_mem)
endclass



class ext_reg_block extends regs::some_reg_block;
  shadow_mem SOME_REGS_MEM;

  function new(string name = "ext_reg_block");
    super.new(name);
  endfunction


  virtual function void build();
    super.build();

    SOME_REGS_MEM = shadow_mem::type_id::create("SOME_REGS_MEM");
    SOME_REGS_MEM.configure(this);

    default_map.add_mem(SOME_REGS_MEM, SOME_REGS[0].get_offset(default_map));
  endfunction


  `uvm_object_utils(ext_reg_block)
endclass
