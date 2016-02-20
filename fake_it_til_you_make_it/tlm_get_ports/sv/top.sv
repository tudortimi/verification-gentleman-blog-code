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


import tlm_get_ports_pkg::*;


// a dummy message class
class message;
  int val;
  
  function void print();
    $display("Time %0d", $time, ": val = %0d", val);
  endfunction
endclass


// A dummy implementation to test the blocking get port.
class some_blocking_imp
  implements tlm_blocking_get_if #(message);
  
  virtual task get(output message t);
    #5;
    t = new();
    t.val = 100;
  endtask
  
  virtual task peek(output message t);
    // empty
  endtask
  
endclass


// A dummy implementation to test the nonblocking get port.
class some_nonblocking_imp
  implements tlm_nonblocking_get_if #(message);
  
  local time m_creation_time;
  
  function new();
    m_creation_time = $time;
  endfunction
  
  virtual function bit can_get();
    if ($time >= m_creation_time + 5)
      return 1;
    return 0;
  endfunction
  
  virtual function bit try_get(output message t);
    if (can_get()) begin
      t = new();
      t.val = 200;
      return 1;
    end
    return 0;
  endfunction
  
  virtual function bit can_peek();
    return 0;
  endfunction
  
  virtual function bit try_peek(output message t);
    return 0;
  endfunction
  
endclass


// A dummy implementation to test the get port.
class some_imp
  implements tlm_get_if #(message);
  
  local message m_msg;
  
  function new();
    m_msg = new();
    m_msg.val = 300;
  endfunction
  
  virtual task get(output message t);
    // empty
  endtask
  
  virtual task peek(output message t);
    #5;
    t = m_msg;
  endtask
  
  virtual function bit can_get();
    return 0;
  endfunction
  
  virtual function bit try_get(output message t);
    return 0;
  endfunction
  
  virtual function bit can_peek();
    return 1;
  endfunction
  
  virtual function bit try_peek(output message t);
    t = m_msg;
    return 1;
  endfunction
  
endclass


module top;
  initial begin
    test_blocking_get();
    test_nonblocking_get();
    test_get();
  end
  
  task automatic test_blocking_get();
    some_blocking_imp imp = new();
    tlm_blocking_get_port #(message) port = new();
    message msg;
    port.connect(imp);
    port.get(msg);
    msg.print();
  endtask
  
  task automatic test_nonblocking_get();
    some_nonblocking_imp imp = new();
    tlm_nonblocking_get_port #(message) port = new();
    message msg;
    port.connect(imp);
    $display("can_get: %0b", port.can_get());
    #5;
    $display("can_get: %0b", port.can_get());
    if (port.try_get(msg))
      msg.print();
  endtask
  
  task automatic test_get();
    some_imp imp = new();
    tlm_get_port #(message) port = new();
    message msg;
    port.connect(imp);
    port.peek(msg);
    msg.print();
    $display("can_peek: %0b", port.can_peek());
    if (port.try_get(msg))
      msg.print();
  endtask
  
endmodule
