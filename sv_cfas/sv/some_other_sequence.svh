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


class some_other_sequence extends some_sequence;
  `uvm_object_utils(some_other_sequence)

  function new(string name = "some_other_sequence");
    super.new(name);
  endfunction // new

  constraint only_short_c {
    req.mode inside { TX_SHORT, RX_SHORT };
  }
  
endclass // some_other_sequence
