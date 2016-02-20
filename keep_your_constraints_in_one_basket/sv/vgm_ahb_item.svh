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


`ifndef VGM_AHB_ITEM
`define VGM_AHB_ITEM

class vgm_ahb_item extends uvm_sequence_item;
  rand bit[31:0]       addr;
  rand vgm_ahb_size_e  size;
  rand vgm_ahb_burst_e burst;
  
  // other fields (omitted for clarity)
  // ...
  
  // address must be aligned to the size of the transfer
  constraint aligned_address_c {
    size == VGM_AHB_BYTES_2   -> addr[0:0] == 0;
    size == VGM_AHB_BYTES_4   -> addr[1:0] == 0;
    size == VGM_AHB_BYTES_8   -> addr[2:0] == 0;
    size == VGM_AHB_BYTES_16  -> addr[3:0] == 0;
    size == VGM_AHB_BYTES_32  -> addr[4:0] == 0;
    size == VGM_AHB_BYTES_64  -> addr[5:0] == 0;
    size == VGM_AHB_BYTES_128 -> addr[6:0] == 0;
  }
  
  // bursts must not cross a 1kB address boundary
  constraint dont_cross_1kb_c {
    burst inside { VGM_AHB_INCR4, VGM_AHB_INCR8, VGM_AHB_INCR16 }
      -> addr[10:0] <= 'h4_00 - vgm_ahb_get_num_transfers(burst) * 2**size;
  }
  
  function void do_print(uvm_printer printer);
    printer.print_int("addr", addr, $bits(addr), UVM_HEX);
    printer.print_generic("size", "vgm_ahb_size_e", 3, size.name());
    printer.print_generic("burst", "vgm_ahb_burst_e", 3, burst.name());
  endfunction
endclass

`endif // VGM_AHB_ITEM
