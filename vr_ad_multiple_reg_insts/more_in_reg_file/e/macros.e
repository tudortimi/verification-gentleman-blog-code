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
//define <write_triangle_reg'action>
//  "write_triangle_reg <idx'exp> <reg'exp>[ <any>]" as computed
//{
//  var los : list of string;
//  los.add(        "{");
//  los.add(        "var static_triangle :=");
//  los.add(appendf("driver.addr_map.get_regs_by_kind(TRIANGLE)[%s];", <idx'exp>));
//  los.add(appendf("write_reg { .static_item == static_triangle } %s %s;", <reg'exp>, <any>));
//  los.add(        "};");
//  
//  result = str_join(los, "\n");
//};
'>


<'
extend global {
  vgm__access_triangle_reg_body(operation : string,
    idx : string, reg : string, block : string = "") : string is
  {
    var los : list of string;
    los.add(        "{");
    los.add(        "var static_triangles :=");
    los.add(        "driver.addr_map.get_regs_by_kind(TRIANGLE);");
    los.add(appendf("assert %s in [0..static_triangles.size() - 1];", idx));
    los.add(appendf("%s { .static_item == static_triangles[%s] } %s %s;", operation, idx, reg, block));
    los.add(        "};");
    
    result = str_join(los, "\n");
  };
};


define <write_triangle_reg'action>
  "write_triangle_reg <idx'exp> <reg'exp>[ <any>]" as computed
{
  result = vgm__access_triangle_reg_body("write_reg", <idx'exp>, <reg'exp>, <any>);
};

define <write_triangle_reg_fields'action>
  "write_triangle_reg_fields <idx'exp> <reg'exp>[ <any>]" as computed
{
  result = vgm__access_triangle_reg_body("write_reg_fields", <idx'exp>, <reg'exp>, <any>);
};

define <read_triangle_reg'action>
  "read_triangle_reg <idx'exp> <reg'exp>" as computed
{
  result = vgm__access_triangle_reg_body("read_reg", <idx'exp>, <reg'exp>);
};
'>


<'
extend global {
  vgm__access_graphics_reg_body(operation : string,
    idx : string, reg : string, block : string = "") : string is
  {
    var los : list of string;
    los.add(        "{");
    los.add(        "var kind : vr_ad_reg_kind;");
    los.add(appendf("if %s == NULL { %s = new };", reg, reg));
    los.add(appendf("kind = %s.kind;", reg));
    los.add(        "var static_regs :=");
    los.add(        "driver.addr_map.get_regs_by_kind(kind);");
    los.add(appendf("assert %s in [0..static_regs.size() - 1];", idx));
    los.add(appendf("%s { .static_item == static_regs[%s] } %s %s;", operation, idx, reg, block));
    los.add(        "};");
    
    result = str_join(los, "\n");
  };
};


define <write_graphics_reg'action>
  "write_graphics_reg <idx'exp> <reg'exp>[ <any>]" as computed
{
  result = vgm__access_graphics_reg_body("write_reg", <idx'exp>, <reg'exp>, <any>);
};

define <write_graphics_reg_fields'action>
  "write_graphics_reg_fields <idx'exp> <reg'exp>[ <any>]" as computed
{
  result = vgm__access_graphics_reg_body("write_reg_fields", <idx'exp>, <reg'exp>, <any>);
};

define <read_graphics_reg'action>
  "read_graphics_reg <idx'exp> <reg'exp>" as computed
{
  result = vgm__access_graphics_reg_body("read_reg", <idx'exp>, <reg'exp>);
};
'>
