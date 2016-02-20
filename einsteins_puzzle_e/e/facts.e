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
define <neighbors'statement> "<first'exp> neighbors <second'exp>" as {
  extend neighborhood {
    keep for each (resident) in residents {
      resident.<first'exp> =>
        index < 4 and residents[index+1].<second'exp> or
          index > 0 and residents[index-1].<second'exp>;
    };
  };
};
'>


<'
extend resident {
  keep nationality == ENGLISH => house_color == RED; // #1
  keep nationality == SWEDISH => pet == DOG; // #2
  keep nationality == DANISH => drink == TEA; // #3
};

extend neighborhood {
  // #4
  keep for each (resident) in residents {
    resident.house_color == GREEN =>
      index < 4 and residents[index+1].house_color == WHITE;
  };
};

extend resident {
  keep house_color == GREEN => drink == COFFEE; // #5
  keep cigarette == PALL_MALL => pet == BIRD; // #6
  keep house_color == YELLOW => cigarette == DUNHILL; // #7
};

extend neighborhood {
  keep residents[2].drink == MILK; // #8
  keep residents[0].nationality == NORWEGIAN; // #9
};

cigarette == BLEND neighbors pet == CAT; // #10

extend resident {
  keep cigarette == BLUE_MASTERS => drink == BEER; // #11
};

pet == HORSE neighbors cigarette == DUNHILL; // #12

extend resident {
  keep nationality == GERMAN => cigarette == PRINCE; // #13
};

nationality == NORWEGIAN neighbors house_color == BLUE; // #14
cigarette == BLEND neighbors drink == WATER; // #15
'>
