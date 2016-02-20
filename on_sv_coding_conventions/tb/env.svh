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


class env extends uvm::env;
  vgm_ahb::agent ahb_agent = new();
  vgm_axi::agent axi_agent = new();

  function void print();
    $display("I'm a TB env");
    ahb_agent.print();
    axi_agent.print();
  endfunction
endclass
