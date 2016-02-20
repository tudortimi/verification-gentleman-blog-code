`include "svunit_defines.svh"


module master_driver_unit_test;
  import svunit_pkg::svunit_testcase;
  import svunit_uvm_mock_pkg::*;

  string name = "master_driver_ut";
  svunit_testcase svunit_ut;

  import vgm_apb_tri::*;
  master_driver driver;

  import uvm_pkg::*;
  uvm_sequencer #(transfer) sequencer;

  bit rst_n, clk;
  wire [31:0] PDATA_wire;
  logic [31:0] PDATA = 'z;
  always #1 clk = ~clk;
  vgm_apb_tri_master_interface master_if(rst_n, clk, PDATA_wire);
  assign PDATA_wire = PDATA;


  function void build();
    svunit_ut = new(name);
    driver = new("driver", null);
    sequencer = new("sequencer", null);
    driver.seq_item_port.connect(sequencer.seq_item_export);
    driver.set_interface_proxy(master_if.proxy);
    svunit_deactivate_uvm_component(driver);
  endfunction

  task setup();
    svunit_ut.setup();
    svunit_activate_uvm_component(driver);
    svunit_uvm_test_start();
    reset();
  endtask

  task teardown();
    svunit_ut.teardown();
    svunit_uvm_test_finish();
    svunit_deactivate_uvm_component(driver);
  endtask


  `SVUNIT_TESTS_BEGIN

    `SVTEST(drive_setup_phase_read)
      vgm_apb::transfer transfer = new("transfer");
      transfer.address = 'hdead_beaf;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PSEL === 1)
          `FAIL_UNLESS(master_if.cb.PENABLE === 0)
          `FAIL_UNLESS(master_if.cb.PWRITE === READ)
          `FAIL_UNLESS(master_if.cb.PADDR === 'hdead_beaf)
        end
      join
    `SVTEST_END


    `SVTEST(drive_setup_phase_write)
      vgm_apb::transfer transfer = new("transfer");
      transfer.direction = WRITE;
      transfer.address = 'h1234_5678;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PSEL === 1)
          `FAIL_UNLESS(master_if.cb.PENABLE === 0)
          `FAIL_UNLESS(master_if.cb.PWRITE === WRITE)
          `FAIL_UNLESS(master_if.cb.PADDR === 'h1234_5678)
        end
      join
    `SVTEST_END


    `SVTEST(drive_access_phase_write)
      vgm_apb::transfer transfer = new("transfer");
      transfer.direction = WRITE;
      transfer.address = 'hdead_beaf;
      transfer.data = 'haabb_ccdd;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PSEL === 1)
          `FAIL_UNLESS(master_if.cb.PENABLE === 1)
          `FAIL_UNLESS(master_if.cb.PWRITE === WRITE)
          `FAIL_UNLESS(master_if.cb.PADDR === 'hdead_beaf)
          `FAIL_UNLESS(master_if.cb.PDATA === 'haabb_ccdd)
        end
      join
    `SVTEST_END


    `SVTEST(drive_access_phase_write_stall)
      vgm_apb::transfer transfer = new("transfer");
      transfer.direction = WRITE;
      transfer.address = 'hdead_beaf;
      transfer.data = 'haabb_ccdd;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);

          master_if.PREADY <= 0;
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PSEL === 1)
          `FAIL_UNLESS(master_if.cb.PENABLE === 1)
          `FAIL_UNLESS(master_if.cb.PWRITE === WRITE)
          `FAIL_UNLESS(master_if.cb.PADDR === 'hdead_beaf)
          `FAIL_UNLESS(master_if.cb.PDATA === 'haabb_ccdd)

          master_if.PREADY <= 1;
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PSEL === 1)
          `FAIL_UNLESS(master_if.cb.PENABLE === 1)
          `FAIL_UNLESS(master_if.cb.PWRITE === WRITE)
          `FAIL_UNLESS(master_if.cb.PADDR === 'hdead_beaf)
          `FAIL_UNLESS(master_if.cb.PDATA === 'haabb_ccdd)
        end
      join
    `SVTEST_END


    `SVTEST(drive_access_phase_read)
      vgm_apb::transfer transfer = new("transfer");
      transfer.direction = READ;
      transfer.address = 'hdead_beaf;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);

          PDATA <= 'haabb_ccdd;
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PSEL === 1)
          `FAIL_UNLESS(master_if.cb.PENABLE === 1)
          `FAIL_UNLESS(master_if.cb.PWRITE === READ)
          `FAIL_UNLESS(master_if.cb.PADDR === 'hdead_beaf)
        end
      join
      `FAIL_UNLESS(transfer.data === 'haabb_ccdd)
    `SVTEST_END


    `SVTEST(drive_access_phase_read_stall)
      vgm_apb::transfer transfer = new("transfer");
      transfer.direction = READ;
      transfer.address = 'hdead_beaf;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);

          master_if.PREADY <= 0;
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PSEL === 1)
          `FAIL_UNLESS(master_if.cb.PENABLE === 1)
          `FAIL_UNLESS(master_if.cb.PWRITE === READ)
          `FAIL_UNLESS(master_if.cb.PADDR === 'hdead_beaf)

          master_if.PREADY <= 1;
          PDATA <= 'haabb_ccdd;
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PSEL === 1)
          `FAIL_UNLESS(master_if.cb.PENABLE === 1)
          `FAIL_UNLESS(master_if.cb.PWRITE === READ)
          `FAIL_UNLESS(master_if.cb.PADDR === 'hdead_beaf)
        end
      join
      `FAIL_UNLESS(transfer.data === 'haabb_ccdd)
    `SVTEST_END


    `SVTEST(drive_idle_after_transfer)
      vgm_apb::transfer transfer = new("transfer");

      sequencer.execute_item(transfer);
      @(master_if.cb);
      `FAIL_UNLESS(master_if.cb.PSEL === 0)
      `FAIL_UNLESS(master_if.cb.PENABLE === 0)
      `FAIL_UNLESS(master_if.cb.PDATA === 'z)
    `SVTEST_END

  `SVUNIT_TESTS_END


  task reset();
    rst_n = 0;
    master_if.PREADY = 1;
    PDATA = 'z;
    @(negedge clk);
    rst_n <= 1;
    @(master_if.cb);
  endtask

endmodule
