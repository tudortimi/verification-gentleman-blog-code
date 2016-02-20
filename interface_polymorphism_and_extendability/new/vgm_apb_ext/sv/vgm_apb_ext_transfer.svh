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


class transfer extends vgm_apb::transfer;
  rand size_e size;

  constraint aligned_address {
    size == HALFWORD -> address[0] == 0;
    size == WORD -> address[1:0] == 0;
  }

  constraint aligned_data {
    size == BYTE -> data == data[7:0];
    size == HALFWORD -> data == data[15:0];
  }


  function new(string name = "transfer");
    super.new(name);
  endfunction


  `uvm_object_utils_begin(transfer)
    `uvm_field_enum(size_e, size, UVM_ALL_ON)
  `uvm_object_utils_end
endclass
