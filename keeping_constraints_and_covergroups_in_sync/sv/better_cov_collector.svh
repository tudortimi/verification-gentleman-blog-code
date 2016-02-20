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


class better_cov_collector;
  covergroup cov with function sample(bit[2:0] x, bit[2:0] y);
    coverpoint x;
    coverpoint y;

    cross x, y {
      function CrossQueueType create_ignore_bins();
        item it = new();
        for (int i = 0; i < 8; i++)
          for (int j = 0; j < 8; j++) begin
            if (!it.randomize() with { x == i; y == j; })
              create_ignore_bins.push_back('{ i, j });
          end
      endfunction

      ignore_bins ignore = create_ignore_bins();
    }
  endgroup


  function new();
    cov = new();
  endfunction

  function void sample(item it);
    cov.sample(it.x, it.y);
  endfunction
endclass
