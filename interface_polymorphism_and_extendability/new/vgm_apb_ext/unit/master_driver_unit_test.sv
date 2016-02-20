`include "svunit_defines.svh"


module master_driver_unit_test;
  import svunit_pkg::svunit_testcase;
  import svunit_uvm_mock_pkg::*;

  string name = "master_driver_ut";
  svunit_testcase svunit_ut;

  import vgm_apb_ext::*;
  master_driver driver;

  import uvm_pkg::*;
  uvm_sequencer #(vgm_apb::transfer) sequencer;

  bit rst_n, clk;
  always #1 clk = ~clk;
  vgm_apb_ext_master_interface master_if(rst_n, clk);


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
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.address = 'hdead_beaf;
      transfer.size = WORD;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PSEL === 1)
          `FAIL_UNLESS(master_if.cb.PENABLE === 0)
          `FAIL_UNLESS(master_if.cb.PWRITE === READ)
          `FAIL_UNLESS(master_if.cb.PADDR === 'hdead_beaf)
          `FAIL_UNLESS(master_if.cb.PSIZE === WORD)
        end
      join
    `SVTEST_END


    `SVTEST(drive_setup_phase_write)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = WRITE;
      transfer.address = 'h1234_5678;
      transfer.size = HALFWORD;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PSEL === 1)
          `FAIL_UNLESS(master_if.cb.PENABLE === 0)
          `FAIL_UNLESS(master_if.cb.PWRITE === WRITE)
          `FAIL_UNLESS(master_if.cb.PADDR === 'h1234_5678)
          `FAIL_UNLESS(master_if.cb.PSIZE === HALFWORD)
        end
      join
    `SVTEST_END


    `SVTEST(drive_access_phase_write_byte0)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = WRITE;
      transfer.address = 'h0;
      transfer.size = BYTE;
      transfer.data = 'hff;

      fork
        sequencer.execute_item(transfer);

        begin
          master_if.PWDATA <= 0;
          @(master_if.cb);
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PWDATA[7:0] === 'hff)
          `FAIL_UNLESS(master_if.cb.PWDATA[31:8] === 'h0)
        end
      join
    `SVTEST_END


    `SVTEST(drive_access_phase_write_byte1)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = WRITE;
      transfer.address = 'h1;
      transfer.size = BYTE;
      transfer.data = 'hff;

      fork
        sequencer.execute_item(transfer);

        begin
          master_if.PWDATA <= 0;
          @(master_if.cb);
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PWDATA[7:0] === 'h0)
          `FAIL_UNLESS(master_if.cb.PWDATA[15:8] === 'hff)
          `FAIL_UNLESS(master_if.cb.PWDATA[31:16] === 'h0)
        end
      join
    `SVTEST_END


    `SVTEST(drive_access_phase_write_byte2)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = WRITE;
      transfer.address = 'h2;
      transfer.size = BYTE;
      transfer.data = 'hff;

      fork
        sequencer.execute_item(transfer);

        begin
          master_if.PWDATA <= 0;
          @(master_if.cb);
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PWDATA[15:0] === 'h0)
          `FAIL_UNLESS(master_if.cb.PWDATA[23:16] === 'hff)
          `FAIL_UNLESS(master_if.cb.PWDATA[31:24] === 'h0)
        end
      join
    `SVTEST_END


    `SVTEST(drive_access_phase_write_byte3)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = WRITE;
      transfer.address = 'h3;
      transfer.size = BYTE;
      transfer.data = 'hff;

      fork
        sequencer.execute_item(transfer);

        begin
          master_if.PWDATA <= 0;
          @(master_if.cb);
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PWDATA[23:0] === 'h0)
          `FAIL_UNLESS(master_if.cb.PWDATA[31:24] === 'hff)
        end
      join
    `SVTEST_END


    `SVTEST(drive_access_phase_write_halfword0)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = WRITE;
      transfer.address = 'h0;
      transfer.size = HALFWORD;
      transfer.data = 'hffaa;

      fork
        sequencer.execute_item(transfer);

        begin
          master_if.PWDATA <= 0;
          @(master_if.cb);
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PWDATA[15:0] === 'hffaa)
          `FAIL_UNLESS(master_if.cb.PWDATA[31:16] === 'h0)
        end
      join
    `SVTEST_END


    `SVTEST(drive_access_phase_write_halfword1)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = WRITE;
      transfer.address = 'h2;
      transfer.size = HALFWORD;
      transfer.data = 'hffaa;

      fork
        sequencer.execute_item(transfer);

        begin
          master_if.PWDATA <= 0;
          @(master_if.cb);
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PWDATA[15:0] === 'h0)
          `FAIL_UNLESS(master_if.cb.PWDATA[31:16] === 'hffaa)
        end
      join
    `SVTEST_END


    `SVTEST(drive_access_phase_write_word0)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = WRITE;
      transfer.address = 'h0;
      transfer.size = WORD;
      transfer.data = 'haabb_ccdd;

      fork
        sequencer.execute_item(transfer);

        begin
          master_if.PWDATA <= 0;
          @(master_if.cb);
          @(master_if.cb);
          `FAIL_UNLESS(master_if.cb.PWDATA === 'haabb_ccdd)
        end
      join
    `SVTEST_END


    `SVTEST(drive_access_phase_read_byte0)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = READ;
      transfer.address = 'h0;
      transfer.size = BYTE;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);
          master_if.PRDATA <= 'hff;
          @(master_if.cb);
        end
      join
      `FAIL_UNLESS(transfer.data == 'hff)
    `SVTEST_END


    `SVTEST(drive_access_phase_read_byte1)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = READ;
      transfer.address = 'h1;
      transfer.size = BYTE;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);
          master_if.PRDATA <= 'hff00;
          @(master_if.cb);
        end
      join
      `FAIL_UNLESS(transfer.data == 'hff)
    `SVTEST_END


    `SVTEST(drive_access_phase_read_byte2)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = READ;
      transfer.address = 'h2;
      transfer.size = BYTE;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);
          master_if.PRDATA <= 'hff_0000;
          @(master_if.cb);
        end
      join
      `FAIL_UNLESS(transfer.data == 'hff)
    `SVTEST_END


    `SVTEST(drive_access_phase_read_byte3)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = READ;
      transfer.address = 'h3;
      transfer.size = BYTE;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);
          master_if.PRDATA <= 'hff00_0000;
          @(master_if.cb);
        end
      join
      `FAIL_UNLESS(transfer.data == 'hff)
    `SVTEST_END


    `SVTEST(drive_access_phase_read_halfword0)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = READ;
      transfer.address = 'h0;
      transfer.size = HALFWORD;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);
          master_if.PRDATA <= 'hffaa;
          @(master_if.cb);
        end
      join
      `FAIL_UNLESS(transfer.data == 'hffaa)
    `SVTEST_END


    `SVTEST(drive_access_phase_read_halfword1)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = READ;
      transfer.address = 'h2;
      transfer.size = HALFWORD;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);
          master_if.PRDATA <= 'hffaa_0000;
          @(master_if.cb);
        end
      join
      `FAIL_UNLESS(transfer.data == 'hffaa)
    `SVTEST_END


    `SVTEST(drive_access_phase_read_word0)
      vgm_apb_ext::transfer transfer = new("transfer");
      transfer.direction = READ;
      transfer.address = 'h0;
      transfer.size = WORD;

      fork
        sequencer.execute_item(transfer);

        begin
          @(master_if.cb);
          master_if.PRDATA <= 'haabb_ccdd;
          @(master_if.cb);
        end
      join
      `FAIL_UNLESS(transfer.data == 'haabb_ccdd)
    `SVTEST_END

  `SVUNIT_TESTS_END


  task reset();
    rst_n = 0;
    master_if.PREADY = 1;
    master_if.PRDATA = 'x;
    @(negedge clk);
    rst_n <= 1;
    @(master_if.cb);
  endtask

endmodule
