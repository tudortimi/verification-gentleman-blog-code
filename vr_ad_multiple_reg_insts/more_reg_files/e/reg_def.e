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
extend vr_ad_reg_file_kind : [ SLICE ];
extend SLICE vr_ad_reg_file {
  keep size == 8;
  post_generate() is also {
    reset();
  };
};


reg_def TRIANGLE SLICE 0x0 {
  reg_fld SIDE0 : uint(bits : 8);
  reg_fld SIDE1 : uint(bits : 8);
  reg_fld SIDE2 : uint(bits : 8);
};

reg_def CIRCLE SLICE 0x4 {
  reg_fld RADIUS : uint(bits : 8);
};


extend vr_ad_reg_file_kind : [ GRAPHICS ];
extend GRAPHICS vr_ad_reg_file {
  slices[3] : list of SLICE vr_ad_reg_file;
  
  keep size == 64;
  post_generate() is also {
    reset();
  };
  
  add_registers() is also {
    for each (slice) in slices {
      add_with_offset(index * 0x10, slice);
    };
  };
};
'>
