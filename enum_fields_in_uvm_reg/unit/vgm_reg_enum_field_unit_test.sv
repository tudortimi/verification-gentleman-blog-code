module vgm_reg_enum_field_unit_test;
  import svunit_pkg::svunit_testcase;
  `include "svunit_defines.svh"

  string name = "vgm_reg_enum_field_ut";
  svunit_testcase svunit_ut;


  import vgm_reg_utils::*;
  import uvm_pkg::*;

  class uvm_reg_mock extends uvm_reg;
    function new(string name = "uvm_reg_mock");
      super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
  endclass

  typedef enum bit[1:0] { FOO, BAR, GOO } type_e;

  vgm_reg_enum_field #(type_e) field;
  uvm_reg_mock parent;


  function void build();
    svunit_ut = new(name);

    field = new("field");
    parent = new("parent");
    field.configure(parent, 2, 0, "RW", 0, uvm_reg_data_t'(FOO), 1, 1, 0);
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask



  `SVUNIT_TESTS_BEGIN

    `SVTEST(randomize__values_in_sync)
      `FAIL_IF(!field.randomize() with { value == BAR; })
    `SVTEST_END

    `SVTEST(set_reset_enum)
      field.set_reset_enum(BAR);
      `FAIL_IF(field.get_reset_enum() != BAR)
    `SVTEST_END

    `SVTEST(set_reset_enum__in_sync)
      field.set_reset_enum(BAR);
      `FAIL_IF(field.get_reset() != uvm_reg_data_t'(BAR))
    `SVTEST_END

    `SVTEST(set__in_sync)
      field.set(2'b01);
      `FAIL_IF(field.value != BAR)
    `SVTEST_END

    `SVTEST(set_enum)
      field.set_enum(BAR);
      `FAIL_IF(field.value != BAR)
    `SVTEST_END

    `SVTEST(set_enum__in_sync)
      field.set_enum(BAR);
      `FAIL_IF(field.get() != uvm_reg_data_t'(BAR))
    `SVTEST_END

    `SVTEST(get_enum)
      field.set_enum(BAR);
      `FAIL_IF(field.get_enum() != BAR)
    `SVTEST_END

    `SVTEST(get_enum__in_sync)
      field.set(uvm_reg_data_t'(BAR));
      `FAIL_IF(field.get_enum() != BAR)
    `SVTEST_END

    `SVTEST(do_predict__in_sync)
      uvm_reg_item rw = new("rw");
      rw.value = new[1];
      rw.value[0] = 2'b01;
      field.do_predict(rw);
      `FAIL_IF(field.value != BAR)
    `SVTEST_END

    `SVTEST(get_mirrored_value_enum)
      uvm_reg_item rw = new("rw");
      rw.value = new[1];
      rw.value[0] = 2'b01;
      field.do_predict(rw);
      `FAIL_IF(field.get_mirrored_value_enum() != BAR)
    `SVTEST_END

    `SVTEST(set__unmapped__issues_fatal)
      field.set(2'b11);
      `FAIL_IF(field.value != BAR)
    `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
