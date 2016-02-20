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

`ifndef DRAIN_TIME_RUN_BY_NAME_TEST
`define DRAIN_TIME_RUN_BY_NAME_TEST

class drain_time_run_by_name_test extends drain_time_run_test;
  `uvm_component_utils(drain_time_run_by_name_test)
  
  function new(string name = "drain_time_run_by_name_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_phase run_phase = phase.find_by_name("run");
    run_phase.phase_done.set_drain_time(this, 5);
  endfunction
  
endclass

`endif // DRAIN_TIME_RUN_BY_NAME_TEST
