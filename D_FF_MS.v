module D_latch(input d, input en, input rstn, output reg q);

    always @(d, en, negedge rstn)begin
        if(rstn == 0)begin 
            q <= 0;
        end else if(en == 1)begin
            q <= d;
        end
    end

endmodule

module D_FF_MS(input D, input CLK, input RESET, output Q);

wire q1, q2;
wire nCLK;
wire nreset; 
not (nreset, RESET);
not(nCLK, CLK);
D_latch d1(D, CLK, nreset, q1);
D_latch d2(q1, nCLK, nreset, Q);

endmodule