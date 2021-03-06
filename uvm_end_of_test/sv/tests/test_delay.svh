// Copyright 2016 Tudor Timisescu (verificationgentleman.com)
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


class test_delay extends test;
  virtual task run_phase(uvm_phase phase);
    apb_pipeline_tb::pipeline_sequence seq =
      apb_pipeline_tb::pipeline_sequence::type_id::create("seq", this);

    phase.raise_objection(this);

    #1; // Race condition w.r.t. reset
    seq.start(tb_env.master_agent.sequencer);
    #(16 * 2);

    phase.drop_objection(this);
  endtask


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  `uvm_component_utils(test_delay)
endclass
