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
  protected virtual vgm_apb_tri_master_interface vif;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  virtual function void set_vif(virtual vgm_apb_tri_master_interface vif);
    this.vif = vif;
  endfunction


  virtual task run_phase(uvm_phase phase);
    forever begin
      reset();
      fork
        get_and_drive();
        @(negedge vif.PRESETn);
      join_any
      disable fork;
    end
  endtask


  protected virtual task reset();
    vif.PSEL = 0;
    vif.PENABLE = 0;
    vif.PWRITE = 0;
    vif.PADDR = 0;
    vif.PDATA_drive = 'z;
    @(vif.cb iff vif.PRESETn);
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
    vif.cb.PSEL <= 0;
    vif.cb.PENABLE <= 0;
    vif.cb.PDATA_drive <= 'z;
  endtask


  protected virtual task drive_setup_phase(vgm_apb::transfer transfer);
    vif.cb.PSEL <= 1;
    vif.cb.PWRITE <= transfer.direction;
    vif.cb.PADDR <= transfer.address;
    @(vif.cb);
  endtask


  protected virtual task drive_access_phase(vgm_apb::transfer transfer);
    vif.cb.PENABLE <= 1;
    if (transfer.direction == WRITE)
      vif.cb.PDATA_drive <= transfer.data;

    @(vif.cb iff vif.cb.PREADY);

    if (transfer.direction == READ)
      transfer.data = vif.cb.PDATA;
  endtask
endclass
