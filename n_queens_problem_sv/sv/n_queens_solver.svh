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


class n_queens_solver #(int unsigned n = 8);
  rand bit board[n][n];
  
  // Helper fields
  rand bit rows[n][n];
  rand bit cols[n][n];
  rand bit main_diags[2*n - 1][];
  rand bit anti_diags[2*n - 1][];
  
  
  // Constraints to create the helper fields.
  
  constraint create_rows {
    foreach (rows[i, j])
      rows[i][j] == board[i][j];
  }
  
  constraint create_cols {
    foreach (cols[i, j])
      cols[i][j] == board[j][i];
  }
  
  constraint create_main_diags {
    foreach (main_diags[i,j])
      if (i < n)
        main_diags[i][j] == board[j][(n - 1) - i + j];
      else
        main_diags[i][j] == board[i - (n - 1) + j][j];
  }
  
  constraint create_anti_diags {
    foreach (anti_diags[i,j])
      if (i < n)
        anti_diags[i][j] == board[i - j][j];
      else
        anti_diags[i][j] == board[(n - 1) - j][i + j - (n - 1)];
  }
  
      
  function void pre_randomize();
    foreach (main_diags[i])
      main_diags[i] = new[get_len_of_diag(i)];
    
    foreach (anti_diags[i])
      anti_diags[i] = new[get_len_of_diag(i)];
  endfunction
  
  
  //----------------------------------------------------------------------------
  // Constraints to solve the puzzle
  //----------------------------------------------------------------------------
  
  // Since we want to place N queens, it means that we have to have one queen on
  // each row and one queen on each column.
  
  constraint singular_on_row {
    foreach (rows[i])
      rows[i].sum() with ( int'(item) ) == 1;
  }
  
  constraint singular_on_col {
    foreach (cols[i])
      cols[i].sum() with ( int'(item) ) == 1;
  }

  // There are 2*N - 1 diagonals on a board. Not all of them are controlled by a
  // queen.

  constraint singular_on_main_diag {
    foreach (main_diags[i])
      main_diags[i].sum() with ( int'(item) ) inside {0, 1};
  }
  
  constraint singular_on_anti_diag {
    foreach (anti_diags[i])
      anti_diags[i].sum() with ( int'(item) ) inside {0, 1};
  }
  
  
  function void print();
    print_separator();
    for (int i = 0; i < n; i++) begin
      string line = "| ";
      for (int j = 0; j < n; j++) begin
        line = { line, board[i][j] ? "Q" : " ", " " };
        line = { line, "| "};
      end
      $display("%s", line);
      print_separator();
    end
  endfunction
  
  
  local function void print_separator();
    string line;
    for (int i = 0; i < n; i++)
      line = { line, "+---" };
    line = { line, "+" };
    $display(line);
  endfunction
  
  
  function int unsigned get_len_of_diag(int unsigned idx);
    if (idx < n)
      return idx + 1;
    
    return 2*n - (idx + 1);
  endfunction
endclass
