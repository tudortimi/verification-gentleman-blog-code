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


class some_reg extends uvm_reg;
  rand uvm_reg_field FIELD0;
  rand uvm_reg_field FIELD1;
  rand uvm_reg_field FIELD2;
  rand uvm_reg_field FIELD3;

  function new(string name = "some_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    FIELD0 = uvm_reg_field::type_id::create("FIELD0", null, get_full_name());
    FIELD0.configure(this, 8, 0, "RW", 0, 0, 1, 1, 0);

    FIELD1 = uvm_reg_field::type_id::create("FIELD1", null, get_full_name());
    FIELD1.configure(this, 8, 8, "RW", 0, 0, 1, 1, 0);

    FIELD2 = uvm_reg_field::type_id::create("FIELD2", null, get_full_name());
    FIELD2.configure(this, 8, 16, "RW", 0, 0, 1, 1, 0);

    FIELD3 = uvm_reg_field::type_id::create("FIELD3", null, get_full_name());
    FIELD3.configure(this, 8, 24, "RW", 0, 0, 1, 1, 0);
  endfunction

  `uvm_object_utils(some_reg)
endclass



class some_reg_block extends uvm_reg_block;
  rand some_reg SOME_REGS[4];

  function new(string name = "some_reg_block");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    default_map = create_map("default_map", 'h0, 4, UVM_LITTLE_ENDIAN);

    foreach (SOME_REGS[i]) begin
      SOME_REGS[i] = some_reg::type_id::create($sformatf("SOME_REGS[%0d]", i),
        null, get_full_name());
      SOME_REGS[i].build();
      SOME_REGS[i].configure(this);
      default_map.add_reg(SOME_REGS[i], 'h4 * i);
    end
  endfunction

  `uvm_object_utils(some_reg_block)
endclass
