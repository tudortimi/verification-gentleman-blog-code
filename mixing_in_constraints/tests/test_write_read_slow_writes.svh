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


class test_write_read_slow_writes extends test_write_read;
  `uvm_component_utils(test_write_read_slow_writes)


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_factory factory = uvm_factory::get();
    factory.set_type_override_by_type(vgm_ahb_item::get_type(),
      slow_writes_ahb_item::get_type());
  endfunction
endclass
