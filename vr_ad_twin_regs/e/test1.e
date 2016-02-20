// Copyright 2015 Tudor Timisescu (verificationgentleman.com)
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
import env;
import twins1;


extend MAIN vr_ad_sequence {
  !control : CONTROL vr_ad_reg;
  !status : STATUS vr_ad_reg;
  
  
  body() @driver.clock is only {
    write_reg_fields control { .SETVALID = 1 };
    
    sys.exp_read_data = 0b10;
    read_reg status;
  };
};
'>
