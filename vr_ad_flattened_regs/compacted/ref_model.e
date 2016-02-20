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
extend TRIANGLE vr_ad_reg {
  get_area() : real is {
    var half_per : real = 0.5 * (SIDE0 + SIDE1 + SIDE2);
    result = sqrt(
      (half_per - SIDE0) *
      (half_per - SIDE1) *
      (half_per - SIDE2) *
      half_per
    );
  };
};
'>


<'
extend compacted_graphics_model {
  largest() : uint is {
    var triangles := graphics_regs.triangles;
    result = triangles.max_index(it.get_area());
  };
  
  smallest() : uint is {
    var triangles := graphics_regs.triangles;
    result = triangles.min_index(it.get_area());
  };
};
'>


<'
extend sys {
  run() is also {
    print graphics_model.largest();
    print graphics_model.smallest();
  };
};
'>
