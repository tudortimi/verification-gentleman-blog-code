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


`ifndef VGM_AHB_SEQ_LIB
`define VGM_AHB_SEQ_LIB

// write ~count~ consecutive locations
class vgm_ahb_consec_sequence extends uvm_sequence #(vgm_ahb_item);
  rand int             count;
  rand bit[31:0]       addr;
  rand vgm_ahb_size_e  size;
  rand vgm_ahb_burst_e burst;
  
  constraint no_incr {
    burst != VGM_AHB_INCR;
  }
  
  task body();
    for (int i = 0; i < count; i++) begin
      vgm_ahb_item item = new();
      int unsigned num_transfers = vgm_ahb_get_num_transfers(burst);
      if (!item.randomize with {
        size  == local::size;
        burst == local::burst;
        addr  == local::addr + i * 2**size * num_transfers;
      })
        `uvm_fatal("RNDFLD", "Randomization failed")
      item.print();
    end
    $finish();
  endtask
  
  // constraint exporter
  protected rand vgm_ahb_item m_item = new();
  
  constraint item_constraints_c {
    addr  == m_item.addr;
    size  == m_item.size;
    burst == m_item.burst;
  }
endclass

`endif // VGM_AHB_SEQ_LIB

