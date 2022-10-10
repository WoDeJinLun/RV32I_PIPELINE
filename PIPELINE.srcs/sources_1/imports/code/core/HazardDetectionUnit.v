`timescale 1ps/1ps

module HazardDetectionUnit(
    input clk,
    input Branch_ID,rs1use_ID, rs2use_ID,RegWrite_EXE,RegWrite_MEM,RegWrite_WB,DatatoReg_EXE,DatatoReg_MEM,
    mem_w_EXE,mem_w_ID,
    input[2:0] hazard_optype_ID,
    input[4:0] rd_EXE,rd_MEM,rd_WB, rs1_ID, rs2_ID, rs1_EXE,
    output PC_EN_IF, reg_FD_EN, reg_FD_stall, reg_FD_flush,
        reg_DE_EN, reg_DE_flush, reg_EM_EN, reg_EM_flush, reg_MW_EN,
    output forward_ctrl_ls_1,forward_ctrl_ls_rd,
    output[1:0] forward_ctrl_A, forward_ctrl_B
);
            //according to the diagram, design the Hazard Detection Unit
    parameter r_type = 3'b000,i_type=3'b001,l_type = 3'b010,s_type =3'b011,b_type = 3'b100,j_type = 3'b101;
    parameter ex_data = 2'b01,mem_data = 2'b10,wb_data = 2'b11;
    wire fwd_exe_1= rs1_ID == rd_EXE & RegWrite_EXE & (|rs1_ID);
    wire fwd_exe_2= rs2_ID == rd_EXE & RegWrite_EXE & (|rs2_ID);
    wire fwd_mem_1= rs1_ID == rd_MEM & RegWrite_MEM & (|rs1_ID);
    wire fwd_mem_2= rs2_ID == rd_MEM & RegWrite_MEM & (|rs2_ID);
    wire fwd_wb_1= rs1_ID == rd_WB & RegWrite_WB & (|rs1_ID);
    wire fwd_wb_2= rs2_ID == rd_WB & RegWrite_WB & (|rs2_ID);
    assign forward_ctrl_A = (
        {2{fwd_exe_1}} & ex_data |
        {2{(~fwd_exe_1)&fwd_mem_1}} & mem_data |
        {2{(~fwd_exe_1)&(~fwd_mem_1)&fwd_wb_1}} & wb_data
    );
    assign forward_ctrl_B = (
        {2{fwd_exe_2}} & ex_data |
        {2{(~fwd_exe_2)&fwd_mem_2}} & mem_data |
        {2{(~fwd_exe_2)&(~fwd_mem_2)&fwd_wb_2}} & wb_data
    );
    assign forward_ctrl_ls_1  = (rs1_EXE == rd_MEM) & mem_w_EXE & DatatoReg_MEM; 
    assign forward_ctrl_ls_rd  = (rd_EXE == rd_MEM) & mem_w_EXE & DatatoReg_MEM;
    // nop and stall
    assign PC_EN_IF = ~(DatatoReg_EXE &(~mem_w_ID)& (rs1_ID == rd_EXE | rs2_ID == rd_EXE) & 
    (hazard_optype_ID == r_type | hazard_optype_ID == i_type | hazard_optype_ID == s_type));
    assign reg_FD_EN = 1'b1;
    assign reg_FD_stall = ~PC_EN_IF;
    assign reg_FD_flush = (Branch_ID | hazard_optype_ID == j_type) & PC_EN_IF;
    assign reg_DE_EN  = 1'b1;
    assign reg_DE_flush = ~PC_EN_IF;
    assign reg_EM_EN = 1'b1;
    assign reg_EM_flush = 1'b0;
    assign reg_MW_EN = 1'b1;

endmodule