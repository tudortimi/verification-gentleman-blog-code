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


class master_driver extends uvm_driver #(burst);
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
    drive(req);
    seq_item_port.item_done();
  endtask


  protected virtual task drive(burst b);
    uvm_tlm_generic_payload payload = new("payload");
    uvm_tlm_time delay = new("delay");
    byte unsigned data[];
    allocate_data(b, data);

    if (b.direction == READ)
      payload.set_read();
    else if (b.direction == WRITE) begin
      payload.set_write();
      to_bytes(b, data);
    end
    payload.set_address(b.address);
    payload.set_data(data);
    payload.set_data_length(data.size());

    socket.b_transport(payload, delay);

    // TODO Wrong TLM2 semantics w.r.t. 'data' getting copied.
    if (b.direction == READ)
      payload.get_data(data);

    if (b.direction == READ)
      from_bytes(data, b);
  endtask


  protected function void allocate_data(burst b, ref byte unsigned data[]);
    int unsigned bytes_per_transfer = 4;
    data = new[b.data.size() * bytes_per_transfer];
  endfunction


  protected function void to_bytes(burst b, ref byte unsigned data[]);
    int unsigned bytes_per_transfer = 4;

    foreach (b.data[i])
      for (int j = 0; j < bytes_per_transfer; j++)
        data[4*i + j] = b.data[i][j*8 +: 8];
  endfunction


  protected function void from_bytes(ref byte unsigned data[], burst b);
    int unsigned bytes_per_transfer = 4;

    foreach (b.data[i])
      for (int j = 0; j < bytes_per_transfer; j++)
        b.data[i][j*8 +: 8] = data[4*i + j];
  endfunction


  `uvm_component_utils(master_driver)
endclass
