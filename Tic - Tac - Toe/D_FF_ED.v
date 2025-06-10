module D_latch(input d, input en, input rstn, output reg q);

    always @(d, en, negedge rstn)begin
        if(rstn == 0)begin 
            q <= 0;
        end else if(en == 1)begin
            q <= d;
        end
    end

endmodule

module E_Det(input E, output O);

wire nE;
not(nE, E);
and(O, E, nE);

endmodule

module D_FF_ED(input D, input CLK, input RESET, output Q);

wire cl;
wire nreset;
not(nreset, RESET);
E_Det E1(CLK, cl);
D_latch d1(D, cl, nreset, Q);

endmodule