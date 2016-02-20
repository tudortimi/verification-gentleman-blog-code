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


interface class tlm_blocking_get_if #(type T=int);
  pure virtual task get(output T t);
  pure virtual task peek(output T t);
endclass


interface class tlm_nonblocking_get_if #(type T=int);
  pure virtual function bit try_get(output T t);
  pure virtual function bit can_get();
  pure virtual function bit try_peek(output T t);
  pure virtual function bit can_peek();
endclass


interface class tlm_get_if #(type T) extends
  tlm_blocking_get_if #(T),
  tlm_nonblocking_get_if #(T);
endclass
