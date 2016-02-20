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


class corner_case_mixin #(type T) extends T;
  function new(string name);
    super.new(name);
  endfunction


  constraint corner_case {
    mode dist { DATA := 3, INSTR := 1 };
    privilege dist { PRIVILEGED := 3, USER := 1 };
    (mode == DATA && privilege == PRIVILEGED) ->
      (addr inside { [32'h0:32'h20] } && size == WORD && burst == SINGLE);
  }
endclass



class fast_reads_mixin #(type T) extends T;
  function new(string name);
    super.new(name);
  endfunction


  constraint fast_reads {
    size dist { WORD := 3, BYTE := 1, HALFWORD := 1 };
    (direction == READ && size == WORD) -> delay == 0;
  }
endclass



class slow_writes_mixin #(type T) extends T;
  function new(string name);
    super.new(name);
  endfunction


  constraint slow_writes {
    size dist { WORD := 3, BYTE := 1, HALFWORD := 1 };
    (direction == WRITE && size == WORD) -> delay == 10;
  }
endclass
