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



class cg_ignore_bins_policy extends uvm_object;
  `uvm_object_utils(cg_ignore_bins_policy)

  function new(string name = "cg_ignore_bins_policy");
    super.new(name);
  endfunction


  virtual function array_of_operation_e get_operation_ignore_bins();
    return '{};
  endfunction

  function bit is_operation_ignore_bin(operation_e operation);
    return operation inside { get_operation_ignore_bins() };
  endfunction

  virtual function array_of_register_e get_op1_ignore_bins();
    return '{};
  endfunction

  virtual function array_of_register_e get_op2_ignore_bins();
    return '{};
  endfunction

  virtual function array_of_register_e get_dest_ignore_bins();
    return '{};
  endfunction
endclass



class cov_collector extends uvm_subscriber #(instruction);
  `uvm_component_utils(cov_collector)

  protected cg_ignore_bins_policy policy;

  // This field shouldn't be 'static', but otherwise the compiler complains.
  // It's also not possible to pass such an array to the covergroup constructor.
  static operation_e operation_ignore_bins[];
  static register_e op1_ignore_bins[];
  static register_e op2_ignore_bins[];
  static register_e dest_ignore_bins[];


  covergroup cg() with function sample(operation_e operation, register_e op1,
    register_e op2, register_e dest
  );
    option.per_instance = 1;
    option.name = get_name();

    coverpoint operation {
      ignore_bins ignore[] = operation with (item inside { operation_ignore_bins });
    }

    coverpoint op1 {
      ignore_bins ignore[] = op1 with (item inside { op1_ignore_bins });
    }

    coverpoint op2 {
      ignore_bins ignore[] = op2 with (item inside { op2_ignore_bins });
    }

    coverpoint dest {
      ignore_bins ignore[] = dest with (item inside { dest_ignore_bins });
    }

    operation_vs_op1 : cross operation, op1;
    operation_vs_op2 : cross operation, op2;
    operation_vs_dest : cross operation, dest;

    same_reg_both_ops : coverpoint (op1 == op2);
    same_reg_op1_and_dest : coverpoint (op1 == dest);
    same_reg_op2_and_dest : coverpoint (op2 == dest);
    same_reg_both_ops_and_dest : coverpoint (op1 == dest && op2 == dest);
  endgroup


  function new(string name, uvm_component parent);
    super.new(name, parent);
    policy = cg_ignore_bins_policy::type_id::create("policy", this);
    operation_ignore_bins = policy.get_operation_ignore_bins();
    op1_ignore_bins = policy.get_op1_ignore_bins();
    op2_ignore_bins = policy.get_op2_ignore_bins();
    dest_ignore_bins = policy.get_dest_ignore_bins();
    cg = new();
  endfunction


  virtual function void write(instruction t);
    cg.sample(t.operation, t.op1, t.op2, t.dest);
  endfunction
endclass
