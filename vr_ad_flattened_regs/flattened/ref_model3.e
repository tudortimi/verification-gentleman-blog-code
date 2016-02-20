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
  get_triangle_area(side0 : uint, side1 : uint, side2 : uint) : real is {
    var half_per : real = 0.5 * (side0 + side1 + side2);
    result = sqrt(
      (half_per - side0) *
      (half_per - side1) *
      (half_per - side2) *
      half_per
    );
  };
  
  get_triangle0_area() : real is {
    var triangle := graphics_regs.triangle0;
    result = get_triangle_area(triangle.SIDE0, triangle.SIDE1,
      triangle.SIDE2);
  };
  
  get_triangle1_area() : real is {
    var triangle := graphics_regs.triangle1;
    result = get_triangle_area(triangle.SIDE0, triangle.SIDE1,
      triangle.SIDE2);
  };
  
  get_triangle2_area() : real is {
    var triangle := graphics_regs.triangle2;
    result = get_triangle_area(triangle.SIDE0, triangle.SIDE1,
      triangle.SIDE2);
  };
  
  get_triangle_areas() : list of real is {
    result.add(get_triangle0_area());
    result.add(get_triangle1_area());
    result.add(get_triangle2_area());
  };
  
  largest() : uint is {
    var areas := get_triangle_areas();
    result = areas.max_index(it);
  };
  
  smallest() : uint is {
    var areas := get_triangle_areas();
    result = areas.min_index(it);
  };
};
'>


<'
extend flattened_graphics_model {
  get_triangle_perimeter(side0 : uint, side1 : uint, side2 : uint) : uint is {
    result = side0 + side1 + side2;
  };
  
  get_triangle0_perimeter() : uint is {
    var triangle := graphics_regs.triangle0;
    result = get_triangle_perimeter(triangle.SIDE0, triangle.SIDE1,
      triangle.SIDE2);
  };
  
  get_triangle1_perimeter() : uint is {
    var triangle := graphics_regs.triangle1;
    result = get_triangle_perimeter(triangle.SIDE0, triangle.SIDE1,
      triangle.SIDE2);
  };
  
  get_triangle2_perimeter() : uint is {
    var triangle := graphics_regs.triangle2;
    result = get_triangle_perimeter(triangle.SIDE0, triangle.SIDE1,
      triangle.SIDE2);
  };
  
  get_triangle_perimeters() : list of uint is {
    result.add(get_triangle0_perimeter());
    result.add(get_triangle1_perimeter());
    result.add(get_triangle2_perimeter());
  };
  
  longest() : uint is {
    var perimeters := get_triangle_perimeters();
    result = perimeters.max_index(it);
  };
  
  shortest() : uint is {
    var perimeters := get_triangle_perimeters();
    result = perimeters.min_index(it);
  };
};
'>


<'
extend sys {
  run() is also {
    print graphics_model.get_triangle0_area();
    print graphics_model.get_triangle1_area();
    print graphics_model.get_triangle2_area();
    
    print graphics_model.largest();
    print graphics_model.smallest();
    
    print graphics_model.get_triangle0_perimeter();
    print graphics_model.get_triangle1_perimeter();
    print graphics_model.get_triangle2_perimeter();
    
    print graphics_model.longest();
    print graphics_model.shortest();
  };
};
'>
