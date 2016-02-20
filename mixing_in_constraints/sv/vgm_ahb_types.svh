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


typedef enum { READ, WRITE } direction_e;
typedef enum { SINGLE, INCR4, WRAP4 } burst_e;
typedef enum { BYTE, HALFWORD, WORD } size_e;
typedef enum { INSTR, DATA } mode_e;
typedef enum { USER, PRIVILEGED } privilege_e;
