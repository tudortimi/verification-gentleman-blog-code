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


package insurable_pkg;

interface class insurable_if;
  pure virtual function int unsigned get_engine_size();
  pure virtual function int unsigned get_num_accidents();
  pure virtual function int unsigned get_damages(int unsigned accident_index);
endclass


class insurer;
  virtual function int unsigned insure(insurable_if insurable);
    int engine_size = insurable.get_engine_size();
    int num_accidents = insurable.get_num_accidents();
    int damages;
    for (int i = 0; i < num_accidents; i++)
      damages += insurable.get_damages(i);

    // do some bogus calculation
    return engine_size * 10 + damages * 100;
  endfunction
endclass

endpackage
