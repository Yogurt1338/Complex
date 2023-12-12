`timescale 1ns / 1ns

module complex_tb();

reg clk = 0;
reg signed [7:0] a_real = 0;
reg signed [7:0] a_imag = 0;
reg signed [7:0] b_real = 0;
reg signed [7:0] b_imag = 0;
reg signed [1:0] data_valid = 0; 
wire signed [15:0] z_real;
wire signed [15:0] z_imag;

initial
    forever #5 clk = ~clk;

initial
begin

    a_real <= 8'sd1; 
    a_imag <= 8'sd2;
    b_real <= 8'sd3;
    b_imag <= 8'sd4;
    data_valid <= 2'b01; 

    #10;
    data_valid <= 2'b00; 
    a_real <= 8'sd00; 
    a_imag <= 8'sd00;
    b_real <= 8'sd00;
    b_imag <= 8'sd00;
    
    
    #20;
    a_real <= 8'sd02; 
    a_imag <= 8'sd04;
    b_real <= 8'sd06;
    b_imag <= 8'sd08;
    data_valid <= 2'b01; 

    #10;
    data_valid <= 2'b00; 
    a_real <= 8'sd00; 
    a_imag <= 8'sd00;
    b_real <= 8'sd00;
    b_imag <= 8'sd00;

    #20;
    a_real <= 8'sd01; 
    a_imag <= 8'sd03;
    b_real <= 8'sd05;
    b_imag <= 8'sd07;
    data_valid <= 2'b01; 

    #10;
    data_valid <= 2'b00; 
    a_real <= 8'sd00; 
    a_imag <= 8'sd00;
    b_real <= 8'sd00;
    b_imag <= 8'sd00;

    #20;
    a_real <= 8'sd01; 
    a_imag <= 8'sd02;
    b_real <= 8'sd01;
    b_imag <= 8'sd02;
    data_valid <= 2'b01; 

    #10;
    data_valid <= 2'b00; 
    a_real <= 8'sd00; 
    a_imag <= 8'sd00;
    b_real <= 8'sd00;
    b_imag <= 8'sd00;

    #200;

    $finish;
end

complex dut (
    .clk(clk), 
    .a_real(a_real), 
    .a_imag(a_imag), 
    .b_real(b_real), 
    .b_imag(b_imag), 
    .data_valid(data_valid), 
    .z_real(z_real), 
    .z_imag(z_imag)
);

initial
begin
    $dumpfile("test.vsd");
    $dumpvars;
end

endmodule
