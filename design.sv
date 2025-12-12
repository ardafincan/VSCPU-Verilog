module VSCPU (clk, rst, data_fromRAM, wrEn, addr_toRAM, data_toRAM);
input clk, rst;
output reg wrEn;
input [31:0] data_fromRAM;
output reg [31:0] data_toRAM;
output reg [13:0] addr_toRAM;
reg [2:0] st, stN;
reg [13:0] PC, PCN;
reg [31:0] IW, IWN;
reg [31:0] R1, R1N;
always @(posedge clk) begin
    st <= stN;
    PC <= PCN;
    IW <= IWN;
    R1 <= R1N;
end
always @ * begin
    if (rst) begin
    stN = 3'd0;
    PCN = 14'd0;
    end
    else begin
        wrEn = 1'b0;
        PCN = PC;
        IWN = IW;
        stN = 3'dx;
        addr_toRAM= 14'hX;
        data_toRAM= 32'hX;
        R1N= 32'hX;
        case (st)
            3'd0: begin // S0: Fetch State
                addr_toRAM = PC;
                stN = 3'd1;
            end
            3'd1: begin // S1: Decode State
                IWN = data_fromRAM;
                if(data_fromRAM[31:28] == 4'b0001)//ADDi
                begin
                addr_toRAM = data_fromRAM[27:14];
                stN = 3'd2;
                end
                if(data_fromRAM[31:28] == 4'b1000) // CP
                begin
                addr_toRAM = data_fromRAM[13:0];
                stN = 3'd2;
                end
                end
            3'd2: begin // S2: Decode/Execute State
                if (IW[31:28]==4'b0001) begin // ADDi
                    wrEn = 1'b1;
                    addr_toRAM = IW[27:14];
                    data_toRAM = data_fromRAM + IW[13:0];
                    PCN = PC + 14'd1;
                    stN = 3'd0;
                    end
                    if (IW[31:28]==4'b1000) begin // CP
                    wrEn = 1'b1;
                    addr_toRAM = IW[27:14];
                    data_toRAM = data_fromRAM;
                    PCN = PC + 14'd1;
                    stN = 3'd0;
                    end

            	end

endcase
end // else
end // always
endmodule


module blram(clk, rst, we, addr, din, dout);
  parameter SIZE = 14, DEPTH = 2**SIZE;
  input clk;
  input rst;
  input we;
  input [SIZE-1:0] addr;
  input [31:0] din;
  output reg [31:0] dout;
  reg [31:0] mem [DEPTH-1:0];
  always @(posedge clk) begin
  dout <= #1 mem[addr[SIZE-1:0]];
  if (we)
  mem[addr[SIZE-1:0]] <= #1 din;
  end
endmodule
