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


class item;
  rand bit[2:0] x, y;

  constraint x_always_smaller {
    x < y;
  }

  constraint never_same_parity {
    x % 2 == 0 <-> y % 2 == 1;
  }

  constraint if_2_then_5 {
    x == 2 -> y == 5;
  }
endclass
