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


class monitor extends uvm_monitor;
  uvm_analysis_port #(transfer) transfer_aport;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    transfer_aport = new("transfer_aport", this);
  endfunction

  `uvm_component_utils(monitor)
endclass
