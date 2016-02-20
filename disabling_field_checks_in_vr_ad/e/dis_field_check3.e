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
extend vr_ad_reg {
  disable_field_check(fld_name : string) is {
    var fields_info := get_fields_info();
    
    // essential to check that the field actually exists
    assert(fields_info.has(.fld_name == fld_name));
    
    fields_info = fields_info.all(.fld_name == fld_name);
    var cmask := get_compare_mask();
    var lo := fields_info[0].fld_fidx;
    var hi := lo + fields_info[0].fld_size - 1;
    cmask[hi:lo] = 0;
    set_compare_mask(cmask);
  };
};

extend SOME_REG vr_ad_reg {
  set_static_info() is also {
    disable_field_check("FOO");
  };
};

extend SOME_OTHER_REG vr_ad_reg {
  set_static_info() is also {
    disable_field_check("BAZ");
  };
};
'>
