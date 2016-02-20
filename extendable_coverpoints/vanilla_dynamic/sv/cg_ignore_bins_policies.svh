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


class no_mul_cg_ignore_bins_policy extends cg_ignore_bins_policy;
  virtual function array_of_operation_e get_operation_ignore_bins();
    return '{ MUL, DIV };
  endfunction
endclass



class less_regs_cg_ignore_bins_policy extends cg_ignore_bins_policy;
  virtual function array_of_register_e get_op1_ignore_bins();
    return '{ R4, R5, R6, R7 };
  endfunction

  virtual function array_of_register_e get_op2_ignore_bins();
    return get_op1_ignore_bins();
  endfunction

  virtual function array_of_register_e get_dest_ignore_bins();
    return get_op1_ignore_bins();
  endfunction
endclass



class less_regs_no_mul_cg_ignore_bins_policy extends
  less_regs_cg_ignore_bins_policy;

  virtual function array_of_operation_e get_operation_ignore_bins();
    no_mul_cg_ignore_bins_policy no_mul_policy = new();
    return no_mul_policy.get_operation_ignore_bins();
  endfunction
endclass
