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


package vgm_apb2;

import uvm_pkg::*;
`include "uvm_macros.svh"


class transfer extends vgm_apb::transfer;
  rand bit strobe[4];

  function new(string name = "transfer");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    transfer rhs_cast;
    if (!$cast(rhs_cast, rhs))
      `uvm_fatal("CASTERR", "Cast error")
    this.strobe = rhs_cast.strobe;
  endfunction

  virtual function void do_print(uvm_printer printer);
    printer.print_generic("strobe", "sa(bit)", 4, strobe2string());
  endfunction

  protected function string strobe2string();
    string ret_val = $sformatf("{ %b", strobe[0]);
    for (int i = 1; i < $size(strobe); i++)
      ret_val = $sformatf("%s, %b", ret_val, strobe[i]);
    ret_val = { ret_val, " }" };
    return ret_val;
  endfunction

  // Forget the utils macro and 'clone' won't work, because it uses the
  // 'create()' method.
  `uvm_object_utils(transfer)
endclass


endpackage
