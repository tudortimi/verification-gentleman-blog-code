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
import vr_ad/e/vr_ad_top;

extend vr_ad_reg_file_kind : [SOME_REG_FILE];
extend SOME_REG_FILE vr_ad_reg_file {
    keep size == 8;
    post_generate() is also {
        reset();
    };
};


reg_def SOME_REG SOME_REG_FILE 0x0 {
  reg_fld FOO : uint(bits : 8);
  reg_fld BAR : uint(bits : 8);
  reg_fld QUX : uint(bits : 16);
};

reg_def SOME_OTHER_REG SOME_REG_FILE 0x4 {
  reg_fld BAZ : uint(bits : 32);
};
'>
