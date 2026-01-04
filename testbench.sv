module tb_VSCPU;
  parameter SIZE = 14, DEPTH = 2**SIZE;
  reg clk, rst;
  wire wrEn;
  wire [SIZE-1:0] addr_toRAM;
  wire [31:0] data_toRAM, data_fromRAM;

  reg [2:0] prev_st;
  reg [13:0]cpu_PC;  
  reg [31:0] cur_IW; 
  reg ins_start;      
  reg [63:0] in_name; 

  VSCPU uut1 (clk, rst, data_fromRAM, wrEn, addr_toRAM, data_toRAM);
  blram #(SIZE, DEPTH) uut2 (clk, rst, wrEn, addr_toRAM, data_toRAM, data_fromRAM);

  initial begin
    clk = 1;
    forever
    #5 clk = ~clk;
  end

  initial begin
    rst = 1;
    prev_st = 3'd0;
    cpu_PC = 14'd0;
    cur_IW = 32'd0;
    ins_start = 0;
    in_name = "        ";
    repeat (10) @(posedge clk);
    rst <= #1 0;
    repeat (500) @(posedge clk);  
	$display("* * * * * * * * * * * * * * * * * * * * * * * * *");
    $display("Simulation completed");
    $display("* * * * * * * * * * * * * * * * * * * * * * * * *");
    $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

  initial begin
    uut2.mem[0]  = {4'd9,  14'd110, 14'd3};   // CPi 110 3
    uut2.mem[1]  = {4'd0,  14'd100, 14'd101}; // ADD 100 101
    uut2.mem[2]  = {4'd14, 14'd100, 14'd102}; // MUL 100 102
    uut2.mem[3]  = {4'd5,  14'd102, 14'd1};   // SRLi 102 1
    uut2.mem[4]  = {4'd8,  14'd104, 14'd100}; // CP 104 100
    uut2.mem[5]  = {4'd1,  14'd104, 14'd5};   // ADDi 104 5
    uut2.mem[6]  = {4'd2,  14'd104, 14'd108}; // NAND 104 108
    uut2.mem[7]  = {4'd3,  14'd104, 14'd5};   // NANDi 104 5
    uut2.mem[8]  = {4'd4,  14'd108, 14'd102}; // SRL 108 102
    uut2.mem[9]  = {4'd15, 14'd108, 14'd3};   // MULi 108 3
    uut2.mem[10] = {4'd0,  14'd110, 14'd103}; // ADD 110 103
    uut2.mem[11] = {4'd8,  14'd112, 14'd110}; // CP 112 110
    uut2.mem[12] = {4'd6,  14'd112, 14'd111}; // LT 112 111
    uut2.mem[13] = {4'd12, 14'd111, 14'd112}; // BZJ 111 112
    uut2.mem[14] = {4'd13, 14'd101, 14'd11};  // BZJi 101 11

    uut2.mem[19] = {4'd15, 14'd101, 14'd3};   // MULi 101 3
    uut2.mem[20] = {4'd8,  14'd105, 14'd102}; // CP 105 102
    uut2.mem[21] = {4'd7,  14'd105, 14'd2};   // LTi 105 2
    uut2.mem[22] = {4'd12, 14'd113, 14'd105}; // BZJ 113 105

    uut2.mem[35] = {4'd13, 14'd111, 14'd53};  // BZJi 111 53

    uut2.mem[54] = {4'd11, 14'd114, 14'd111}; // CPIi 114 111
    uut2.mem[55] = {4'd10, 14'd121, 14'd102}; // CPI 121 102

    uut2.mem[100] = 32'd5;
    uut2.mem[101] = 32'd8;
    uut2.mem[102] = 32'd16;
    uut2.mem[103] = 32'd4294967295;  
    uut2.mem[108] = 32'd65543;    
	uut2.mem[111] = 32'd1;
    uut2.mem[113] = 32'd35;
    uut2.mem[114] = 32'd120;
  end

  always @(posedge clk) begin
    if (rst) begin
      prev_st <= 3'd0;
      ins_start <= 0;
    end else begin
      prev_st <= uut1.st;
      if (uut1.st == 3'd0) begin
        cpu_PC <= uut1.PC;
      end
      if (prev_st == 3'd0 && uut1.st == 3'd1) begin
        cur_IW <= data_fromRAM;
        ins_start <= 1;
      end
    end
  end

  // Save instruction names according to op code
  always @(*) begin
    case (cur_IW[31:28])
      4'b0000: in_name = cur_IW[13] ? "SUB     " : "ADD     ";
      4'b0001: in_name = cur_IW[13] ? "SUBi    " : "ADDi    ";
      4'b0010: in_name = "NAND    ";
      4'b0011: in_name = "NANDi   ";
      4'b0100: in_name = "SRL     ";
      4'b0101: in_name = "SRLi    ";
      4'b0110: in_name = "LT      ";
      4'b0111: in_name = "LTi     ";
      4'b1000: in_name = "CP      ";
      4'b1001: in_name = "CPi     ";
      4'b1010: in_name = "CPI     ";
      4'b1011: in_name = "CPIi    ";
      4'b1100: in_name = "BZJ     ";
      4'b1101: in_name = "BZJi    ";
      4'b1110: in_name = "MUL     ";
      4'b1111: in_name = "MULi    ";
      default: in_name = "UNKNOWN ";
    endcase
  end

  // Print after intruction ended
  always @(posedge clk) begin
    if (!rst && ins_start && prev_st != 3'd0 && uut1.st == 3'd0) begin
      $display("* * * * * * * * * * * * * * * * * * * * * * * * *");
      $display("    current_instruction:  %s %0d %0d",
               in_name,
               cur_IW[27:14],
               cur_IW[13:0]);
      $display("    program counter    :  %0d", cpu_PC);

      case (cur_IW[31:28])
        4'b0000, 4'b0001: begin // ADDi / SUBi
          $display("    mem[ %0d ] = %0d", cur_IW[27:14], uut2.mem[cur_IW[27:14]]);
          if (cur_IW[31:28] == 4'b0000) // ADD / SUB
            $display("    mem[ %0d ] = %0d", cur_IW[13:0], uut2.mem[cur_IW[13:0]]);
        end
        4'b0010, 4'b0011: begin // NAND / NANDi
          $display("    mem[ %0d ] = %0d", cur_IW[27:14], uut2.mem[cur_IW[27:14]]);
          if (cur_IW[31:28] == 4'b0010)
            $display("    mem[ %0d ] = %0d", cur_IW[13:0], uut2.mem[cur_IW[13:0]]);
        end
        4'b0100, 4'b0101: begin // SRL / SRLi
          $display("    mem[ %0d ] = %0d", cur_IW[27:14], uut2.mem[cur_IW[27:14]]);
          if (cur_IW[31:28] == 4'b0100)
            $display("    mem[ %0d ] = %0d", cur_IW[13:0], uut2.mem[cur_IW[13:0]]);
        end
        4'b0110, 4'b0111: begin // LT / LTi
          $display("    mem[ %0d ] = %0d", cur_IW[27:14], uut2.mem[cur_IW[27:14]]);
          if (cur_IW[31:28] == 4'b0110)
            $display("    mem[ %0d ] = %0d", cur_IW[13:0], uut2.mem[cur_IW[13:0]]);
        end
        4'b1000, 4'b1001: begin // CP / CPi
          $display("    mem[ %0d ] = %0d", cur_IW[27:14], uut2.mem[cur_IW[27:14]]);
          if (cur_IW[31:28] == 4'b1000)
            $display("    mem[ %0d ] = %0d", cur_IW[13:0], uut2.mem[cur_IW[13:0]]);
        end
        4'b1010, 4'b1011: begin // CPI / CPIi
          $display("    mem[ %0d ] = %0d", cur_IW[27:14], uut2.mem[cur_IW[27:14]]);
          $display("    mem[ %0d ] = %0d", cur_IW[13:0], uut2.mem[cur_IW[13:0]]);
        end
        4'b1100, 4'b1101: begin // BZJ / BZJi
          $display("    mem[ %0d ] = %0d", cur_IW[27:14], uut2.mem[cur_IW[27:14]]);
          $display("    mem[ %0d ] = %0d", cur_IW[13:0], uut2.mem[cur_IW[13:0]]);
        end
        4'b1110, 4'b1111: begin // MUL / MULi
          $display("    mem[ %0d ] = %0d", cur_IW[27:14], uut2.mem[cur_IW[27:14]]);
          if (cur_IW[31:28] == 4'b1110)
            $display("    mem[ %0d ] = %0d", cur_IW[13:0], uut2.mem[cur_IW[13:0]]);
        end
      endcase
      $display("* * * * * * * * * * * * * * * * * * * * * * * * *");
    end
  end

endmodule
