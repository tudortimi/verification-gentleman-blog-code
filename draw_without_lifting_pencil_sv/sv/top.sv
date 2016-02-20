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


`include "drawer.svh"


class barn_drawer extends drawer;
  function new();
    add_edge(0, 1);
    add_edge(0, 2);
    add_edge(1, 2);
    add_edge(1, 3);
    add_edge(1, 4);
    add_edge(2, 3);
    add_edge(2, 4);
    add_edge(3, 4);
  endfunction
endclass


module top;
  initial begin
    automatic barn_drawer dr = new();
    dr.draw();
  end
endmodule
