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


interface vgm_apb_tri_master_interface(input bit PRESETn, input bit PCLK,
  inout wire [31:0] PDATA
);
  logic        PSEL;
  logic        PENABLE;
  logic [31:0] PADDR;
  logic        PWRITE;
  logic [31:0] PDATA_drive;

  logic        PREADY;


  clocking cb @(posedge PCLK);
    input output PSEL;
    input output PENABLE;
    input output PADDR;
    input output PWRITE;
    input        PDATA;

    // Even though this is allowed by the standard, the simulator gets confused
    // and thinks I'm referring to the 'output' clockvar when I try to sample
    // the 'input' clockvar.
    //      output PDATA = PDATA_drive;
          output PDATA_drive;

    input        PREADY;
  endclocking

  assign PDATA = PDATA_drive;
endinterface
