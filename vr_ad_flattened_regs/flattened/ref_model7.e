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
extend TRIANGLE0 vr_ad_reg {
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
extend flattened_graphics_model {
  num_triangles : uint;
    keep num_triangles == 3;
  
  get_triangle_reg(idx : uint) : TRIANGLE0 vr_ad_reg is {
    assert idx < num_triangles;
    
    var regs_type := rf_manager.get_exact_subtype_of_instance(graphics_regs);
    
    var triangle_reg_field :=
      regs_type.get_fields().first(it.get_name() == appendf("triangle%d", idx));
    assert triangle_reg_field != NULL;
    
    assert triangle_reg_field.get_type() ==
      rf_manager.get_type_by_name(appendf("TRIANGLE%d'kind vr_ad_reg", idx));
    var triangle_reg : vr_ad_reg =
      triangle_reg_field.get_value(graphics_regs).get_value().unsafe();
    
    result = new;
    result.write_reg_rawval(triangle_reg.read_reg_rawval());
  };
  
  get_triangle_regs() : list of TRIANGLE0 vr_ad_reg is {
    for i from 0 to num_triangles - 1 {
      result.add(get_triangle_reg(i));
    };
  };
  
  largest() : uint is {
    var triangles := get_triangle_regs();
    result = triangles.max_index(it.get_area());
  };
};
'>


<'
extend sys {
  run() is also {
    print graphics_model.get_triangle_reg(0).get_area();
    print graphics_model.get_triangle_reg(1).get_area();
    print graphics_model.get_triangle_reg(2).get_area();
    
    print graphics_model.largest();
  };
};
'>
