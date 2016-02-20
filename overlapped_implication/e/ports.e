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


<'
extend sys {
  ep_clk : in event_port is instance;
    keep ep_clk.hdl_path() == "dut.clk";
    keep ep_clk.edge() == rise;

  sig_antecedent : in simple_port of bit is instance;
    keep sig_antecedent.hdl_path() == "dut.antecedent";

  sig_consequent : in simple_port of bit is instance;
    keep sig_consequent.hdl_path() == "dut.consequent";

  event clk is @ep_clk$;
  event antecedent is true(sig_antecedent$ == 1) @clk;
  event consequent is true(sig_consequent$ == 1) @clk;

  run() is also {
    message(NONE, "Running");
    start stop();
  };

  stop() @clk is {
    wait [150];
    stop_run();
  };
};
'>
