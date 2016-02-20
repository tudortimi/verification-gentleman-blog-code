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
  num_triangles : uint;
    keep num_triangles == 3;
  
  get_triangle_reg(idx : uint) : vr_ad_reg is {
    assert idx < num_triangles;
    
    var regs_type := rf_manager.get_exact_subtype_of_instance(graphics_regs);
    
    var triangle_reg_field :=
      regs_type.get_fields().first(it.get_name() == appendf("triangle%d", idx));
    assert triangle_reg_field != NULL;
    
    assert triangle_reg_field.get_type() ==
      rf_manager.get_type_by_name(appendf("TRIANGLE%d'kind vr_ad_reg", idx));
    result =
      triangle_reg_field.get_value(graphics_regs).get_value().unsafe();
  };
  
  get_triangle_area_by_index(idx : uint) : real is {
    assert idx < num_triangles;
    var reg := get_triangle_reg(idx);
    var reg_type := rf_manager.get_exact_subtype_of_instance(reg);
    
    var side0_field := reg_type.get_fields().first(it.get_name() == "SIDE0");
    assert side0_field != NULL;
    assert side0_field.get_type() == rf_manager.get_type_by_name("uint(bits:8)");
    var side0 : uint = side0_field.get_value(reg).get_value().unsafe();
    
    var side1_field := reg_type.get_fields().first(it.get_name() == "SIDE1");
    assert side1_field != NULL;
    assert side1_field.get_type() == rf_manager.get_type_by_name("uint(bits:8)");
    var side1 : uint = side1_field.get_value(reg).get_value().unsafe();
    
    var side2_field := reg_type.get_fields().first(it.get_name() == "SIDE2");
    assert side2_field != NULL;
    assert side2_field.get_type() == rf_manager.get_type_by_name("uint(bits:8)");
    var side2 : uint = side2_field.get_value(reg).get_value().unsafe();
    
    result = get_triangle_area(side0, side1, side2);
  };
  
  get_triangle_area(side0 : uint, side1 : uint, side2 : uint) : real is {
    var half_per : real = 0.5 * (side0 + side1 + side2);
    result = sqrt(
      (half_per - side0) *
      (half_per - side1) *
      (half_per - side2) *
      half_per
    );
  };
  
};
'>


<'
extend sys {
  run() is also {
    print graphics_model.get_triangle_area_by_index(0);
    print graphics_model.get_triangle_area_by_index(1);
    print graphics_model.get_triangle_area_by_index(2);
  };
};
'>
