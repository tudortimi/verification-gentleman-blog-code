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


class reg_burst_extension extends uvm_object;
  rand int unsigned num_regs;

  constraint valid_num_regs {
    num_regs inside { 1, 4 };
  }

  function new(string name = "reg_burst_extension");
    super.new(name);
  endfunction

  `uvm_object_utils(reg_burst_extension)
endclass
