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


class test_cov_collectors extends uvm_test;
  `uvm_component_utils(test_cov_collectors)

  cov_collector cov;
  cov_collector no_mul_cov;
  cov_collector less_regs_cov;
  cov_collector less_regs_no_mul_cov;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    cov = cov_collector::type_id::create("cov", this);

    cg_ignore_bins_policy::type_id::set_inst_override(
      no_mul_cg_ignore_bins_policy::get_type(), "no_mul_cov.*", this);
    no_mul_cov = cov_collector::type_id::create("no_mul_cov", this);

    cg_ignore_bins_policy::type_id::set_inst_override(
      less_regs_cg_ignore_bins_policy::get_type(), "less_regs_cov.*", this);
    less_regs_cov = cov_collector::type_id::create("less_regs_cov", this);

    cg_ignore_bins_policy::type_id::set_inst_override(
      less_regs_no_mul_cg_ignore_bins_policy::get_type(),
        "less_regs_no_mul_cov.*", this);
    less_regs_no_mul_cov = cov_collector::type_id::create(
      "less_regs_no_mul_cov", this);
  endfunction


  virtual task run_phase(uvm_phase phase);
    instruction instr = instruction::type_id::create("instr");

    repeat (10) begin
      if (!instr.randomize())
        `uvm_fatal("RANDERR", "Randomization error")
      instr.print();
      cov.write(instr);
      no_mul_cov.write(instr);
      less_regs_cov.write(instr);
      less_regs_no_mul_cov.write(instr);
    end
  endtask
endclass
