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


<'
struct ahb_item like any_sequence_item {
  direction : [ READ, WRITE ];
  size : [ BYTE, HALFWORD, WORD ];
  delay : [ NONE, SMALL, MEDIUM, LARGE ];
};


sequence ahb_sequence using item = ahb_item;


unit ahb_bfm {
  driver : ahb_sequence_driver;

  event clock;

  on clock {
    emit driver.clock;
  };

  run() is also {
    start execute_items();
  };

  execute_items() @clock is {
    while TRUE {
      var item : ahb_item;
      item = driver.get_next_item();
      drive(item);
      emit driver.item_done;
    };
  };

  drive(item : ahb_item) @clock is {
    print item;
  };
};


unit ahb_agent {
  driver : ahb_sequence_driver is instance;
  bfm : ahb_bfm is instance;

  keep bfm.driver == driver;
};
'>
