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


module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"


  vgm_apb::transfer apb_trans, apb_trans_copy, apb_trans_clone;
  vgm_apb2::transfer apb2_trans, apb2_trans_copy, apb2_trans_clone;


  initial begin
    apb_trans = new("apb_trans");
    void'(apb_trans.randomize());

    apb2_trans = new("apb2_trans");
    void'(apb2_trans.randomize());

    //test_apb_trans();
    //test_apb2_trans();
    //test_cross_copy();
    //test_cross_clone();
    //test_wrong_copy();
    //test_wrong_clone();
  end


  function void test_apb_trans();
    `uvm_info("TST", "Testing apb_trans", UVM_NONE)
    apb_trans.print();

    apb_trans_copy = new("apb_trans_copy");
    apb_trans_copy.copy(apb_trans);
    apb_trans_copy.print();

    apb_trans_clone = apb_trans.clone();
    apb_trans_clone.print();
  endfunction


  function void test_apb2_trans();
    `uvm_info("TST", "Testing apb2_trans", UVM_NONE)
    apb2_trans.print();

    apb2_trans_copy = new("apb2_trans_copy");
    apb2_trans_copy.copy(apb2_trans);
    apb2_trans_copy.print();

    apb2_trans_clone = apb2_trans.clone();
    apb2_trans_clone.print();
  endfunction


  function void test_cross_copy();
    `uvm_info("TST", "Testing cross copy", UVM_NONE)
    apb2_trans.print();

    apb_trans_copy = new("apb_trans_copy");
    apb_trans_copy.copy(apb2_trans);
    apb_trans_copy.print();
  endfunction


  function void test_cross_clone();
    `uvm_info("TST", "Testing cross clone", UVM_NONE)
    apb2_trans.print();

    apb_trans_clone = apb2_trans.clone();
    apb_trans_clone.print();
  endfunction


  function void test_wrong_copy();
    `uvm_info("TST", "Testing wrong copy", UVM_NONE)
    apb_trans.print();

    // Should be compile error.
    apb2_trans_copy = new("apb2_trans_copy");
    apb2_trans_copy.copy(apb_trans);
    apb2_trans_copy.print();
  endfunction


  function void test_wrong_clone();
    `uvm_info("TST", "Testing wrong clone", UVM_NONE)
    apb_trans.print();

    // Should be compile error.
    apb2_trans_clone = apb_trans.clone();
    apb2_trans_clone.print();
  endfunction
endmodule
