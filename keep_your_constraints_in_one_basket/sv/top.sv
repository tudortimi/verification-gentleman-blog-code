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


module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  import vgm_ahb_pkg::*;
  
  initial begin
    static vgm_ahb_consec_sequence seq = new();
    if(!seq.randomize with {
      count  == 5;
      size   == VGM_AHB_BYTES_4;
      burst  == VGM_AHB_INCR8;
    })
      `uvm_fatal("RNDFLD", "Randomization failed")
    seq.body();
  end
endmodule
