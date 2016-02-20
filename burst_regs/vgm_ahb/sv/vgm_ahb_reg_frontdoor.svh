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


class reg_frontdoor extends uvm_reg_frontdoor;
  function new(string name = "reg_frontfoor");
    super.new(name);
  endfunction

  task body();
    burst b = burst::type_id::create("burst");

    if (!b.randomize() with {
      if (rw_info.kind inside { UVM_READ, UVM_BURST_READ })
        direction == READ;
      else
        direction == WRITE;
      address == rw_info.offset;
      data.size() == rw_info.value.size();
      foreach (data[i])
        data[i] == rw_info.value[i];
    })
      `uvm_fatal("RNDERR", "Randomization error")
    `uvm_send(b)
  endtask

  `uvm_object_utils(reg_frontdoor)
endclass
