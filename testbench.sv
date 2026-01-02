module tb_VSCPU;
  parameter SIZE = 14, DEPTH = 2**SIZE;
  reg clk, rst, interrupt;
  wire wrEn;
  wire [SIZE-1:0] addr_toRAM;
  wire [31:0] data_toRAM, data_fromRAM;

  VSCPU_ISR uut (clk, rst, data_fromRAM, wrEn,  addr_toRAM, data_toRAM, interrupt);

  blram #(SIZE, DEPTH) inst_bram (
clk, rst, wrEn, addr_toRAM, data_toRAM, data_fromRAM);

  initial begin
    tlk = 1;
    interrupt = 0;
    forever
      #5 clk = ~clk;
  end

  initial begin
    rst = 1;
    repeat (10) @(posedge clk);
    rst <= #1 0;
    repeat (600) @(posedge clk);
    $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    inst_bram.mem[0] = 32'h1002800a; // ADDi 10 10
    inst_bram.mem[1] = 32'h8002c00a; // CP 11 10
    inst_bram.mem[2] = 32'hc0020007; // BZJ 8 7
    inst_bram.mem[7] = 32'h0; // Data
    inst_bram.mem[8] = 32'hd; // Address
    inst_bram.mem[10] = 32'h5; // Data
    inst_bram.mem[13] = 32'h1002c00a; // ADDi 11 10
  end
endmodule

