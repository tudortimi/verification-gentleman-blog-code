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


import svunit_pkg::*;
`include "svunit_defines.svh"

import uvm_pkg::*;
import vgm_uvm_patches::vgm_reg_map;


module vgm_reg_map_unit_test;
  string name = "vgm_reg_map_ut";
  svunit_testcase svunit_ut;

  vgm_reg_map map;


  function void build();
    svunit_ut = new(name);

    map = new("map");
    map.configure(null, 32'h0, 4, UVM_NO_ENDIAN);
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask



  `SVUNIT_TESTS_BEGIN

    `SVTEST(get_physical_addresses__no_offset__returns_start_addr)
      uvm_reg_addr_t addrs[];
      map.get_physical_addresses(32'h0, 32'h0, 4, addrs);

      `FAIL_IF(addrs.size() != 1)
      `FAIL_IF(addrs[0] != 32'h0)
    `SVTEST_END


    `SVTEST(get_physical_addresses__max_offset__returns_end_addr)
      uvm_reg_addr_t addrs[];
      map.get_physical_addresses(32'h0, 32'hffff, 4, addrs);

      `FAIL_IF(addrs.size() != 1)
      `FAIL_IF(addrs[0] != 32'hffff)
    `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
