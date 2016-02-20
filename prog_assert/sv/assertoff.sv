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


module assertoff;
  initial begin
    $assertoff();
    $display("some_byte = %0d", get_rand_byte());
  end

  function automatic byte get_rand_byte();
    byte some_var;
    assert (std::randomize(some_var) with { some_var == 10; });
    return some_var;
  endfunction
endmodule
