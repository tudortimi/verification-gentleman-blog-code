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


typedef enum bit [0:0] { READ, WRITE } direction_e;


virtual class master_interface_proxy;
  pure virtual task wait_for_reset_start();
  pure virtual task wait_for_reset_end();
  pure virtual task wait_for_clk(int unsigned num_cycles = 1);

  pure virtual function void reset();

  pure virtual function bit get_sel();
  pure virtual function void set_sel(bit sel);

  pure virtual function bit get_enable();
  pure virtual function void set_enable(bit enable);

  pure virtual function logic [31:0] get_address();
  pure virtual function void set_address(logic [31:0] address);

  pure virtual function direction_e get_direction();
  pure virtual function void set_direction(direction_e direction);

  pure virtual function logic [31:0] get_write_data();
  pure virtual function void set_write_data(logic [31:0] data);

  pure virtual function logic [31:0] get_read_data();
  pure virtual function bit get_ready();
endclass
