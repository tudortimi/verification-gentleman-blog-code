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


`ifndef VGM_AHB_UTILS
`define VGM_AHB_UTILS


// convert from burst to number of transfers
function int unsigned vgm_ahb_get_num_transfers(vgm_ahb_burst_e burst);
  case (burst)
    VGM_AHB_INCR                   : return 0;
    VGM_AHB_SINGLE                 : return 1;
    VGM_AHB_WRAP4,  VGM_AHB_INCR4  : return 4;
    VGM_AHB_WRAP8,  VGM_AHB_INCR8  : return 8;
    VGM_AHB_WRAP16, VGM_AHB_INCR16 : return 16;
  endcase
endfunction
  
`endif // VGM_AHB_UTILS
