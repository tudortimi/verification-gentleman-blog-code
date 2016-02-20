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


package vgm_apb2;


class transfer extends vgm_apb::transfer;
  rand bit strobe[4];

  function new(string name);
    super.new(name);
  endfunction

  virtual function void print();
    super.print();
    $display("strobe = %p", strobe);
  endfunction

  function void copy(transfer rhs);
    super.copy(rhs);
    this.strobe = rhs.strobe;
  endfunction

  virtual function transfer clone();
    clone = new(name);
    clone.copy(this);
    return clone;
  endfunction
endclass


endpackage
