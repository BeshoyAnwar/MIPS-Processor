module executionStage (input [135:0]IDEXReg, output [74:0]ExMemReg);
	
	wire [31:0]instruction=IDEXReg[31:0];
	wire signed [31:0]readData1=IDEXReg[63:32];
 	wire signed [31:0]readData2=IDEXReg[95:64]; 
	wire signed [31:0]immediateExtendedField=IDEXReg[127:96];	
	wire [7:0]controlSignals=IDEXReg[135:128];
	
	wire [4:0]shiftAmt=instruction[10:6];
	wire [4:0]rd=instruction[15:11];
	wire [4:0]rt=instruction[20:16];
	wire [4:0]rs=instruction[25:21];
	
	wire RegWrite=controlSignals[0];
	wire ALUSrc=controlSignals[1];
	wire MemRead=controlSignals[2];
	wire [1:0]ALUOp=controlSignals[4:3];
	wire MemToReg=controlSignals[5];
	wire MemWrite=controlSignals[6];
	wire RegDst=controlSignals[7];
	
	wire [3:0]ALUcontrolSignal;
	wire signed [31:0]ALUSecondOperand ;
	wire [4:0]writeRegister;
	wire signed [31:0]ALUResult;
	wire overflowFlag;
	wire ALUZeroflag;
	
	mux ALUMux ( ALUSrc , readData2 , immediateExtendedField , ALUSecondOperand); 
	ALUcontrol alucontrol(instruction[5:0], ALUOp ,ALUcontrolSignal);
	alu single_cycle_MIPS_ALU ( readData1 , ALUSecondOperand , ALUcontrolSignal, instruction[10:6] ,ALUResult, overflowFlag ,  ALUZeroflag );
	mux WriteRegisterMux (RegDst , instruction[20:16] , instruction[15:11] , writeRegister);
	assign ExMemReg={RegWrite,MemWrite,MemToReg,MemRead,overflowFlag,ALUZeroflag,writeRegister,readData2,ALUResult};
	//assign readData1 = (writeRegister==rs && writeRegister!=0) ? ALUResult : rs;
	//assign readData2 = (writeRegister==rt && writeRegister!=0) ? ALUResult : rt;

endmodule

module executionTest();
reg [135:0]IDEXReg;wire [74:0]ExMemReg;
initial
begin
$monitor("result=%d data2=%d writeReg=%d zeroFlag=%d OVRFFlag=%d MemRead=%d MemToReg=%d MemWrite=%d RegWrite=%d",ExMemReg[31:0],ExMemReg[63:32],ExMemReg[68:64],ExMemReg[69],ExMemReg[70],ExMemReg[71],ExMemReg[72],ExMemReg[73],ExMemReg[74]);
#10
IDEXReg[31:0]=32'h02518820;//instruction add $s1,$s2,$s1
IDEXReg[63:32]=5;//data1
IDEXReg[95:64]=5;//data2
IDEXReg[127:96]=10;//immediate extended
IDEXReg[135:128]=8'b10010001;//control for R-format
#10
IDEXReg[31:0]=32'h02518822;//instruction sub $s1,$s2,$s1
IDEXReg[63:32]=7;//data1
IDEXReg[95:64]=5;//data2
IDEXReg[127:96]=10;//immediate extended
IDEXReg[135:128]=8'b10010001;//control for R-format
end





executionStage stage1 (IDEXReg,ExMemReg);
endmodule
