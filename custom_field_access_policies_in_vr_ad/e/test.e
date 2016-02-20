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
  reg_file : VGM vr_ad_reg_file;
  
  example_reg : EXAMPLE vr_ad_reg;
    keep example_reg == reg_file.example;

  run() is also {
    // bus write
    example_reg.update(0, %{0xffff_ffff}, {});
    print example_reg.field1, example_reg.field2;

    // bus write
    example_reg.update(0, %{0x0000_0000}, {});
    print example_reg.field1, example_reg.field2;
  };
};
'>
