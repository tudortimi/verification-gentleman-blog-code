// Copyright 2016 Tudor Timisescu (verificationgentleman.com)
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


module apb_pipeline(
  input bit reset_n,
  input bit clk,

  input logic north_psel,
  input logic north_penable,
  input logic [31:0] north_pwdata,

  output logic south_psel,
  output logic south_penable,
  output logic [31:0] south_pwdata
);
  logic [31:0] z[16];
  logic shift;

  assign shift = north_psel && north_penable;

  always @(posedge clk or negedge reset_n)
    if (!reset_n)
      foreach (z[i])
        z[i] <= 0;
    else
      foreach (z[i])
        if (i == 0)
          z[0] <= north_pwdata;
        else
          z[i] <= z[i-1];


  logic shift_pipeline[16];

  always @(posedge clk or negedge reset_n)
    if (!reset_n)
      foreach (shift_pipeline[i])
        shift_pipeline[i] <= 0;
    else
      foreach (shift_pipeline[i])
        if (i == 0)
          shift_pipeline[0] <= shift;
        else
          shift_pipeline[i] <= shift_pipeline[i-1];


   assign south_psel = shift_pipeline[14] || shift_pipeline[15];
   assign south_penable = shift_pipeline[15];
   assign south_pwdata = z[15];
endmodule
