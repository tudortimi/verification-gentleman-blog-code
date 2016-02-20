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


class cov_collector;
  covergroup cg with function sample(operation_e operation, register_e op1,
    register_e op2, register_e dest
  );
    coverpoint operation;
    coverpoint op1;
    coverpoint op2;
    coverpoint dest;

    operation_vs_op1 : cross operation, op1;
    operation_vs_op2 : cross operation, op2;
    operation_vs_dest : cross operation, dest;

    same_reg_both_ops : coverpoint (op1 == op2);
    same_reg_op1_and_dest : coverpoint (op1 == dest);
    same_reg_op2_and_dest : coverpoint (op2 == dest);
    same_reg_both_ops_and_dest : coverpoint (op1 == dest && op2 == dest);
  endgroup


  function new();
    cg = new();
  endfunction


  function void sample(instruction instr);
    cg.sample(instr.operation, instr.op1, instr.op2, instr.dest);
  endfunction
endclass
