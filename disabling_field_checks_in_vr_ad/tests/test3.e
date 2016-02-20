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
extend sys {
  some_other_reg : SOME_OTHER_REG vr_ad_reg;
  keep some_other_reg == read_only(some_reg_file.some_other_reg);
  
  run() is also {
    message(LOW, "Simulating update by hardware on field BAZ with value 0xff");
    compute some_other_reg.compare_and_update(0x0, { 0x00; 0x00; 0xff; 0x00 });
  };
};
'>
