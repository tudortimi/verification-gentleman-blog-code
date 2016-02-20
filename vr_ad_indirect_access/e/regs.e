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
extend vr_ad_reg_file_kind : [ EXAMPLE ];
extend EXAMPLE vr_ad_reg_file {
  keep size == 8;
  
  post_generate() is also {
    reset();
  };
};


reg_def STATUS EXAMPLE 0x0 {
  reg_fld VALID : uint(bits : 1) : R : 0x0;
  reg_fld DONE  : uint(bits : 1) : R : 0x0;
};

reg_def CONTROL EXAMPLE 0x4 {
  reg_fld SETVALID : uint(bits : 1) : W : 0x0;
  reg_fld CLRVALID : uint(bits : 1) : W : 0x0;
  reg_fld CLRDONE  : uint(bits : 1) : W : 0x0;
  reg_fld START    : uint(bits : 1) : W : 0x0;
};


// Whenever CONTROL is accessed, we want STATUS to know
extend EXAMPLE vr_ad_reg_file {
  add_registers() is also {
    control.attach(status);
  };
};


extend STATUS vr_ad_reg {
  event clk;
  
  // 'indirect_access(...) is called whenever CONTROL is accessed
  indirect_access(direction : vr_ad_rw_t, ad_item : vr_ad_base) is {
    if direction == WRITE {
      var control := ad_item.as_a(CONTROL vr_ad_reg);
      assert control != NULL;
      
      model_valid(control);
      start model_done(control);
    };
  };
  
  model_valid(control : CONTROL vr_ad_reg) is {
    // VALID can only be affected if only one flag is active
    if control.SETVALID == 1 and control.CLRVALID == 0 {
      VALID = 1;
    }
    else if control.CLRVALID == 1 {
      VALID = 0;
    };
  };
  
  model_done(control : CONTROL vr_ad_reg) @clk is {
    if control.CLRDONE == 1 {
      DONE = 0;
    };
    
    if control.START == 1 and VALID == 1 {
      wait [5];
      DONE = 1;
    };
  };
};
'>
