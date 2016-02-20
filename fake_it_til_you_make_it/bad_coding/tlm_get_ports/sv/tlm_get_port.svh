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


class tlm_get_port #(type T = int)
  extends tlm_get_port_base #(tlm_get_if #(T))
  implements tlm_get_if #(T);
    
  //--------------------------------------------------
  // methods copied from 'tlm_blocking_get_port'
  //--------------------------------------------------
  
  virtual task get(output T t);
    m_imp.get(t);
  endtask
  
  virtual task peek(output T t);
    m_imp.peek(t);
  endtask
  
  
  //--------------------------------------------------
  // methods copied from 'tlm_blocking_get_port'
  //--------------------------------------------------
  
  virtual function bit can_get();
    return m_imp.can_get();
  endfunction
  
  virtual function bit can_peek();
    return m_imp.can_peek();
  endfunction
  
  virtual function bit try_get(output T t);
    if (m_imp.try_peek(t))
      return 1;
    return 0;
  endfunction
  
  virtual function bit try_peek(output T t);
    if (m_imp.can_peek())
      return 1;
    return 0;
  endfunction
  
endclass
