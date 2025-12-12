// Code your testbench here
// or browse Examples
module tb_VSCPU;
  parameter SIZE = 14, DEPTH = 2**SIZE;
  reg clk, rst;
  wire wrEn;
  wire [SIZE-1:0] addr_toRAM;
  wire [31:0] data_toRAM, data_fromRAM;
  VSCPU uut1 (clk, rst, data_fromRAM, wrEn, addr_toRAM, data_toRAM);
  blram #(SIZE, DEPTH) uut2 (
  clk, rst, wrEn, addr_toRAM, data_toRAM, data_fromRAM);
  initial begin
    clk = 1;
    forever
    #5 clk = ~clk;
  end
  initial begin
  	rst = 1;
  	repeat (10) @(posedge clk);
  	rst <= #1 0;
    repeat (200) @(posedge clk);
  	$finish;
  end
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    uut2.mem[0] = 32'h1002800a; // ADDi 10 10
    uut2.mem[1] = 32'h8002c00a; // CP 11 10
    uut2.mem[2] = 32'hc0020007; // BZJ 8 7
    uut2.mem[7] = 32'h0; // Data
    uut2.mem[8] = 32'hd; // Address
    uut2.mem[10] = 32'h5; // Data
    uut2.mem[13] = 32'h1002c00a; // ADDi 11 10
   end
endmodule
