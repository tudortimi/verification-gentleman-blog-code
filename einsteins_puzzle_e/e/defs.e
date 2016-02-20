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
type nationality_t : [ ENGLISH, SWEDISH, DANISH, NORWEGIAN, GERMAN ];
type house_color_t : [ RED, GREEN, YELLOW, BLUE, WHITE ];
type cigarette_t : [ DUNHILL, BLEND, BLUE_MASTERS, PRINCE, PALL_MALL ];
type pet_t : [ DOG, BIRD, CAT, HORSE, FISH ];
type drink_t : [ TEA, COFFEE, MILK, BEER, WATER ];
'>


<'
struct resident {
  nationality : nationality_t;
  house_color : house_color_t;
  cigarette : cigarette_t;
  pet : pet_t;
  drink : drink_t;
};
'>


<'
struct neighborhood {
  residents[5] : list of resident;

  keep residents.all_different(it.nationality);
  keep residents.all_different(it.house_color);
  keep residents.all_different(it.cigarette);
  keep residents.all_different(it.pet);
  keep residents.all_different(it.drink);
};
'>
