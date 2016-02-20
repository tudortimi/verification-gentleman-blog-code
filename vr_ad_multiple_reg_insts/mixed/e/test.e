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
  !square : SQUARE vr_ad_reg;
  
  body() @driver.clock is only {
    write();
    access_triangle();
    access_circle();
    access_square();
    access_all_triangles();
    access_all_squares();
  };
  
  write() @driver.clock is {
    var static_slice := driver.addr_map.get_reg_files_by_kind(SLICE)[0];
    write_reg { .static_item == static_slice } square;
    
    var static_triangle := static_slice.get_regs_by_kind(TRIANGLE)[0];
    write_reg { .static_item == static_triangle } triangle;
    
    var static_circle := static_slice.get_regs_by_kind(CIRCLE)[2];
    write_reg { .static_item == static_circle } circle;
  };
  
  access_triangle() @driver.clock is {
    write_graphics_reg 1 1 triangle;
    read_graphics_reg 2 0 triangle;
  };
  
  access_circle() @driver.clock is {
    write_graphics_reg_fields 2 0 circle;
    read_graphics_reg 0 3 circle;
  };
  
  access_square() @driver.clock is {
    write_graphics_reg 1 square;
    read_graphics_reg 2 square;
  };
  
  access_all_triangles() @driver.clock is {
    for i from 0 to 2 {
      for j from 0 to 2 {
        read_graphics_reg i j triangle;
      };
    };
  };
  
  access_all_squares() @driver.clock is {
    for i from 0 to 2 {
      write_graphics_reg i square;
    };
  };
};
'>
