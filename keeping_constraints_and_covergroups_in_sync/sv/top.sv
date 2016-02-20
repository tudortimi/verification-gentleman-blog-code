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


module top;
  initial begin
    static some_package::cov_collector cov_collector = new();
    static some_package::better_cov_collector better_cov_collector = new();
    automatic some_package::item item = new();
    if (!item.randomize())
      $fatal(1, "Randomization error");
    cov_collector.sample(item);
    better_cov_collector.sample(item);
  end
endmodule
