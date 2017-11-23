
module Single_Cycle_MIPS_Proccessor

wire [31:0] PC_Input;
wire [31:0] PC_Output;
wire [31:0] Instruction;
wire RegDst, Branch, MemRead, MemtoReg, [0:1]ALUOp, MemWrite, ALUSrc, RegWrite;
wire [4:0]write_register;
wire [31:0] write_data , [31:0] read_data_1 , [31:0] read_data_2;
wire [3:0] ALUcontrol_signal;
wire [27:0] jumpaddress;
wire [31:0] Branch_extended_address , [31:0] ALU_second_operand ;
wire ALU_Zero_flag ,[31:0] ALU_Result

PC single_cycle_PC ( PC_Input , PC_Output );
Instruction_Memory single_cycle_Instruction_Memory ( PC_Output , Instruction ); 
Add PC_adder (Fetched_PC , PC_Output , 4 );
Control single_cycle_Control_unit([0:5]Instruction, RegDst, Branch, MemRead, MemtoReg,ALUOp, MemWrite, ALUSrc, RegWrite);
Mux Wirte_Register_Mux ([20:16] Instruction , [15:11] Instruction , RegDst , write_register);
ShiftLeftJump Shift_Left_Jump_address([25:0] Instruction , [27:0] jumpaddress);
//Registers single_cycle_MIPS_registers (
Sign-extended sign_extend_unit ([15:0] Instruction, Branch_extended_address); 
Mux ALU_Mux ( read_data_2 , Branch_extended_address , ALUSrc , ALU_second_operand); 
ALUcontrol single_cycle_ALUcontrol([5:0]Instruction, ALUop,ALUcontrol_signal);
ALU single_cycle_MIPS_ALU ( read_data_1 , ALU_second_operand , ALUcontrol_signal , ALU_Zero_flag , ALU_Result);

end module
