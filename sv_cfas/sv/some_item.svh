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


typedef enum { CONFIG, TX_SHORT, TX_LONG, RX_SHORT, RX_LONG, SHUTDOWN } mode_e;

class some_item extends uvm_sequence_item;
  `uvm_object_utils(some_item)
  
  rand mode_e mode;
  
  function new(string name = "some_item");
    super.new(name);
  endfunction // new
  
  function void do_print(uvm_printer printer);
    printer.print_generic("mode", "mode_e", $bits(mode), mode.name());
  endfunction // do_print
  
endclass // some_item
