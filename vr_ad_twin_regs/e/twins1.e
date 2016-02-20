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


//--------------------------------------------------
// Twin regs with different layouts for read/write
//--------------------------------------------------
<'
reg_def STATUS {
  reg_fld VALID : uint(bits : 1) : R : 0;
  reg_fld DONE  : uint(bits : 1) : R : 0;
};

reg_def CONTROL {
  reg_fld SETVALID : uint(bits : 1) : W : 0;
  reg_fld CLRVALID : uint(bits : 1) : W : 0;
  reg_fld CLRDONE  : uint(bits : 1) : W : 0;
  reg_fld START    : uint(bits : 1) : W : 0;
};


// proxy reg for the twins
reg_def STATUS_CONTROL_PROXY {
  reg_fld DATA : uint(bits : 32);
  
  set_static_info() is also {
    set_compare_mask(0);
  };
};


// register file to hold the twins
extend vr_ad_reg_file_kind : [ STATUS_CONTROL_TWINS ];
extend STATUS_CONTROL_TWINS vr_ad_reg_file {
  status  : STATUS  vr_ad_reg;
  control : CONTROL vr_ad_reg;
  
  keep size == 8;
  
  add_registers() is also {
    add_with_offset(0x0, status);
    add_with_offset(0x4, control);
  };
  
  
  // this is called whenever the proxy reg is accessed
  indirect_access(direction : vr_ad_rw_t, ad_item : vr_ad_base) is {
    var data := ad_item.as_a(vr_ad_reg).get_access_data();
    if direction == WRITE {
      control.update(0, data, {});
    }
    else {
      compute status.compare_and_update(0, data);
    };
  };
};


extend EXAMPLE vr_ad_reg_file {
  status_control_proxy : STATUS_CONTROL_PROXY vr_ad_reg;
  status_control_twins : STATUS_CONTROL_TWINS vr_ad_reg_file;
  
  add_registers() is also {
    add_with_offset(0x0, status_control_proxy);
    status_control_proxy.attach(status_control_twins);
  };
};


// this sequence is called whenever CONTROL/STATUS is accessed
extend vr_ad_sequence_kind : [ACCESS_TWIN_REG];
extend ACCESS_TWIN_REG INDIRECT vr_ad_sequence {
  !proxy_reg : STATUS_CONTROL_PROXY vr_ad_reg;
  
  // patch to the Cadence example - use the "raw" versions of read/write
  // otherwise it doesn't work for R/W fields
  body() @driver.clock is only {
    if direction == WRITE {
      write_reg proxy_reg val reg.read_reg_rawval();
    } else {
      read_reg proxy_reg;
      if not reg.in_model {
        reg.write_reg_rawval(proxy_reg.read_reg_rawval());
      };
    };
  };
};


extend sys {
  connect_pointers() is also {
    addr_map.add_unmapped_item(reg_file.status_control_twins);
    reg_file.status_control_twins.set_indirect_seq_name(ACCESS_TWIN_REG);
  };
};
'>


<'
extend STATUS vr_ad_reg {
  indirect_access(direction : vr_ad_rw_t, ad_item : vr_ad_base) is {
    if direction == WRITE {
      var control := ad_item.as_a(CONTROL vr_ad_reg);
      assert control != NULL;
      
      model_valid(control);
    };
  };
  
  
  model_valid(control : CONTROL vr_ad_reg) is {
    if control.SETVALID == 1 and control.CLRVALID == 0 {
      VALID = 1;
    }
    else if control.CLRVALID == 1 {
      VALID = 0;
    };
  };
};


extend STATUS_CONTROL_TWINS vr_ad_reg_file {
  add_registers() is also {
    control.attach(status);
  };
};
'>
