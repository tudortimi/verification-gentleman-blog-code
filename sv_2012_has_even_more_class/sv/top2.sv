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
import insurable_pkg::*;


class car implements drivable_if, insurable_if;
  protected int unsigned m_engine_size;
  protected int m_damages[];
  
  function new(int unsigned engine_size);
    m_engine_size = engine_size;
  endfunction

  function void crash(int damages);
    m_damages = new[m_damages.size() + 1] (m_damages);
    m_damages[m_damages.size() - 1] = damages;
  endfunction
  
  
  //----------------------------------------
  // methods of insurable_if  
  //----------------------------------------

  virtual function int unsigned get_engine_size();
    return m_engine_size;
  endfunction

  virtual function int unsigned get_num_accidents();
    return m_damages.size();
  endfunction

  virtual function int unsigned get_damages(int unsigned accident_index);
    assert (accident_index < get_num_accidents());
    return m_damages[accident_index];
  endfunction
  
  
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
    static car the_car = new(3);
    static driver the_driver = new(the_car);
    static insurer the_insurer = new();
    
    the_driver.drive();
    the_car.crash(500);
    $display("The insurance premium is ", the_insurer.insure(the_car));
  end
endmodule
