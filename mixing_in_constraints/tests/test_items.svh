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


class corner_case_ahb_item extends corner_case_mixin #(vgm_ahb_item);
  `uvm_object_utils(corner_case_ahb_item)


  function new(string name = "corner_case_ahb_item");
    super.new(name);
  endfunction
endclass



class fast_reads_ahb_item extends fast_reads_mixin #(vgm_ahb_item);
  `uvm_object_utils(fast_reads_ahb_item)


  function new(string name = "fast_reads_ahb_item");
    super.new(name);
  endfunction
endclass



class slow_writes_ahb_item extends slow_writes_mixin #(vgm_ahb_item);
  `uvm_object_utils(slow_writes_ahb_item)


  function new(string name = "slow_writes_ahb_item");
    super.new(name);
  endfunction
endclass



class corner_case_fast_reads_ahb_item extends
  fast_reads_mixin #(corner_case_ahb_item);

  `uvm_object_utils(corner_case_fast_reads_ahb_item)


  function new(string name = "corner_case_fast_reads_ahb_item");
    super.new(name);
  endfunction
endclass



class corner_case_slow_writes_ahb_item extends
  corner_case_mixin #(fast_reads_ahb_item);

  `uvm_object_utils(corner_case_slow_writes_ahb_item)


  function new(string name = "corner_case_slow_writes_ahb_item");
    super.new(name);
  endfunction
endclass



class corner_case_extreme_timings_ahb_item extends
  slow_writes_mixin #(fast_reads_mixin #(corner_case_ahb_item));

  `uvm_object_utils(corner_case_extreme_timings_ahb_item)


  function new(string name = "corner_case_extreme_timings_ahb_item");
    super.new(name);
  endfunction
endclass
