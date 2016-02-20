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
// define the register
reg_def EXAMPLE VGM 0x0 {
  reg_fld field1 : uint(bits : 16) : RW : 0;
  reg_fld field2 : uint(bits : 16) : RW : 0;
};

// setup quirkiness for field2
extend EXAMPLE vr_ad_reg {
  post_access(direction : vr_ad_rw_t) is also {
    if (direction == WRITE) {
      var prev_val := get_prev_value();
      var cur_val  := get_cur_value();
      
      // check value of field2
      if (cur_val[15:0] == 0) {
        write_reg_rawval(%{cur_val[31:16], prev_val[15:0]});
      };
    };
  };
};
'>
