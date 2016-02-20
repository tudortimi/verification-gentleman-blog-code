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
import twins2;


extend MAIN vr_ad_sequence {
  !math_op : MATH_OP vr_ad_reg;
  !unary_arg : UNARY_ARG vr_ad_reg;
  !binary_args : BINARY_ARGS vr_ad_reg;
  
  
  body() @driver.clock is only {
    // cause assertion to fire
    //write_reg unary_arg;
    //write_reg binary_args;
    
    write_reg_fields math_op { .OP = INC };
    write_reg unary_arg { .ARG == 5 };
    sys.exp_read_data = 5;
    read_reg unary_arg;
    
    write_reg_fields math_op { .OP = ADD };
    sys.exp_read_data = 5;
    read_reg binary_args;
    
    write_reg_fields binary_args {
      .ARG0 = 3;
      .ARG1 = 4;
    };
    sys.exp_read_data = 0x0304;
    read_reg binary_args;
  };
};
'>
