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
extend flattened_graphics_model {
  get_triangle0_area() : real is {
    var triangle0 := graphics_regs.triangle0;
    var half_per : real = 0.5 *
      (triangle0.SIDE0 + triangle0.SIDE1 + triangle0.SIDE2);
    result = sqrt(
      (half_per - triangle0.SIDE0) *
      (half_per - triangle0.SIDE1) *
      (half_per - triangle0.SIDE2) *
      half_per
    );
  };
  
  get_triangle1_area() : real is {
    var triangle1 := graphics_regs.triangle1;
    var half_per : real = 0.5 *
      (triangle1.SIDE0 + triangle1.SIDE1 + triangle1.SIDE2);
    result = sqrt(
      (half_per - triangle1.SIDE0) *
      (half_per - triangle1.SIDE1) *
      (half_per - triangle1.SIDE2) *
      half_per
    );
  };
  
  get_triangle2_area() : real is {
    var triangle2 := graphics_regs.triangle2;
    var half_per : real = 0.5 *
      (triangle2.SIDE0 + triangle2.SIDE1 + triangle2.SIDE2);
    result = sqrt(
      (half_per - triangle2.SIDE0) *
      (half_per - triangle2.SIDE1) *
      (half_per - triangle2.SIDE2) *
      half_per
    );
  };
};
'>


<'
extend sys {
  run() is also {
    print graphics_model.get_triangle0_area();
    print graphics_model.get_triangle1_area();
    print graphics_model.get_triangle2_area();
  };
};
'>
