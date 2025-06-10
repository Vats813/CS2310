module FloatingPointAddition (
    input [31:0] a_operand, 
    input [31:0] b_operand, 
    output Exception,       
    output [31:0] result    
);

    reg signa, signb, signres;
    reg [7:0] expa, expb, expres;
    reg [23:0] manta, mantb;  
    reg [24:0] mantres;     
    reg [8:0] exp_diff;         
    reg excep;          
    wire carry; 

    assign result = {signres, expres, mantres[22:0]};
    assign Exception = excep;
    assign carry = mantres[24];
    always @(*) begin
        signa = a_operand[31];
        expa = a_operand[30:23];
        manta = {1'b1, a_operand[22:0]};  

        signb = b_operand[31];
        expb = b_operand[30:23];
        mantb = {1'b1, b_operand[22:0]}; 

        excep = 1'b0;

        if (expa > expb) begin
            exp_diff = expa - expb;
            mantb = mantb >> exp_diff;
            expres = expa;
        end else begin
            exp_diff = expb - expa;
            manta = manta >> exp_diff;
            expres = expb;
        end

        if (signa == signb) begin
            mantres = manta + mantb;
            signres = signa;
        end else begin
            if (manta > mantb) begin
                mantres = manta - mantb;
                signres = signa;
            end else begin
                mantres = mantb - manta;
                signres = signb;
            end
        end

        if (mantres[24]) begin
            mantres = mantres >> 1;
            expres = expres + 1;
        end else begin
            while (!mantres[23] && expres > 0) begin
                mantres = mantres << 1;
                expres = expres - 1;
            end
        end

        if (expres == 8'hFF) begin
            excep = 1'b1; 
        end
    end
endmodule

