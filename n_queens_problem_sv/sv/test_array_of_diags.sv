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


class array_of_diags #(int unsigned n = 8);
  rand bit[2:0] array[n][n];
  
  rand bit[2:0] diags[n*2 - 1][];
  
  constraint create_diags {
    foreach (diags[i,j])
      if (i < n)
        diags[i][j] == array[i - j][j];
      else
        diags[i][j] == array[(n - 1) - j][i + j - (n - 1)];
  }
  
  
  function void pre_randomize();
    foreach (diags[i])
      diags[i] = new[get_len_of_diag(i)];
  endfunction
  
  
  function int unsigned get_len_of_diag(int unsigned idx);
    if (idx < n)
      return idx + 1;
    
    return 2*n - (idx + 1);
  endfunction
  
  
  function void print();
    $display("array:");
    foreach (array[i])
      $display("%p", array[i]);
    
    $display("");
    
    $display("diags:");
    foreach (diags[i])
      $display("%p", diags[i]);
  endfunction
endclass


module top;
  initial begin
    automatic array_of_diags #(4) test = new();
    
    if (!test.randomize() with {
      test.diags[3][0] == 1;
      test.diags[3][1] == 2;
      test.diags[3][2] == 3;
      test.diags[3][3] == 4;
    })
      $fatal("Randomization error");
    test.print();
  end
endmodule
