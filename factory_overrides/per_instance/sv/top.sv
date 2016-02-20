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


import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb.svh"
`include "test_base.svh"
`include "test1.svh"
`include "test2.svh"
`include "test3a.svh"
`include "test3b.svh"
`include "test3d.svh"
`include "test3e.svh"
`include "test3f.svh"
`include "test4.svh"

module top;
  initial
    uvm_pkg::run_test();
endmodule
