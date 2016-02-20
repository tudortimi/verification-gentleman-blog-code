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


package tests;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import vgm_ahb_pkg::*;

  `include "test_mixins.svh"
  `include "test_items.svh"

  `include "test_random_access.svh"
  `include "test_write_read.svh"

  `include "test_random_access_corner_case.svh"
  `include "test_write_read_corner_case.svh"

  `include "test_write_read_fast_reads.svh"
  `include "test_write_read_slow_writes.svh"

  `include "test_random_access_corner_case_fast_reads.svh"
  `include "test_random_access_corner_case_slow_writes.svh"
  `include "test_random_access_corner_case_extreme_timings.svh"

  `include "test_write_read_corner_case_fast_reads.svh"
  `include "test_write_read_corner_case_slow_writes.svh"
  `include "test_write_read_corner_case_extreme_timings.svh"
endpackage
