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


class sudoku_solver_base;
  rand int grid[9][9];
  
  constraint all_elements_1_to_9_c {
    foreach (grid[i, j])
      grid[i][j] inside { [1:9] };
  }
  
  constraint unique_on_row_c {
    foreach (grid[i])
      unique { grid[i] };
  }
  
  // columns become rows -> outer dimension is column
  local rand int grid_transposed[9][9];
  
  constraint create_transposed_c {
    foreach (grid[i, j])
      grid_transposed[i][j] == grid[j][i];
  }
  
  constraint unique_on_column_c {
    foreach (grid_transposed[i])
      unique { grid_transposed[i] };
  }


  // holds the small 3x3 sub_grids that make up the grid
  local rand int sub_grids[3][3][3][3];
  
  constraint create_sub_grids_c {
    foreach (sub_grids[i, j, k, l])
      sub_grids[i][j][k][l] == grid[i*3 + k][j*3 + l];
  }
  
  constraint unique_in_sub_grid_c {
    foreach (sub_grids[i, j])
      unique { sub_grids[i][j] };
  }
  
  
  // the following constraint doesn't do anything but for some reasone
  // keeps the simulator from issuing an internal fail
  
  // holds the sub_grids in 1-dim array form to work around
  local rand int sub_grids_lin[3][3][9];
  
  constraint create_sub_grids_lin_c {
    foreach (sub_grids_lin[i, j, k])
      sub_grids_lin[i][j][k] == sub_grids[i][j][k/3][k%3];
  }
  
  
  function void post_randomize();
    print();
  endfunction


  function void print();
    for (int i = 0; i < 9; i++) begin
      string line;
      for (int j = 0; j < 9; j++) begin
        line = { line, $sformatf("%0d ", grid[i][j]) };
        if (j inside {2, 5 })
          line = { line, "| "};
      end
      $display("%s", line);
      if (i inside { 2, 5 })
        $display("------+-------+------");
    end
  endfunction
endclass


// specialize sudoku solver to solve a specific puzzle
class sudoku_solver extends sudoku_solver_base;
  constraint puzzle_c {
    grid[0][0] == 5;
    grid[0][1] == 3;
    grid[0][4] == 7;
  
    grid[1][0] == 6;
    grid[1][3] == 1;
    grid[1][4] == 9;
    grid[1][5] == 5;
  
    grid[2][1] == 9;
    grid[2][2] == 8;
    grid[2][7] == 6;
  
    grid[3][0] == 8;
    grid[3][4] == 6;
    grid[3][8] == 3;
  
    grid[4][0] == 4;
    grid[4][3] == 8;
    grid[4][5] == 3;
    grid[4][8] == 1;
  
    grid[5][0] == 7;
    grid[5][4] == 2;
    grid[5][8] == 6;
    
    grid[6][1] == 6;
    grid[6][6] == 2;
    grid[6][7] == 8;
    
    grid[7][3] == 4;
    grid[7][4] == 1;
    grid[7][5] == 9;
    grid[7][8] == 5;
    
    grid[8][4] == 8;
    grid[8][7] == 7;
    grid[8][8] == 9;
  }
endclass


module top;
  sudoku_solver solver = new();
  
  initial begin
    if (!solver.randomize())
      $fatal(1, "Could not solve.");
    
    $finish();
  end
endmodule
