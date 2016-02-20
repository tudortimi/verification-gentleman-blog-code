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


package vgm_apb;


typedef enum { READ, WRITE } direction_e;


class transfer;
  const string name;

  rand direction_e direction;
  rand bit [31:0] address;
  rand bit [31:0] data;
  rand int unsigned delay;

  function new(string name);
    this.name = name;
  endfunction

  virtual function void print();
    $display("");
    $display("%s @%0d", name, this);
    $display("  direction = %s", direction.name());
    $display("  address = %x", address);
    $display("  data = %x", data);
    $display("  delay = %0d", delay);
  endfunction

  function void copy(transfer rhs);
    this.direction = rhs.direction;
    this.address = rhs.address;
    this.data = rhs.data;
    this.delay = rhs.delay;
  endfunction

  virtual function transfer clone();
    clone = new(name);
    clone.copy(this);
    return clone;
  endfunction
endclass


endpackage
