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


`include "types.svh"
`include "instruction.svh"

`include "cov_collector.svh"
`include "no_mul_cov_collector.svh"
`include "less_regs_cov_collector.svh"


module top;
  cov_collector cov;
  no_mul_cov_collector no_mul_cov;
  less_regs_cov_collector less_regs_cov;


  initial begin
    cov = new();
    no_mul_cov = new();
    less_regs_cov = new();

    repeat (10)
      gen_and_sample();
  end


  function void gen_and_sample();
    automatic instruction instr = new();
    void'(instr.randomize());
    instr.print();

    cov.sample(instr);
    no_mul_cov.sample(instr);
    less_regs_cov.sample(instr);
  endfunction
endmodule
