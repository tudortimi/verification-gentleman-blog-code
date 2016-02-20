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


class vgm_ahb_item extends uvm_sequence_item;
  `uvm_object_utils(vgm_ahb_item)


  rand bit[31:0] addr;
  rand direction_e direction;
  rand burst_e burst;
  rand size_e size;
  rand mode_e mode;
  rand privilege_e privilege;

  rand int unsigned delay;


  constraint delay_init_val {
    delay inside { [0 : 10] };
  }

  constraint no_instr_write {
    mode == INSTR -> direction == READ;
  }

  constraint aligned_address {
    size == HALFWORD -> addr[0:0] == 0;
    size == WORD -> addr[1:0] == 0;
  }


  function new(string name = "vgm_ahb_item");
    super.new(name);
  endfunction


  virtual function string convert2string();
    return $sformatf("%s %s %s %s %s burst to address 0x%x (%0d cycle(s) delay)",
      burst.name(), size.name(), mode.name(), privilege.name(),
        direction.name(), addr, delay);
  endfunction
endclass
