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


interface vgm_apb_master_interface(input bit PRESETn, input bit PCLK);
  logic        PSEL;
  logic        PENABLE;
  logic [31:0] PADDR;
  logic        PWRITE;
  logic [31:0] PWDATA;

  logic        PREADY;
  logic [31:0] PRDATA;


  clocking cb @(posedge PCLK);
    input output PSEL;
    input output PENABLE;
    input output PADDR;
    input output PWRITE;
    input output PWDATA;

    input        PREADY;
    input        PRDATA;
  endclocking


  class interface_proxy extends vgm_apb::master_interface_proxy;
    virtual task wait_for_reset_start();
      @(negedge PRESETn);
    endtask

    virtual task wait_for_reset_end();
      @(cb iff PRESETn);
    endtask

    virtual task wait_for_clk(int unsigned num_cycles = 1);
      repeat (num_cycles)
        @(cb);
    endtask


    virtual function void reset();
      PSEL <= 0;
      PENABLE <= 0;
      PADDR <= 0;
      PWRITE <= 0;
    endfunction


    virtual function bit get_sel();
      return cb.PSEL;
    endfunction

    virtual function void set_sel(bit sel);
      cb.PSEL <= sel;
    endfunction

    virtual function bit get_enable();
      return cb.PENABLE;
    endfunction

    virtual function void set_enable(bit enable);
      cb.PENABLE <= enable;
    endfunction

    virtual function logic [31:0] get_address();
      return cb.PADDR;
    endfunction

    virtual function void set_address(logic [31:0] address);
      cb.PADDR <= address;
    endfunction

    virtual function vgm_apb::direction_e get_direction();
      return vgm_apb::direction_e'(cb.PWRITE);
    endfunction

    virtual function void set_direction(vgm_apb::direction_e direction);
      cb.PWRITE <= direction;
    endfunction

    virtual function logic [31:0] get_write_data();
      return cb.PWDATA;
    endfunction

    virtual function void set_write_data(logic [31:0] data);
      cb.PWDATA <= data;
    endfunction

    virtual function logic [31:0] get_read_data();
      return cb.PRDATA;
    endfunction

    virtual function bit get_ready();
      return cb.PREADY;
    endfunction
  endclass

  interface_proxy proxy = new();
endinterface
