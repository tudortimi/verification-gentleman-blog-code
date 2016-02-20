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

// - (2) says there is a red house
// - (4) says there is a green house
// - (6) says there is an ivory house
// - (8) says there is a yellow house
// - (15) says there is a blue house
typedef enum { RED, GREEN, IVORY, YELLOW, BLUE } color_e;

// - (2) says there is an Englishman
// - (3) says there is a Spaniard
// - (5) says there is a Ukranian
// - (10) says there is a Norwegian
// - (14) says there is a Japanese
typedef enum { ENGLISH, SPANISH, UKRANIAN, NORWEGIAN, JAPANESE } nationality_e;

// - (3) says someone has a dog
// - (7) says someone has snails
// - (11) says someone has a fox
// - (12) says someone has a horse
// - not explicitly mentioned in the statements, assume from the question that someone has a zebra
typedef enum { DOG, SNAILS, FOX, HORSE, ZEBRA } pet_e;

// - (4) says someone drinks coffee
// - (5) says someone drinks tea
// - (9) says someone drinks milk
// - (13) says somone drinks orange juice
// - not explictly mentioned in the staments, assume from the question that someone drinks water
typedef enum { COFFEE, TEA, MILK, ORANGE_JUICE, WATER } drink_e;

// - (7) says someone smokes Old Gold
// - (8) says someone smokes Kools
// - (11) says someone smokes Chesterfields
// - (13) says someone smokes Lucky Strike
// - (14) says someone smokes Parliaments
typedef enum { OLD_GOLD, KOOL, CHESTERFIELD, LUCKY_STRIKE, PARLIAMENT } cigarettes_e;


// group information together in a struct
typedef struct {
  rand color_e       color;
  rand nationality_e nationality;
  rand pet_e         pet;
  rand drink_e       drink;
  rand cigarettes_e  cigarettes;
} house_t;


class zebra_puzzle_solver;
  // statement 1 says there are 5 houses
  rand house_t house[5];
  
  //----------------------------------------------------------------------
  // all colors, nationalities, pets, drinks and cigarettes are unique
  //----------------------------------------------------------------------
  
  local rand color_e       color[5];
  local rand nationality_e nationality[5];
  local rand pet_e         pet[5];
  local rand drink_e       drink[5];
  local rand cigarettes_e  cigarettes[5];
  
  constraint create_sublists_c {
    foreach (house[i]) (
      color[i] == house[i].color &&
      nationality[i] == house[i].nationality &&
      pet[i] == house[i].pet &&
      drink[i] == house[i].drink &&
      cigarettes[i] == house[i].cigarettes
    ); 
  }
  
  constraint all_unique_c {
    unique { color };
    unique { nationality };
    unique { pet };
    unique { drink };
    unique { cigarettes };
  }
  
  
  //----------------------------------------------------------------------
  // statements
  //----------------------------------------------------------------------
  
  constraint statement2_c {
    foreach (house[i])
      house[i].nationality == ENGLISH <-> house[i].color == RED;
  }
  
  constraint statement3_c {
    foreach (house[i])
      house[i].nationality == SPANISH <-> house[i].pet == DOG;
  }
  
  constraint statement4_c {
    foreach (house[i])
      house[i].drink == COFFEE <-> house[i].color == GREEN;
  }
  
  constraint statement5_c {
    foreach (house[i])
      house[i].nationality == UKRANIAN <-> house[i].drink == TEA;
  }
  
  constraint statement6_c {
    foreach (house[i])
      if (i < 4)  // make sure we don't go out of bounds
        house[i].color == IVORY <-> house[i+1].color == GREEN;
  }
  
  constraint statement7_c {
    foreach (house[i])
      house[i].cigarettes == OLD_GOLD <-> house[i].pet == SNAILS;
  }
  
  constraint statement8_c {
    foreach (house[i])
      house[i].cigarettes == KOOL <-> house[i].color == YELLOW;
  }
  
  constraint statement9_c {
    house[2].drink == MILK; // no. 2 is the middle house
  }
  
  constraint statement10_c {
    house[0].nationality == NORWEGIAN;  // no. 0 is the first house
  }
  
  // TODO this constraint could probably be compacted (but would loose clarity)
  constraint statement11_c {
    house[0].cigarettes == CHESTERFIELD <-> house[1].pet == FOX; // if he lives in the first house
    house[4].cigarettes == CHESTERFIELD <-> house[3].pet == FOX; // if he lives in the last house
    
    // if he lives in the middle houses
    foreach (house[i])
      if (i > 0 && i < 4)
        (house[i].cigarettes == CHESTERFIELD <-> house[i-1].pet == FOX) || (house[i].cigarettes == CHESTERFIELD <-> house[i+1].pet == FOX);
  }
  
  constraint statement12_c {
    house[0].cigarettes == KOOL <-> house[1].pet == HORSE;
    house[4].cigarettes == KOOL <-> house[3].pet == HORSE;
    
    foreach (house[i])
      if (i > 0 && i < 4)
        (house[i].cigarettes == KOOL <-> house[i-1].pet == HORSE) || (house[i].cigarettes == KOOL <-> house[i+1].pet == HORSE);
  }
  
  constraint statement13_c {
    foreach (house[i])
      house[i].cigarettes == LUCKY_STRIKE <-> house[i].drink == ORANGE_JUICE;
  }
  
  constraint statement14_c {
    foreach (house[i])
      house[i].nationality == JAPANESE <-> house[i].cigarettes == PARLIAMENT;
  }
  
  constraint statement15_c {
    house[0].nationality == NORWEGIAN <-> house[1].color == BLUE;
    house[4].nationality == NORWEGIAN <-> house[3].color == BLUE;
    
    foreach (house[i])
      if (i > 0 && i < 4)
        (house[i].nationality == NORWEGIAN <-> house[i-1].color == BLUE) || (house[i].nationality == NORWEGIAN <-> house[i+1].color == BLUE);
  }
  
  
  //----------------------------------------------------------------------
  function void post_randomize();
    print();
  endfunction
  
  
  //----------------------------------------------------------------------
  function void print();
    foreach (house[i]) begin
      $display("House number %0d:", i);
      $display("  color       = ", house[i].color.name());
      $display("  nationality = ", house[i].nationality.name());
      $display("  pet         = ", house[i].pet.name());
      $display("  drink       = ", house[i].drink.name());
      $display("  cigarettes  = ", house[i].cigarettes.name());
      $display("\n");
    end
  endfunction
endclass


module top;
  zebra_puzzle_solver solver = new();
  
  initial begin
    if(!solver.randomize())
      $error("Could not solve the puzzle");

    $finish();
  end
endmodule
