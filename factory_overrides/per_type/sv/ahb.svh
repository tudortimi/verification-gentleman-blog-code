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


typedef enum { READ, WRITE } direction_t;
typedef enum { BYTE, HALFWORD, WORD } size_t;
typedef enum { NONE, SMALL, MEDIUM, LARGE } delay_t;


class ahb_item extends uvm_sequence_item;
  `uvm_object_utils(ahb_item)

  rand direction_t direction;
  rand size_t size;
  rand delay_t delay;

  function new(string name = "ahb_item");
    super.new(name);
  endfunction

  virtual function void do_print(uvm_printer printer);
    `uvm_print_enum(direction_t, direction, "direction", printer)
    `uvm_print_enum(size_t, size, "size", printer)
    `uvm_print_enum(delay_t, delay, "delay", printer)
  endfunction
endclass



class ahb_sequence_base extends uvm_sequence #(ahb_item);
  `uvm_declare_p_sequencer(uvm_sequencer #(ahb_item))

  function new(string name);
    super.new(name);
  endfunction

  virtual task pre_body();
    if (starting_phase != null)
      starting_phase.raise_objection(this);
  endtask

  virtual task post_body();
    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
endclass



class ahb_driver extends uvm_driver #(ahb_item);
  `uvm_component_utils(ahb_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    execute_items();
  endtask

  protected task execute_items();
    forever begin
      ahb_item item;
      seq_item_port.get_next_item(item);
      drive(item);
      seq_item_port.item_done();
    end
  endtask

  protected virtual task drive(ahb_item item);
    item.print();
  endtask
endclass



class ahb_agent extends uvm_agent;
  `uvm_component_utils(ahb_agent)

  ahb_driver driver;
  uvm_sequencer #(ahb_item) sequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    driver = ahb_driver::type_id::create("driver", this);
    sequencer = uvm_sequencer #(ahb_item)::type_id::create("sequencer", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
endclass
