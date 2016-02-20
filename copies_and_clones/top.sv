class some_class;
  protected int some_val;

  function new(int some_val);
    this.some_val = some_val;
  endfunction

  virtual function void print();
    $display("some_val = %d", some_val);
  endfunction

  function void copy(some_class rhs);
    this.some_val = rhs.some_val;
  endfunction

  virtual function some_class clone();
    some_class ret = new(0);
    ret.copy(this);
    return ret;
  endfunction
endclass


class some_other_class extends some_class;
  protected int some_other_val;

  function new(int some_val, int some_other_val);
    super.new(some_val);
    this.some_other_val = some_other_val;
  endfunction

  virtual function void print();
    $display("some_val = %0d", some_val);
  endfunction
  
  function void copy(some_other_class rhs);
    super.copy(rhs);
    this.some_other_val = rhs.some_other_val;
  endfunction

  virtual function some_other_class clone();
    some_other_class ret = new(0);
    ret.copy(this);
    return ret;
  endfunction
endclass


module top;
  some_class obj0, obj1, obj2;
  some_other_class other_obj0, other_obj1, other_obj2;

  initial begin
    obj0 = new(5);
    obj1 = new(10);
    obj1.print();
    obj1.copy(obj0);
    obj1.print();
    obj2 = obj0.clone();
    obj2.print();
  end
endmodule
