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
import vr_ad/e/vr_ad_top;


extend vr_ad_reg_file_kind : [ GRAPHICS ];
extend GRAPHICS vr_ad_reg_file {
  keep size == 256;
  post_generate() is also {
    reset();
  };
};


reg_def TRIANGLE {
  reg_fld SIDE0 : uint(bits : 8);
  reg_fld SIDE1 : uint(bits : 8);
  reg_fld SIDE2 : uint(bits : 8);
};


extend GRAPHICS vr_ad_reg_file {
  triangles[3] : list of TRIANGLE vr_ad_reg;
  
  add_registers() is also {
    for each (triangle) in triangles {
      add_with_offset(index * 0x10, triangle);
    };
  };
};
'>


<'
struct compacted_graphics_model {
  graphics_regs : GRAPHICS vr_ad_reg_file;
};
'>


<'
extend sys {
  graphics_model : compacted_graphics_model;
  
  run() is also {
    graphics_model.graphics_regs.triangles[0].update(0x0, pack(packing.high, 0x0003_0503), {});
    graphics_model.graphics_regs.triangles[1].update(0x0, pack(packing.high, 0x0003_0303), {});
    graphics_model.graphics_regs.triangles[2].update(0x0, pack(packing.high, 0x0003_0405), {});
  };
};
'>
