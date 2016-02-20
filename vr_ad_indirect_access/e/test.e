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


<'
import vr_ad/e/vr_ad_top;
import regs;

extend sys {
  reg_file : EXAMPLE vr_ad_reg_file;
  
  event clk is @sys.any;
  on clk {
    emit reg_file.status.clk;
  };
  
  
  run() is also {    
    start do_test();
  };
  
  write_control(data : vr_ad_data_t) @clk is {
    reg_file.update(0x4, pack(packing.high, data), {});
    wait [1];
  };
  
  read_status(data : vr_ad_data_t) @clk is {
    compute reg_file.compare_and_update(0x0, pack(packing.high, data));
    wait [1];
  };
  
  do_test() @clk is {
    // set VALID
    write_control(0b1000);
    
    // expect to read VALID
    read_status(0b10);
    
    // clear VALID
    write_control(0b0100);
    
    // expect to read not VALID
    read_status(0b00);
    
    // set VALID and START
    write_control(0b1001);
    
    // expect to read VALID
    read_status(0b10);
    
    // after 5 clocks, expect to read DONE as well
    for i from 1 to 5 { wait [1] };
    read_status(0b11);
    
    // clear DONE
    write_control(0b0010);
    
    // expect to read not DONE
    read_status(0b10);
  };
};
'>
