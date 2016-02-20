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


virtual class tlm_get_port_base #(type IF);
  protected IF m_imp;
  
  function void connect(IF imp);
    m_imp = imp;
  endfunction
endclass


class tlm_blocking_get_mixin #(type T = int, type BASE = tlm_get_port_base #(tlm_blocking_get_if #(T)))
  extends BASE
  implements tlm_blocking_get_if #(T);
  
  virtual task get(output T t);
    m_imp.get(t);
  endtask
  
  virtual task peek(output T t);
    m_imp.peek(t);
  endtask
  
endclass


class tlm_nonblocking_get_mixin #(type T = int, type BASE = tlm_get_port_base #(tlm_nonblocking_get_if #(T)))
  extends BASE
  implements tlm_nonblocking_get_if #(T);
  
  virtual function bit can_get();
    return m_imp.can_get();
  endfunction
  
  virtual function bit can_peek();
    return m_imp.can_peek();
  endfunction
  
  virtual function bit try_get(output T t);
    if (m_imp.try_get(t))
      return 1;
    return 0;
  endfunction
  
  virtual function bit try_peek(output T t);
    if (m_imp.try_peek(t))
      return 1;
    return 0;
  endfunction
  
endclass
