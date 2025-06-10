module floating_point_mult (
    input [31:0] a, 
    input [31:0] b, 
    output reg [31:0] product, 
    output reg exception, 
    output reg overflow, 
    output reg underflow 
);

    wire fsign = a[31] ^ b[31];
    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];
    wire [23:0] manta = {1'b1, a[22:0]}; 
    wire [23:0] mantb = {1'b1, b[22:0]}; 

    wire [47:0] mantprod = manta * mantb;
    wire [8:0] exp_sum = exp_a + exp_b - 8'd127;
    wire [9:0] exp_check = exp_a + exp_b;

    reg [7:0] finexp;
    reg [22:0] finmant;


    always @(*) begin

        exception = 0;
        overflow = 0;
        underflow = 0;

        if ((exp_a == 8'hFF && a[22:0] != 0) || (exp_b == 8'hFF && b[22:0] != 0)) begin
            product = {fsign, 8'hFF, 23'h400000}; 
            exception = 1;
        end else if (exp_a == 8'hFF || exp_b == 8'hFF) begin
            // Infinity case
            product = {fsign, 8'hFF, 23'b0};
            exception = 1;
        end else if ((a[30:0] == 31'b0) || (b[30:0] == 31'b0)) begin
            product = {fsign, 8'b0, 23'b0};
            exception = 1; 
        end else if (exp_check < 8'd127) begin
                underflow = 1;
                exception = 1;
                product = {fsign, 8'b0, 23'b0}; 
        end else begin

            if (mantprod[47] == 1'b1) begin
                finmant = mantprod[46:24];
                finexp = exp_sum[7:0] + 1;
            end else begin
                finmant = mantprod[45:23];
                finexp = exp_sum[7:0];
            end
            if (exp_sum > 8'd254) begin
                overflow = 1;
                exception = 1;
                product = {fsign, 8'hFF, 23'b0};
            end 
            else if (exp_check < 8'd127) begin
                underflow = 1;
                exception = 1;
                product = {fsign, 8'b0, 23'b0}; 
            end 
            else begin
                product = {fsign, finexp, finmant};
            end
        end
    end

endmodule
