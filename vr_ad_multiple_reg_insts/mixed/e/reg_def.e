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
  keep size == 64;
  post_generate() is also {
    reset();
  };
};


reg_def TRIANGLE {
  reg_fld SIDE0 : uint(bits : 8);
  reg_fld SIDE1 : uint(bits : 8);
  reg_fld SIDE2 : uint(bits : 8);
};

reg_def CIRCLE {
  reg_fld RADIUS : uint(bits : 8);
};

reg_def SQUARE SLICE 0x20 {
  reg_fld SIDE : uint(bits : 8);
};


extend SLICE vr_ad_reg_file {
  triangles[3] : list of TRIANGLE vr_ad_reg;
  circles[4] : list of CIRCLE vr_ad_reg;
  
  add_registers() is also {
    for each (triangle) in triangles {
      add_with_offset(index * 0x4, triangle);
    };
    
    for each (circle) in circles {
      add_with_offset(0x10 + index * 0x4, circle);
    };
  };
};


extend vr_ad_reg_file_kind : [ GRAPHICS ];
extend GRAPHICS vr_ad_reg_file {
  slices[3] : list of SLICE vr_ad_reg_file;
  
  keep size == 256;
  post_generate() is also {
    reset();
  };
  
  add_registers() is also {
    for each (slice) in slices {
      add_with_offset(index * 0x40, slice);
    };
  };
};
'>
