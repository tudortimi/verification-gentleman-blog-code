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



virtual class drawer;
  typedef int unsigned vertex_t;
  typedef vertex_t connections_t[$];
  typedef struct {
    rand vertex_t v1;
    rand vertex_t v2;
  } edge_t;


  local connections_t connections[vertex_t];
  local edge_t edges[$];
  local vertex_t vertices[$];

  local rand edge_t edge_being_drawn[];


  constraint choose_existing_edges {
    foreach (edge_being_drawn[i])
      edge_being_drawn[i].v1 inside { vertices };

    foreach (edge_being_drawn[i])
      foreach (connections[v])
        if (edge_being_drawn[i].v1 == v)
          edge_being_drawn[i].v2 inside { connections[v] };
  }


  constraint choose_unique_edges {
    foreach (edge_being_drawn[i])
      foreach (edge_being_drawn[j])
        if (i != j)
          !(edge_being_drawn[i].v1 == edge_being_drawn[j].v1 &&
            edge_being_drawn[i].v2 == edge_being_drawn[j].v2);

    foreach (edge_being_drawn[i])
      foreach (edge_being_drawn[j])
        // XXX (Very) Possible bug in simulator
        if (i == j - 1)
          edge_being_drawn[i].v1 != edge_being_drawn[j].v2;
        else if (j == i - 1)
          edge_being_drawn[j].v1 != edge_being_drawn[i].v2;
        else

        // This condition should be enough by itself.
        if (i != j)
          !(edge_being_drawn[i].v1 == edge_being_drawn[j].v2 &&
            edge_being_drawn[i].v2 == edge_being_drawn[j].v1);
  }


  constraint choose_connected_edges {
    foreach (edge_being_drawn[i])
      if (i > 0)
        edge_being_drawn[i].v1 == edge_being_drawn[i - 1].v2;
  }


  function void pre_randomize();
    vertex_t v;
    void'(connections.first(v));
    do
      vertices.push_back(v);
    while (connections.next(v));

    edge_being_drawn = new[edges.size()];
  endfunction


  protected function void add_edge(vertex_t vertex1, vertex_t vertex2);
    if (connections.exists(vertex1) && vertex2 inside { connections[vertex1] })
      $fatal(0, "Connection %0d -> %0d already exists", vertex1, vertex2);

    connect_vertices(vertex1, vertex2);
    connect_vertices(vertex2, vertex1);

    begin
      edge_t e;
      e.v1 = vertex1;
      e.v2 = vertex2;
      edges.push_back(e);
    end
  endfunction


  local function void connect_vertices(vertex_t src, vertex_t dest);
    if (connections.exists(src))
      connections[src].push_back(dest);
    else
      connections[src] = '{ dest };
  endfunction


  function void draw();
    if (!randomize())
      $fatal(0, "Could not draw");

    print_drawing_instructions();
  endfunction


  function void print_drawing_instructions();
    foreach (edge_being_drawn[i])
      $display("Connect vertex %0d to vertex %0d", edge_being_drawn[i].v1,
        edge_being_drawn[i].v2);
  endfunction
endclass
