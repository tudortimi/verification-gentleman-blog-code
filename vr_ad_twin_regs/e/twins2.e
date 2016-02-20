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
// Twin regs with different layouts depending on a
// config field
//--------------------------------------------------
<'
type math_op_t : [NOP, INC, DEC, ADD, SUB];

reg_def MATH_OP EXAMPLE 0x4 {
  reg_fld OP : math_op_t : RW : NOP;
};

reg_def UNARY_ARG {
  reg_fld ARG : byte : RW : 0;
};

reg_def BINARY_ARGS {
  reg_fld ARG0 : byte : RW : 0;
  reg_fld ARG1 : byte : RW : 0;
};


// proxy reg for the twins
reg_def ARGS_PROXY {
  reg_fld DATA : uint(bits : 32);
  
  set_static_info() is also {
    set_compare_mask(0);
  };
};


// register file to hold the twins
extend vr_ad_reg_file_kind : [ ARGS_TWINS ];
extend ARGS_TWINS vr_ad_reg_file {
  unary_arg : UNARY_ARG  vr_ad_reg;
  binary_args : BINARY_ARGS vr_ad_reg;
  
  keep size == 8;
  
  add_registers() is also {
    add_with_offset(0x0, unary_arg);
    add_with_offset(0x4, binary_args);
  };
  
  
  !p_math_op : MATH_OP vr_ad_reg;
  
  // this is called whenever the proxy reg is accessed
  indirect_access(direction : vr_ad_rw_t, ad_item : vr_ad_base) is {
    var data := ad_item.as_a(vr_ad_reg).get_access_data();
    
    if direction == WRITE {
      unary_arg.update(0, data, {});
      binary_args.update(0, data, {});
    }
    else {
      case p_math_op.OP {
        [INC, DEC] : { compute unary_arg.compare_and_update(0, data)  };
        [ADD, SUB] : { compute binary_args.compare_and_update(0, data) };
        [NOP] : { check that %{data} == 0 };
      };
    };
  };
};


extend EXAMPLE vr_ad_reg_file {
  args_proxy : ARGS_PROXY vr_ad_reg;
  args_twins : ARGS_TWINS vr_ad_reg_file;
  
  add_registers() is also {
    add_with_offset(0x0, args_proxy);
    args_proxy.attach(args_twins);
    args_twins.p_math_op = math_op;
  };
};


// this sequence is called whenever CONTROL/STATUS is accessed
extend vr_ad_sequence_kind : [ACCESS_TWIN_REG];
extend ACCESS_TWIN_REG INDIRECT vr_ad_sequence {
  !proxy_reg : ARGS_PROXY vr_ad_reg;
  
  body() @driver.clock is only {
    // a sanity check to make sure I'm not trying to access the wrong twin
    var math_op := driver.addr_map.get_reg_by_kind(MATH_OP).as_a(MATH_OP vr_ad_reg);
    assert(
      (reg.kind == UNARY_ARG => math_op.OP in [INC, DEC]) and
      (reg.kind == BINARY_ARGS => math_op.OP in [ADD, SUB])
    )
      else error(appendf("Cannot access %s when math_op is %s",
        reg.kind.as_a(string), math_op.OP.as_a(string)));
    
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
    addr_map.add_unmapped_item(reg_file.args_twins);
    reg_file.args_twins.set_indirect_seq_name(ACCESS_TWIN_REG);
  };
};
'>
