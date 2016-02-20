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


class vgm_reg_enum_field #(type T) extends uvm_reg_field;
  rand T value;


  constraint values_in_sync {
    super.value == uvm_reg_data_t'(value);
  }


  function new(string name = "vgm_reg_enum_field");
    super.new(name);
  endfunction


  function void configure(uvm_reg parent, int unsigned size,
    int unsigned lsb_pos, string access, bit volatile, uvm_reg_data_t reset,
    bit has_reset, bit is_rand, bit individually_accessible
  );
    if (size != $bits(T))
      `uvm_fatal("SIZERR", "Size and enum width don't match")
    super.configure(parent, size, lsb_pos, access, volatile, reset, has_reset,
      is_rand, individually_accessible);
  endfunction


  function void pre_randomize();
    super.pre_randomize();
    value.rand_mode(super.value.rand_mode());
    value = bits2enum(super.value);
  endfunction


  virtual function int unsigned get_n_bits();
    int unsigned size = super.get_n_bits();
    if (size != $bits(T))
      `uvm_fatal("SIZERR", "Size and enum width don't match")
    return size;
  endfunction


  virtual function void set_reset_enum(T value, string kind = "HARD");
    super.set_reset(uvm_reg_data_t'(value), kind);
  endfunction


  virtual function T get_reset_enum(string kind = "HARD");
    return bits2enum(get_reset(kind));
  endfunction


  virtual function void set(uvm_reg_data_t value, string fname = "",
    int lineno = 0
  );
    super.set(value, fname, lineno);
    this.value = bits2enum(super.value);
  endfunction


  virtual function uvm_reg_data_t get(string fname = "", int lineno = 0);
    if (value != bits2enum(super.value))
      `uvm_fatal("VALERR", "Inconsistend desired values")
    return super.get(fname, lineno);
  endfunction


  virtual function void set_enum(T value, string fname = "", int lineno = 0);
    set(enum2bits(value), fname, lineno);
  endfunction


  virtual function T get_enum(string fname = "", int lineno = 0);
    return bits2enum(get(fname, lineno));
  endfunction


  virtual function void do_predict(uvm_reg_item rw,
    uvm_predict_e kind = UVM_PREDICT_DIRECT, uvm_reg_byte_en_t be = -1
  );
    super.do_predict(rw, kind, be);
    this.value = bits2enum(super.value);
  endfunction


  virtual function T get_mirrored_value_enum(string fname = "",
    int lineno = 0
  );
    return bits2enum(get_mirrored_value(fname, lineno));
  endfunction


  // TODO convert2string


  protected virtual function T bits2enum(uvm_reg_data_t value);
    if (!$cast(bits2enum, value))
      `uvm_fatal("CASTERR", { "In field '", get_name(), "': ",
        $sformatf("Requested value 'b%0b not mapped to enum literal", value) })
  endfunction


  protected virtual function uvm_reg_data_t enum2bits(T value);
    return value;
  endfunction
endclass
