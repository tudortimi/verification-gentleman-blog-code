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


import drivable_pkg::*;


class car implements drivable_if;
  
  //----------------------------------------
  // methods of drivable_if  
  //----------------------------------------
  
  virtual function void accelerate();
    $display("I'm accelerating");
  endfunction

  virtual function void turn_left();
    $display("I'm turning left");
  endfunction

  virtual function void turn_right();
    $display("I'm turning right");
  endfunction

  virtual function void brake();
    $display("I'm braking");
  endfunction
endclass


module top;
  initial begin
    static car the_car = new();
    static driver the_driver = new(the_car);
    the_driver.drive();
  end
endmodule
