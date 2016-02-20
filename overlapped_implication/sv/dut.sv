// Copyright 2014 Tudor Timisescu (verificationgentleman.com)
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


module dut;
  bit clk;
  bit antecedent, consequent;

  always #1 clk = ~clk;

  // antecedent implies consequent
  overlapped_implication: assert property (
    @(posedge clk)
      antecedent |-> consequent
  );

  initial begin
    @(posedge clk);
    
    $display("LEGAL: both go high");
    antecedent <= 1;
    consequent  <= 1;
    @(posedge clk);
    antecedent <= 0;
    consequent  <= 0;
    @(posedge clk);
    
    $display("LEGAL: only consequent goes high");
    consequent  <= 1;
    @(posedge clk);
    consequent  <= 0;
    @(posedge clk);
    
    $display("ILLEGAL: only antecedent goes high");
    antecedent <= 1;
    @(posedge clk);
    antecedent <= 0;
    @(posedge clk);
    
    @(posedge clk);
    $finish();
  end

endmodule
