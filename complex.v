module complex(
    input clk,
    input signed [7:0] a_real,
    input signed [7:0] a_imag,
    input signed [7:0] b_real,
    input signed [7:0] b_imag,
    input signed [1:0] data_valid, 
    output signed [15:0] z_real,
    output signed [15:0] z_imag
);

reg signed [7:0] a_real_reg = 0;
reg signed [7:0] a_imag_reg = 0;
reg signed [7:0] b_real_reg = 0;
reg signed [7:0] b_imag_reg = 0;

reg signed [15:0] k1 = 0;
reg signed [15:0] k2 = 0;
reg signed [15:0] k3 = 0;

reg signed [15:0] res = 0;
reg signed [15:0] img = 0;
reg [2:0] state = 0;

reg signed [15:0] mult1 = 0;
reg signed [15:0] mult2 = 0;
reg signed [15:0] temp = 0;

always @(posedge clk) 
begin

mult1 <= state == 1 ? a_real_reg : 
    state == 2 ? b_imag_reg : 
    state == 3 ? a_imag_reg : 0;

mult2 <= state == 1 ? (a_imag_reg + b_imag_reg) : 
    state == 2 ? (a_real_reg + b_real_reg) : 
    state == 3 ? (b_real_reg - a_real_reg) : 0;

temp <= mult1 * mult2;  
end

always @(posedge clk) 
begin

    if(data_valid) 
    begin
        a_real_reg <= a_real;
        a_imag_reg <= a_imag;
        b_real_reg <= b_real;
        b_imag_reg <= b_imag;
        state <= 1;
    end
    begin
        case (state)
            1: begin 
                k2 <= temp; 
                state <= 2; 
                end
            2: begin 
                k3 <= temp; 
                state <= 3; 
                end
            3: begin 
                k1 <= temp; 
                res <= k1 - k2;
                img <= k1 + k3;
                end
            default: 
            ;
        endcase
    end
end

assign z_real = res;
assign z_imag = img;
endmodule
