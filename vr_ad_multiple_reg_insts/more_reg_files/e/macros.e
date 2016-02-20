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
  vgm__access_slice_reg_body(operation : string,
    idx : string, reg : string, block : string = "") : string is
  {
    var los : list of string;
    los.add(        "{");
    los.add(        "var static_slices :=");
    los.add(        "driver.addr_map.get_reg_files_by_kind(SLICE);");
    los.add(appendf("assert %s in [0..static_slices.size() - 1];", idx));
    los.add(appendf("%s { .static_item == static_slices[%s] } %s %s;", operation, idx, reg, block));
    los.add(        "};");
    
    result = str_join(los, "\n");
  };
};


define <write_slice_reg'action>
  "write_slice_reg <idx'exp> <reg'exp>[ <any>]" as computed
{
  result = vgm__access_slice_reg_body("write_reg", <idx'exp>, <reg'exp>, <any>);
};

define <write_slice_reg_fields'action>
  "write_slice_reg_fields <idx'exp> <reg'exp>[ <any>]" as computed
{
  result = vgm__access_slice_reg_body("write_reg_fields", <idx'exp>, <reg'exp>, <any>);
};

define <read_slice_reg'action>
  "read_slice_reg <idx'exp> <reg'exp>" as computed
{
  result = vgm__access_slice_reg_body("read_reg", <idx'exp>, <reg'exp>);
};
'>
