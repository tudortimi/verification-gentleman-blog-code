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
import vr_ad/e/vr_ad_top;


extend vr_ad_reg_file_kind : [ EXAMPLE ];
extend EXAMPLE vr_ad_reg_file {
  keep size == 32;
  
  post_generate() is also {
    reset();
  };
};


// a dummy sequence driver
sequence dummy_seq;

extend dummy_seq_driver {
  event clock is only @sys.any;

  // this is a dirty way of emulating what a monitor would do
  vr_ad_execute_op(operation : vr_ad_operation) : list of byte @clock is {
    if operation.direction == WRITE {
      sys.addr_map.update(operation.address, %{operation.get_data()}, {});
    }
    else {
      compute sys.addr_map.compare_and_update(0, %{sys.exp_read_data});
    };
    
    result = %{sys.exp_read_data};
  };
};


extend sys {
  !exp_read_data : vr_ad_data_t;
  
  driver : dummy_seq_driver is instance;
    keep driver.gen_and_start_main == FALSE;
  
  reg_file : EXAMPLE vr_ad_reg_file;
  addr_map : vr_ad_map;
  
  rsd : vr_ad_sequence_driver is instance;
    keep rsd.addr_map == value(addr_map);
    keep rsd.default_bfm_sd == driver;
  
  
  connect_pointers() is also {
    addr_map.add_with_offset(0x0, reg_file);
  };
};
'>
