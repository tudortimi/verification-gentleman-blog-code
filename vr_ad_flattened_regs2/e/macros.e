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
//  los.add(appendf("var temp_triangle : typeof(%s);", <reg'exp>));
//  
//  if <any> != "" {
//    los.add(appendf("gen temp_triangle keeping %s;", <any>));
//  }
//  else {
//    los.add(        "gen temp_triangle;");
//  };
//  
//  los.add(        "var access_triangle : vr_ad_reg = new with {;");
//  los.add( append(".kind = appendf(\"TRIANGLE%d\", ", <idx'exp>, ").as_a(vr_ad_reg_kind);"));
//  los.add(        "};");
//  los.add(        "write_reg access_triangle val temp_triangle.read_reg_rawval();");
//  los.add(        "};");
//  
//  result = str_join(los, "\n");
//};
'>


//<'
//define <write_triangle_reg'action>
//  "write_triangle_reg <idx'exp> <reg'exp>[ <any>]" as computed
//{
//  var los : list of string;
//  var is_val : bool = str_match(<any>, "/^val /");
//  
//  los.add(        "{");
//  los.add(appendf("var temp_triangle : typeof(%s) = new;", <reg'exp>));
//  
//  if not is_val {
//    if <any> != ""{
//      los.add(appendf("gen temp_triangle keeping %s;", <any>));
//    }
//    else {
//      los.add(        "gen temp_triangle;");
//    };
//  };
//  
//  los.add(        "var access_triangle : vr_ad_reg = new with {;");
//  los.add( append(".kind = appendf(\"TRIANGLE%d\", ", <idx'exp>, ").as_a(vr_ad_reg_kind);"));
//  los.add(        "};");
//  if not is_val {
//    los.add(        "write_reg access_triangle val temp_triangle.read_reg_rawval();");
//  }
//  else {
//    los.add(appendf("write_reg access_triangle %s;", <any>));
//  };
//  los.add(        "};");
//  
//  result = str_join(los, "\n");
//};
//'>


<'
extend global {
  vgm__access_triangle_reg_body(operation : string,
    idx : string, reg : string, block : string = "") : string is
  {
    var los : list of string;
    var is_val : bool = str_match(block, "/^val /");
    
    los.add(        "{");
    los.add(appendf("var temp_triangle : typeof(%s) = new;", reg));
    
    if operation == "write_reg" {
      if not is_val {
        if block != ""{
          los.add(appendf("gen temp_triangle keeping %s;", block));
        }
        else {
          los.add(        "gen temp_triangle;");
        };
      };
    }
    else if operation == "write_reg_fields" {
      los.add(appendf("temp_triangle = new with %s;", block));
    };
    
    los.add(        "var access_triangle : vr_ad_reg = new with {;");
    los.add( append(".kind = appendf(\"TRIANGLE%d\", ", idx, ").as_a(vr_ad_reg_kind);"));
    los.add(        "};");
    
    // writing/reading
    if operation != "read_reg" {
      if operation != "write_reg" or not is_val {
        los.add(        "write_reg access_triangle val temp_triangle.read_reg_rawval();");
      }
      else {
        los.add(appendf("write_reg access_triangle %s;", block));
      };
    }
    else {
      los.add(        "read_reg access_triangle;");
      los.add(appendf("if %s == NULL {", reg));
      los.add(appendf("%s = new;", reg));
      los.add(        "};");
      los.add(appendf("%s.write_reg_rawval(access_triangle.read_reg_rawval());", reg));
    };
    
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
    var is_val : bool = str_match(block, "/^val /");
    
    los.add(        "{");
    los.add(appendf("var temp_reg : typeof(%s) = new;", reg));
    
    if operation == "write_reg" {
      if not is_val {
        if block != ""{
          los.add(appendf("gen temp_reg keeping %s;", block));
        }
        else {
          los.add(        "gen temp_reg;");
        };
      };
    }
    else if operation == "write_reg_fields" {
      los.add(appendf("temp_reg = new with %s;", block));
    };
    
    los.add(appendf("if %s == NULL {", reg));
    los.add(appendf("%s = new;", reg));
    los.add(        "};");
    los.add(appendf("var reg_kind_str := %s.kind.as_a(string);", reg));
    los.add(        "assert str_match(reg_kind_str, \"/(.*)(\\d+)$/\");");
    los.add( append("reg_kind_str = appendf(\"%s%d\", $1, ", idx, ");"));
    los.add(        "var access_reg : vr_ad_reg = new with {;");
    los.add(        ".kind = reg_kind_str.as_a(vr_ad_reg_kind);");
    los.add(        "};");
    
    // writing/reading
    if operation != "read_reg" {
      if operation != "write_reg" or not is_val {
        los.add(        "write_reg access_reg val temp_reg.read_reg_rawval();");
      }
      else {
        los.add(appendf("write_reg access_reg %s;", block));
      };
    }
    else {
      los.add(        "read_reg access_reg;");
      los.add(appendf("%s.write_reg_rawval(access_reg.read_reg_rawval());", reg));
    };
    
    los.add(        "};");
    
    result = str_join(los, "\n");
    print result;
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
