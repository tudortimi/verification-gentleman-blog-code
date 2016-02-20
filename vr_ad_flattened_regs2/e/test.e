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
  !triangle0 : TRIANGLE0 vr_ad_reg;
  !triangle : TRIANGLE0 vr_ad_reg;
  !circle : CIRCLE0 vr_ad_reg;
  
  body() @driver.clock is only {
    write_triangle0();
    write_triangle1a();
    write_triangle1b();
    write_triangle1c();
    write_triangle2();
    read_triangle2();
    
    write_circle0();
    write_circle1();
    write_circle2();
    read_circle0();
    
    write_all_triangles();
    read_all_circles();
  };
  
  write_triangle0() @driver.clock is {
    write_reg triangle0 {
      .SIDE0 == 1;
      .SIDE1 == 2;
      .SIDE2 == 3;
    };
  };
  
  write_triangle1a() @driver.clock is {
    write_triangle_reg 1 triangle {
      .SIDE1 == 1;
    };
  };
  
  write_triangle1b() @driver.clock is {
    write_triangle_reg 1 triangle;
  };
  
  write_triangle1c() @driver.clock is {
    write_triangle_reg 1 triangle val 0x010101;
  };
  
  write_triangle2() @driver.clock is {
    write_triangle_reg_fields 1 triangle { .SIDE0 = 1 };
  };
  
  read_triangle2() @driver.clock is {
    read_triangle_reg 2 triangle;
  };

  
  write_circle0() @driver.clock is {
    write_graphics_reg 0 circle;
  };
  
  write_circle1() @driver.clock is {
    write_graphics_reg 1 circle { .RADIUS == 5 };
  };
  
  write_circle2() @driver.clock is {
    write_graphics_reg_fields 2 circle { .RADIUS = 1 };
  };
  
  read_circle0() @driver.clock is {
    read_graphics_reg 0 circle;
  };
  
  
  write_all_triangles() @driver.clock is {
    for i from 0 to 2 {
      write_graphics_reg i triangle {
        .SIDE0 == 3;
        .SIDE1 == 3;
        .SIDE2 == 3;
      };
    };
  };
  
  read_all_circles() @driver.clock is {
    for i from 0 to 2 {
      read_graphics_reg i circle;
    };
  };
};
'>
