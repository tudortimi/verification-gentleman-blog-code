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
import env;
import macros;


extend MAIN vr_ad_sequence {
  !triangle : TRIANGLE vr_ad_reg;
  !circle : CIRCLE vr_ad_reg;
  
  body() @driver.clock is only {
    write0();
    access_slice();
    access_all_triangles();
  };
  
  write0() @driver.clock is {
    var static_reg_file := driver.addr_map.get_reg_files_by_kind(SLICE)[0];
    write_reg { .static_item == static_reg_file } triangle;
    write_reg { .static_item == static_reg_file } circle;
  };
  
  access_slice() @driver.clock is {
    write_slice_reg 1 triangle { .SIDE1 == 1 };
    read_slice_reg 1 triangle;
    
    write_slice_reg_fields 1 circle { .RADIUS = 1 };
    read_slice_reg 1 circle;
  };
  
  access_all_triangles() @driver.clock is {
    for i from 0 to 2 {
      write_slice_reg i triangle val 0x010203;
    };
  };
};
'>
