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
  protected master_interface_proxy if_proxy;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  virtual function void set_interface_proxy(master_interface_proxy if_proxy);
    this.if_proxy = if_proxy;
  endfunction


  virtual task run_phase(uvm_phase phase);
    forever begin
      reset();
      fork
        get_and_drive();
        if_proxy.wait_for_reset_start();
      join_any
      disable fork;
    end
  endtask


  protected virtual task reset();
    if_proxy.reset();
    if_proxy.wait_for_reset_end();
  endtask


  local task get_and_drive();
    forever begin
      seq_item_port.get_next_item(req);
      drive(req);
      seq_item_port.item_done();
    end
  endtask


  protected virtual task drive(vgm_apb::transfer transfer);
    drive_setup_phase(transfer);
    drive_access_phase(transfer);
    if_proxy.set_sel(0);
    if_proxy.set_enable(0);
  endtask


  protected virtual task drive_setup_phase(vgm_apb::transfer transfer);
    if_proxy.set_sel(1);
    if_proxy.set_direction(transfer.direction);
    if_proxy.set_address(transfer.address);
    if_proxy.wait_for_clk();
  endtask


  protected virtual task drive_access_phase(vgm_apb::transfer transfer);
    if_proxy.set_enable(1);
    if (transfer.direction == WRITE)
      if_proxy.set_write_data(transfer.data);

    do
      if_proxy.wait_for_clk();
    while (!if_proxy.get_ready());

    if (transfer.direction == READ)
      transfer.data = if_proxy.get_read_data();
  endtask
endclass
