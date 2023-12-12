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
reg signed [15:0] ac = 0;
reg signed [15:0] bd = 0;
reg signed [15:0] ad = 0;
reg signed [15:0] bc = 0;
reg signed [15:0] res = 0;
reg signed [15:0] img = 0;
reg [2:0] state = 0;

reg signed [15:0] mult1 = 0;
reg signed [15:0] mult2 = 0;
reg signed [15:0] temp = 0;

always @(posedge clk) 
begin

mult1 <= state == 1 ? a_real_reg : 
    state == 2 ? a_imag_reg : 
    state == 3 ? a_real_reg :
    state == 4 ? a_imag_reg : 0;

mult2 <= state == 1 ? b_imag_reg : 
    state == 2 ? b_imag_reg : 
    state == 3 ? b_real_reg :
    state == 4 ? b_imag_reg : 0;

temp <= mult1 * mult2;  
end

always @(posedge clk) 
begin
    state <= 0;
    if(data_valid) 
    begin
        a_real_reg <= a_real;
        a_imag_reg <= a_imag;
        b_real_reg <= b_real;
        b_imag_reg <= b_imag;
        
        state <= 1;
    if(state != 0) 
        begin
            case (state)
                1: begin 
                    ac <= temp; 
                    state <= 2; 
                    end
                2: begin 
                    bd <= temp; 
                    state <= 3; 
                    end
                3: begin 
                    ad <= temp; 
                    state <= 4; 
                    end
                4: begin 
                    bc <= temp; 
                    state <= 5; 
                    end
                5: begin
                    res <= ac - bd;
                    img <= ad + bc;
                    state <= 0;
                    end
            endcase
        end
    end
end

assign z_real = res;
assign z_imag = img;
endmodule
