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


virtual class sequence_base extends uvm_sequence;
  regs::some_reg_block model;

  function new(string name);
    super.new(name);
  endfunction
endclass



class write_some_reg0 extends sequence_base;
  function new(string name = "write_some_reg0");
    super.new(name);
  endfunction


  virtual task body();
    uvm_status_e status;
    model.SOME_REGS[0].FIELD0.set('hff);
    model.SOME_REGS[0].update(status);

    model.SOME_REGS[0].print();
  endtask


  `uvm_object_utils(write_some_reg0)
endclass



class write_some_regs extends sequence_base;
  function new(string name = "write_some_regs");
    super.new(name);
  endfunction


  virtual task body();
    uvm_reg_item item;
    `uvm_create_on(item, model.default_map.get_sequencer());

    model.SOME_REGS[0].FIELD0.set('hff);
    model.SOME_REGS[1].FIELD1.set('hff);
    model.SOME_REGS[2].FIELD2.set('hff);
    model.SOME_REGS[3].FIELD3.set('hff);

    item.kind         = UVM_BURST_WRITE;
    item.offset       = model.SOME_REGS[0].get_offset();
    item.value        = new[4];
    foreach (item.value[i])
      item.value[i] = model.SOME_REGS[i].get();

    `uvm_send(item)

    foreach (model.SOME_REGS[i])
      model.SOME_REGS[i].print();
  endtask


  `uvm_object_utils(write_some_regs)
endclass
