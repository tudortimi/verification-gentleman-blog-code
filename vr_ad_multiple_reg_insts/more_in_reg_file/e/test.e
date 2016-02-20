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
    write1();
    access_triangle();
    access_all_triangles();
    
    access_circle();
    access_graphics_regs();
  };
  
  write0() @driver.clock is {
    var static_triangle := driver.addr_map.get_regs_by_kind(TRIANGLE)[0];
    write_reg { .static_item == static_triangle } triangle;
  };
  
  write1() @driver.clock is {
    var static_triangle :=
      driver.addr_map.get_regs_by_kind(TRIANGLE)[1].as_a(TRIANGLE vr_ad_reg);
    write_reg static_triangle { .SIDE0 == 1 };
  };
  
  access_triangle() @driver.clock is {
    write_triangle_reg 2 triangle { .SIDE1 == 1 };
    read_triangle_reg 0 triangle;
  };
  
  access_all_triangles() @driver.clock is {
    for i from 0 to 2 {
      write_triangle_reg_fields i triangle { .SIDE2 = 1 };
    };
  };
  
  access_circle() @driver.clock is {
    write_graphics_reg 1 circle;
    read_graphics_reg 2 circle;
  };
  
  access_graphics_regs() @driver.clock is {
    write_graphics_reg 2 triangle;
    read_graphics_reg 4 circle;
  };
};
'>
