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


package vgm_wb;
  import uvm_pkg::*;
  `include "uvm_macros.svh"


  virtual class checker_proxy extends uvm_component;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    pure virtual function void set_pipelined(bit is_pipelined);
  endclass


  virtual class sva_checker_wrapper;
    pure virtual function checker_proxy get_proxy(string name,
      uvm_component parent);
  endclass


  class agent extends uvm_agent;
    checker_proxy sva_checker;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      sva_checker_wrapper checker_wrapper;
      if (!uvm_config_db #(sva_checker_wrapper)::get(this, "",
        "checker_wrapper", checker_wrapper)
      )
        `uvm_fatal("CFGERR", "No checker wrapper received")

      sva_checker = checker_wrapper.get_proxy("sva_checker", this);
    endfunction

    `uvm_component_utils(agent)
  endclass

endpackage
