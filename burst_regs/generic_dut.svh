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


class generic_dut extends uvm_component;
  uvm_tlm_b_target_socket #(generic_dut) socket;

  byte unsigned memory[bit [63:0]];


  function new(string name, uvm_component parent);
    super.new(name, parent);
    socket = new("socket", this);
  endfunction


  task b_transport(uvm_tlm_generic_payload t, uvm_tlm_time delay);
    if (t.is_write())
      write(t);
    else if (t.is_read())
      read(t);

    `uvm_info("BTRANS", "Got a transaction", UVM_MEDIUM)
    if (uvm_report_enabled(UVM_MEDIUM, UVM_INFO, "BTRANS"))
      t.print();
  endtask


  protected virtual function void write(uvm_tlm_generic_payload t);
    bit [63:0] address = t.get_address();
    int unsigned data_length = t.get_data_length();
    byte unsigned data[];
    t.get_data(data);

    for (int i = 0; i < data_length; i++)
      memory[address + i] = data[i];

    t.set_response_status(UVM_TLM_OK_RESPONSE);
  endfunction


  protected virtual function void read(uvm_tlm_generic_payload t);
    bit [63:0] address = t.get_address();
    int unsigned data_length = t.get_data_length();
    byte unsigned data[];
    t.get_data(data);

    for (int i = 0; i < data_length; i++)
      data[i] = memory[address + i];

    // TODO I'm not getting a reference to the 'data' array from the initiator,
    // but a copy. As per SystemC TLM2 semantics, I shouldn't need to call
    // 'set_data(...)' in the target.
    t.set_data(data);

    t.set_response_status(UVM_TLM_OK_RESPONSE);
  endfunction


  `uvm_component_utils(generic_dut)
endclass
