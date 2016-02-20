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


class singular_on_line #(int unsigned len = 8);
  rand bit line[len];
  
  constraint double_for {
    // the '1' can only be in one place
    foreach (line[i])
      foreach (line[j])
        (i != j) -> ((line[i] == 1) -> (line[j] == 0));
      
    // the '1' must exist in the array
    1 inside { line };
  }
  
  
  constraint sum {
    // This doesn't work because it sums to a 1-bit variable. What we'll get is
    // an odd number of '1's in the line.
    //line.sum() == 1;
    
    // Force summation to an integer variable
    line.sum() with ( int'(item) ) == 1;
  }
  
  
  // This doesn't compile.
  //rand bit ones[];
  //
  //constraint find {
  //  ones == line.find() with ( item == 1 );
  //  ones.size() == 1;
  //}
  
  
  function void print();
    $display("%p", line);
  endfunction
endclass


module top;
  initial begin
    automatic singular_on_line test = new();
    
    $display("Test using 'double_for'");
    test.constraint_mode(1);
    test.sum.constraint_mode(0);
    for (int i = 0; i < 10; i++) begin
      if (!test.randomize())
        $fatal("Randomization error");
      test.print();
    end
    
    $display("Test using 'sum'");
    test.constraint_mode(1);
    test.double_for.constraint_mode(0);
    for (int i = 0; i < 10; i++) begin
      if (!test.randomize())
        $fatal("Randomization error");
      test.print();
    end
  end
endmodule
