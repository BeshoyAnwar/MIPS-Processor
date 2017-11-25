
module Single_Cycle_MIPS_Proccessor

wire [31:0] PC_Input;
wire [31:0] PC_Output;
wire [31:0] Instruction;
wire RegDst,Jump, Branch, MemRead, MemtoReg, [0:1]ALUOp, MemWrite, ALUSrc, RegWrite;
wire [4:0]write_register;
wire [31:0] write_data , [31:0] read_data_1 , [31:0] read_data_2;
wire [3:0] ALUcontrol_signal;
wire [27:0] jumpaddress;
wire [31:0] Branch_extended_address , [31:0] ALU_second_operand ;
wire ALU_Zero_flag , overflow ,[31:0] ALU_Result ;
wire [31:0] WriteData ; 
wire[31:0] Data_Memory_readData ;
wire[31:0] Branch_Shifted_address , [31:0] Branch_target ;
wire Branch_control_Signal;
wire [31:0]PC_target_fetched_branch;

PC single_cycle_PC ( PC_Input , PC_Output );
insMemory single_cycle_Instruction_Memory ( PC_Output , Instruction ); 
adder PC_adder ( PC_Output , 4 , Fetched_PC );
Control single_cycle_Control_unit ([0:5]Instruction, RegDst, Jump , Branch , MemRead ,MemtoReg , ALUOp , MemWrite , ALUSrc , RegWrite );
mux Wirte_Register_Mux (RegDst , [20:16] Instruction , [15:11] Instruction , RegWrite);
ShiftLeftJump Shift_Left_Jump_address([25:0] Instruction , [27:0] jumpaddress);
registerFile single_cycle_MIPS_registers (RegWrite, RegWrite, WriteData,[25:21]Instruction , read_data_1, [20:16]Instruction, read_data_2, clk); //we dont have clk
signextend1632 sign_extend_unit ([15:0] Instruction, Branch_extended_address); 
mux ALU_Mux ( ALUSrc , read_data_2 , Branch_extended_address , ALU_second_operand); 
ALUcontrol single_cycle_ALUcontrol([5:0]Instruction, ALUop ,ALUcontrol_signal);
alu single_cycle_MIPS_ALU ( read_data_1 , ALU_second_operand , ALUcontrol_signal ,ALU_Result, overflow ,  ALU_Zero_flag );
dataMemory Single_cycle_MIPS_DataMemory(MemWrite,[4:0] ALU_Result,read_data_2 , MemRead ,[4:0] ALU_Result , Data_Memory_readData, clk);
mux Write_Data_Mux_single_cycle_MIPS (MemtoReg, ALU_Result, Data_Memory_readData , WriteData);
ShiftLeftBranch Shift_Left_Branch_address(Branch_extended_address ,Branch_Shifted_address);
adder Branch_adder (Fetched_PC , Branch_Shifted_address , Branch_target );
and Branch_selector ( output(Branch_control_Signal) , input( Branch ) , input( ALU_Zero_flag) );
mux Branch_address_Mux (Branch_control_Signal , Fetched_PC , Branch_target , PC_target_fetched_branch );
muc Jump_address_mux (Jump , PC_target_fetched_branch , {[31:28]Fetched_PC,jumpaddress} , PC_Input );
end module
