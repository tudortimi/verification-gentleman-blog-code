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
extend global {
  vgm__access_graphics_reg_body(operation : string,
    rf_idx : string, reg_idx : string, reg : string, block : string = "") : string is
  {
    var los : list of string;
    los.add(        "{");
    los.add(        "var static_slices := driver.addr_map.get_reg_files_by_kind(SLICE);");
    los.add(appendf("assert %s in [0..static_slices.size() - 1];", rf_idx));
    
    // multiply instantiated reg
    if reg_idx != "" {
      los.add(        "var kind : vr_ad_reg_kind;");
      los.add(appendf("if %s == NULL { %s = new };", reg, reg));
      los.add(appendf("kind = %s.kind;", reg));
      los.add(        "var static_regs :=");
      los.add(appendf("static_slices[%s].get_regs_by_kind(kind);", rf_idx));
      los.add(appendf("assert %s in [0..static_regs.size() - 1];", reg_idx));
    };
    
    los.add(appendf("%s {", operation));
    if reg_idx == "" {
      los.add(appendf(".static_item == static_slices[%s];", rf_idx));
    }
    else {
      los.add(appendf(".static_item == static_regs[%s];", reg_idx));
    };
    los.add(appendf("} %s %s;", reg, block));
    los.add(        "};");
    
    result = str_join(los, "\n");
  };
};


define <write_graphics_reg'action>
  "write_graphics_reg <rf_idx'exp>[ <reg_idx'exp>] <reg'exp>[ <any>]" as computed
{
  result = vgm__access_graphics_reg_body("write_reg", <rf_idx'exp>, <reg_idx'exp>, <reg'exp>, <any>);
};

define <write_graphics_reg_fields'action>
  "write_graphics_reg_fields <rf_idx'exp>[ <reg_idx'exp>] <reg'exp>[ <any>]" as computed
{
  result = vgm__access_graphics_reg_body("write_reg_fields", <rf_idx'exp>, <reg_idx'exp>, <reg'exp>, <any>);
};

define <read_graphics_reg'action>
  "read_graphics_reg <rf_idx'exp>[ <reg_idx'exp>] <reg'exp>" as computed
{
  result = vgm__access_graphics_reg_body("read_reg", <rf_idx'exp>, <reg_idx'exp>, <reg'exp>);
};
'>
