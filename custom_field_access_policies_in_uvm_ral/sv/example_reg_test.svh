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


`ifndef EXAMPLE_REG_TEST
`define EXAMPLE_REG_TEST

class example_reg_test extends uvm_test;
  `uvm_component_utils(example_reg_test)
  
  example_reg_block_type example_reg_block;
  uvm_reg_predictor #(example_reg_item) reg_predictor;
  uvm_analysis_port #(example_reg_item) aport;
  
  function new(string name = "example_reg_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    example_reg_block = example_reg_block_type::type_id::create("example_reg_block");
    example_reg_block.build();
    example_reg_block.lock_model();
    
    reg_predictor = new("reg_predictor", this);
    aport = new("aport", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    example_reg_adapter adapter = new("adapter");
    reg_predictor.map = example_reg_block.default_map;
    reg_predictor.adapter = adapter;
    example_reg_block.default_map.set_auto_predict(0);
    aport.connect(reg_predictor.bus_in);
  endfunction
  
  task run_phase(uvm_phase phase);
    example_reg_item item = new("item");
    item.write = 1;
    
    item.data = '1;
    aport.write(item);
    $display("val: %h", example_reg_block.example_reg.get());
    
    item.data = '0;
    aport.write(item);
    $display("val: %h", example_reg_block.example_reg.get());
  endtask
endclass

`endif // EXAMPLE_REG_TEST
