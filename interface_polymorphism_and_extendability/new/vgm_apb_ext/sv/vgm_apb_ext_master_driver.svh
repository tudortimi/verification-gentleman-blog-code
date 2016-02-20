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


class master_driver extends vgm_apb::master_driver;
  protected master_interface_proxy ext_if_proxy;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  virtual function void set_interface_proxy(
    vgm_apb::master_interface_proxy if_proxy
  );
    if (!$cast(this.ext_if_proxy, if_proxy))
      $fatal(0, "Cast error");
    super.set_interface_proxy(if_proxy);
  endfunction


  virtual function void set_ext_interface_proxy(
    master_interface_proxy if_proxy
  );
    set_interface_proxy(if_proxy);
  endfunction


  protected virtual task drive_setup_phase(vgm_apb::transfer transfer);
    vgm_apb_ext::transfer ext_transfer;
    if (!$cast(ext_transfer, transfer))
      `uvm_fatal("CASTERR", "Cast error")

    ext_if_proxy.set_size(ext_transfer.size);
    super.drive_setup_phase(transfer);
  endtask


  protected virtual task drive_access_phase(vgm_apb::transfer transfer);
    vgm_apb::transfer transfer_clone = transfer.clone();

    transfer_clone.data = transfer.data << (8 * transfer.address[1:0]);
    super.drive_access_phase(transfer_clone);
    transfer.data = transfer_clone.data >> (8 * transfer.address[1:0]);
  endtask
endclass
