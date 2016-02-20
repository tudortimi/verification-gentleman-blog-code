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
  vgm_apb::transfer apb_trans, apb_trans_new, apb_trans_copy, apb_trans_clone;
  vgm_apb2::transfer apb2_trans, apb2_trans_new, apb2_trans_copy, apb2_trans_clone;


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
    $info("Testing apb_trans");
    apb_trans.print();

    apb_trans_new = new apb_trans;
    apb_trans_new.print();

    apb_trans_copy = new("apb_trans_copy");
    apb_trans_copy.copy(apb_trans);
    apb_trans_copy.print();

    apb_trans_clone = apb_trans.clone();
    apb_trans_clone.print();
  endfunction


  function void test_apb2_trans();
    $info("Testing apb2_trans");
    apb2_trans.print();

    apb2_trans_new = new apb2_trans;
    apb2_trans_new.print();

    apb2_trans_copy = new("apb2_trans_copy");
    apb2_trans_copy.copy(apb2_trans);
    apb2_trans_copy.print();

    apb2_trans_clone = apb2_trans.clone();
    apb2_trans_clone.print();
  endfunction


  function void test_cross_copy();
    $info("Testing cross copy");
    apb2_trans.print();

    apb_trans_copy = new("apb_trans_copy");
    apb_trans_copy.copy(apb2_trans);
    apb_trans_copy.print();
  endfunction


  function void test_cross_clone();
    $info("Testing cross clone");
    apb2_trans.print();

    apb_trans_clone = apb2_trans.clone();
    apb_trans_clone.print();
  endfunction


  //function void test_wrong_copy();
  //  $info("Testing wrong copy");
  //  apb_trans.print();
  //
  //  // Should be compile error.
  //  apb2_trans_copy = new("apb2_trans_copy");
  //  apb2_trans_copy.copy(apb_trans);
  //  apb2_trans_copy.print();
  //endfunction


  function void test_wrong_clone();
    $info("Testing wrong clone");
    apb_trans.print();

    // Compile error since an apb_trans is not an apb2_trans
    apb2_trans_clone = apb_trans.clone();
    apb2_trans_clone.print();
  endfunction
endmodule
