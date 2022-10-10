`timescale 1ns / 1ps

module core_sim;
    reg clk, rst;
//   wire  reg_FD_EN,reg_FD_stall,reg_FD_flush, reg_DE_EN, reg_DE_flush;
    RV32core core(
        .debug_en(1'b0),
        .debug_step(1'b0),
        .debug_addr(7'b0),
        .debug_data(),
        .clk(clk),
        .rst(rst),
        .interrupter(1'b0)
//       .reg_FD_EN(reg_FD_EN),.reg_FD_stall(reg_FD_stall),.reg_FD_flush(reg_FD_flush),
//        .reg_DE_EN(reg_DE_EN), .reg_DE_flush(reg_DE_flush)
    );

    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0;
    end
    always #1 clk = ~clk;

endmodule