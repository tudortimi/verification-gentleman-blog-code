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


package drivable_pkg;

interface class drivable_if;
  pure virtual function void accelerate();
  pure virtual function void turn_left();
  pure virtual function void turn_right();
  pure virtual function void brake();
endclass


class driver;
  protected drivable_if m_drivable;
  
  function new(drivable_if drivable);
    m_drivable = drivable;
  endfunction

  function void drive();
    m_drivable.accelerate();
    m_drivable.turn_right();
    m_drivable.accelerate();
    m_drivable.turn_left();
    m_drivable.brake();
  endfunction
endclass

endpackage
