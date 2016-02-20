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

  
`ifndef VGM_AHB_TYPES
`define VGM_AHB_TYPES

typedef enum bit[2:0] {
  VGM_AHB_BYTES_1,
  VGM_AHB_BYTES_2,
  VGM_AHB_BYTES_4,
  VGM_AHB_BYTES_8,
  VGM_AHB_BYTES_16,
  VGM_AHB_BYTES_32,
  VGM_AHB_BYTES_64,
  VGM_AHB_BYTES_128
} vgm_ahb_size_e;

typedef enum bit[2:0] {
  VGM_AHB_SINGLE,
  VGM_AHB_INCR,
  VGM_AHB_WRAP4,
  VGM_AHB_INCR4,
  VGM_AHB_WRAP8,
  VGM_AHB_INCR8,
  VGM_AHB_WRAP16,
  VGM_AHB_INCR16
} vgm_ahb_burst_e;

`endif // VGM_AHB_TYPES
