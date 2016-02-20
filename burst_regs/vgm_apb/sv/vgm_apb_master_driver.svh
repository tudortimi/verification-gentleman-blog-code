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


class master_driver extends uvm_driver #(transfer);
  uvm_tlm_b_initiator_socket socket;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    socket = new("socket", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      get_and_drive();
    end
  endtask

  protected virtual task get_and_drive();
    seq_item_port.get_next_item(req);
    `uvm_info("DRV", "Driving an item", UVM_HIGH)
    drive(req);
    `uvm_info("DRV", "Finished driving an item", UVM_HIGH)
    seq_item_port.item_done();
  endtask


  protected virtual task drive(transfer t);
    uvm_tlm_generic_payload payload = new("payload");
    uvm_tlm_time delay = new("delay");
    byte unsigned data[];
    allocate_data(data);

    if (t.direction == READ)
      payload.set_read();
    else if (t.direction == WRITE) begin
      payload.set_write();
      to_bytes(t, data);
    end
    payload.set_address(t.address);
    payload.set_data(data);
    payload.set_data_length(data.size());

    socket.b_transport(payload, delay);

    // TODO Wrong TLM2 semantics w.r.t. 'data' getting copied.
    if (t.direction == READ)
      payload.get_data(data);

    if (t.direction == READ)
      from_bytes(data, t);

    #1;
  endtask


  protected function void allocate_data(ref byte unsigned data[]);
    int unsigned bytes_per_transfer = 4;
    data = new[bytes_per_transfer];
  endfunction


  protected function void to_bytes(transfer t, ref byte unsigned data[]);
    int unsigned bytes_per_transfer = 4;

    for (int j = 0; j < bytes_per_transfer; j++)
      data[j] = t.data[j*8 +: 8];
  endfunction


  protected function void from_bytes(ref byte unsigned data[], transfer t);
    int unsigned bytes_per_transfer = 4;

    for (int j = 0; j < bytes_per_transfer; j++)
      t.data[j*8 +: 8] = data[j];
  endfunction


  `uvm_component_utils(master_driver)
endclass
