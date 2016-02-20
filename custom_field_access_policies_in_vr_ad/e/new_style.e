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
// define a new access policy
extend vr_ad_field_attribute_t : [RWi0];

extend RWi0'fld_mask vr_ad_reg_field_info {

  // define what happens at write
  get_field_write_data_according_to_policy(read_data : vr_ad_data_t,
    ndata : vr_ad_data_t) : vr_ad_data_t is {
    if (ndata == 0) {
      result = read_data;
    }
    else {
      result = ndata;
    };
  };

  // define what happens at read
  get_field_read_data_according_to_policy(default_data : vr_ad_data_t,
    read_data : vr_ad_data_t) : vr_ad_data_t is {
    result = read_data;
  };
};


// define the register
reg_def EXAMPLE VGM 0x0 {
  reg_fld field1 : uint(bits : 16) : RW   : 0;
  reg_fld field2 : uint(bits : 16) : RWi0 : 0;
};
'>
