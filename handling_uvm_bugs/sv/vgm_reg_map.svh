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


class vgm_reg_map extends uvm_reg_map;
  `uvm_object_utils(vgm_reg_map)

  function new(string name="vgm_reg_map");
    super.new(name);
  endfunction


  virtual function int get_physical_addresses(uvm_reg_addr_t base_addr,
    uvm_reg_addr_t mem_offset, int unsigned n_bytes, ref uvm_reg_addr_t addr[]
  );
    int bus_width = get_n_bytes(UVM_NO_HIER);
    uvm_reg_map  up_map;
    uvm_reg_addr_t  local_addr[];
    int multiplier = get_addr_unit_bytes();

    addr = new [0];

    if (n_bytes <= 0) begin
       `uvm_fatal("RegModel", $sformatf("Cannot access %0d bytes. Must be greater than 0",
                                      n_bytes));
       return 0;
    end

    // First, identify the addresses within the block/system
    if (n_bytes <= bus_width) begin
       local_addr = new [1];
       local_addr[0] = base_addr + (mem_offset * multiplier);
    end else begin
       int n;

       n = ((n_bytes-1) / bus_width) + 1;
       local_addr = new [n];

       base_addr = base_addr + mem_offset * (n * multiplier);

       case (get_endian(UVM_NO_HIER))
          UVM_LITTLE_ENDIAN: begin
             foreach (local_addr[i]) begin
                local_addr[i] = base_addr + (i * multiplier);
             end
          end
          UVM_BIG_ENDIAN: begin
             foreach (local_addr[i]) begin
                n--;
                local_addr[i] = base_addr + (n * multiplier);
             end
          end
          UVM_LITTLE_FIFO: begin
             foreach (local_addr[i]) begin
                local_addr[i] = base_addr;
             end
          end
          UVM_BIG_FIFO: begin
             foreach (local_addr[i]) begin
                local_addr[i] = base_addr;
             end
          end
          default: begin
             `uvm_error("RegModel",
                {"Map has no specified endianness. ",
                 $sformatf("Cannot access %0d bytes register via its %0d byte \"%s\" interface",
                n_bytes, bus_width, get_full_name())})
          end
       endcase
    end

    up_map = get_parent_map();

    // Then translate these addresses in the parent's space
    if (up_map == null) begin
       // This is the top-most system/block!
       addr = new [local_addr.size()] (local_addr);
       foreach (addr[i]) begin
          addr[i] += get_base_addr(UVM_NO_HIER);
       end
    end else begin
       uvm_reg_addr_t  sys_addr[];
       uvm_reg_addr_t  base_addr;
       int w, k;

       // Scale the consecutive local address in the system's granularity
       if (bus_width < up_map.get_n_bytes(UVM_NO_HIER))
         k = 1;
       else
         k = ((bus_width-1) / up_map.get_n_bytes(UVM_NO_HIER)) + 1;

       base_addr = up_map.get_submap_offset(this);
       foreach (local_addr[i]) begin
          int n = addr.size();

          w = up_map.get_physical_addresses(base_addr + local_addr[i] * k,
                                            0,
                                            bus_width,
                                            sys_addr);

          addr = new [n + sys_addr.size()] (addr);
          foreach (sys_addr[j]) begin
             addr[n+j] = sys_addr[j];
          end
       end
       // The width of each access is the minimum of this block or the system's width
       if (w < bus_width)
          bus_width = w;
    end

    return bus_width;
  endfunction
endclass
