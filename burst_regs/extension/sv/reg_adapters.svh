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


class ahb_reg_adapter extends vgm_ahb::reg_adapter;
  function new(string name = "ahb_reg_adapter");
    super.new(name);
  endfunction


  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    vgm_ahb::burst b = vgm_ahb::burst::type_id::create("burst");
    uvm_reg_item item = get_item();
    reg_burst_extension ext;
    uvm_reg regs[];
    uvm_reg_addr_t offset;
    uvm_reg_data_t data[];

    if (item.extension == null || !$cast(ext, item.extension) || ext.num_regs == 1)
      return super.reg2bus(rw);

    regs = new[ext.num_regs];
    if (!$cast(regs[0], item.element))
      `uvm_fatal("CASTERR", "Expecting a reg")

    if (rw.addr % 16 != 0)
      `uvm_fatal("INTERR", "Expecting a reg at an aligned address")

    offset = regs[0].get_offset(item.map);
    data = new[ext.num_regs];
    for (int i = 1; i < ext.num_regs; i++)
      regs[i] = item.map.get_reg_by_offset(offset + i*4);

    foreach (regs[i])
      data[i] = regs[i].get();

    if (!b.randomize() with {
      address == rw.addr;
      kind == vgm_ahb::INCR4;
      direction == rw.kind == UVM_READ ? vgm_ahb::READ : vgm_ahb::WRITE;
      foreach (data[i])
        data[i] == local::data[i];
    })
      `uvm_fatal("RANDERR", "Randomization error")
    return b;
  endfunction


  `uvm_object_utils(ahb_reg_adapter)
endclass



class apb_reg_adapter extends vgm_apb::reg_adapter;
  function new(string name = "apb_reg_adapter");
    super.new(name);
  endfunction


  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    vgm_ahb::burst b = vgm_ahb::burst::type_id::create("burst");
    uvm_reg_item item = get_item();
    reg_burst_extension ext;
    uvm_reg regs[];
    uvm_reg_addr_t offset;
    uvm_status_e status;
    uvm_reg_data_t data;

    if (item.extension == null || !$cast(ext, item.extension) || ext.num_regs == 1)
      return super.reg2bus(rw);

    regs = new[ext.num_regs];
    if (!$cast(regs[0], item.element))
      `uvm_fatal("CASTERR", "Expecting a reg")

    if (rw.addr % 16 != 0)
      `uvm_fatal("INTERR", "Expecting a reg at an aligned address")

    offset = regs[0].get_offset(item.map);
    for (int i = 1; i < ext.num_regs; i++)
      regs[i] = item.map.get_reg_by_offset(offset + i*4);

    // This doesn't work, because the thread is getting killed or something.
    foreach (regs[i]) begin
      if (i == 0)
        continue;
      if (rw.kind == UVM_READ)
        fork
          automatic uvm_reg rg = regs[i];
          rg.read(status, data);
        join_none
      else
        fork
          automatic uvm_reg rg = regs[i];
          rg.write(status, rg.get());
        join_none
    end

    return super.reg2bus(rw);
  endfunction


  `uvm_object_utils(apb_reg_adapter)
endclass
