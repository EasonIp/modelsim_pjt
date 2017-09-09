`timescale 1ns/1ps
module tb_counter (); /* this is automatically generated */

    reg rst_n;
    reg clk;
    wire [7:0] cnt;
    counter inst_counter (
        .clk(clk),
        .rst_n(rst_n),
        .cnt(cnt)
        );
    // clock  50MHz
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    // reset
    initial
    begin
        rst_n = 1'b0;
        #200   //#200.1 之后  右侧逼近   修改tb后在modelsim中重编译tb就可以
        rst_n = 1'b1;
        #6000   //至少20*256
        $stop;
    end
endmodule

