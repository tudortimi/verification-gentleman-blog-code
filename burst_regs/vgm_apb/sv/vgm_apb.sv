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


package vgm_apb;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "vgm_apb_types.svh"
  `include "vgm_apb_transfer.svh"
  `include "vgm_apb_monitor.svh"

  `include "vgm_apb_master_sequencer.svh"
  `include "vgm_apb_master_driver.svh"
  `include "vgm_apb_master_agent.svh"

  `include "vgm_apb_reg_adapter.svh"
  `include "vgm_apb_reg_xlate_sequence.svh"
  `include "vgm_apb_reg_frontdoor.svh"
endpackage
