`include "TCell.v"
module dec(input [1:0] row, input [1:0] col, input reg [1:0] game_state, output reg [8:0] set);
    reg [3:0] num;
    always @(*) begin
        case ({row, col})
            4'b01_01: num = 4'd1;  
            4'b01_10: num = 4'd2;  
            4'b01_11: num = 4'd3;  
            4'b10_01: num = 4'd4;  
            4'b10_10: num = 4'd5;  
            4'b10_11: num = 4'd6;  
            4'b11_01: num = 4'd7;  
            4'b11_10: num = 4'd8;  
            4'b11_11: num = 4'd9;  
            default: num = 4'd0;   
        endcase
        set = 9'b000000000;  
        if (num >= 1 && num <= 9) 
            set[num - 1] = 1'b1;  
        if(game_state[0]!=0 || game_state[1]!=0)
            set = 9'b000000000;
    end
endmodule

module TBox(input clk, set, reset, input [1:0] row, col, output reg [8:0] valid, symbol, output reg [1:0] game_state);
    integer j;
    initial begin
        game_state[0]=0;
        game_state[1]=0;
    end
    reg [8:0] set1;
    reg turn;
    assign turn = 1 ^ valid[0] ^ valid[1] ^ valid[2] ^ valid[3] ^ valid[4] ^ valid[5] ^ valid[6] ^ valid[7] ^ valid[8];
    dec d1(row, col, game_state, set1);
    integer i;
    always @(posedge clk)begin
        if(game_state[0]==0 && game_state[1]==0)begin
            if((symbol[0]==symbol[1] && symbol[1]==symbol[2] && symbol[0]==1 && valid[0]==1 && valid[1]==1 && valid[2]==1) || 
                (symbol[3]==symbol[4] && symbol[4]==symbol[5] && symbol[3]==1 && valid[3]==1 && valid[4]==1 && valid[5]==1) || 
                (symbol[6]==symbol[7] && symbol[7]==symbol[8] && symbol[6]==1 && valid[6]==1 && valid[7]==1 && valid[8]==1) || 
                (symbol[0]==symbol[3] && symbol[3]==symbol[6] && symbol[0]==1 && valid[0]==1 && valid[3]==1 && valid[6]==1) || 
                (symbol[1]==symbol[4] && symbol[4]==symbol[7] && symbol[1]==1 && valid[1]==1 && valid[4]==1 && valid[7]==1) || 
                (symbol[2]==symbol[5] && symbol[5]==symbol[8] && symbol[2]==1 && valid[2]==1 && valid[5]==1 && valid[8]==1) || 
                (symbol[0]==symbol[4] && symbol[4]==symbol[8] && symbol[0]==1 && valid[0]==1 && valid[4]==1 && valid[8]==1) || 
                (symbol[2]==symbol[4] && symbol[4]==symbol[6] && symbol[2]==1 && valid[2]==1 && valid[4]==1 && valid[6]==1))begin
                game_state[0]=1;
                game_state[1]=0;
            end else if((symbol[0]==symbol[1] && symbol[1]==symbol[2] && symbol[0]==0 && valid[0]==1 && valid[1]==1 && valid[2]==1) || 
                (symbol[3]==symbol[4] && symbol[4]==symbol[5] && symbol[3]==0 && valid[3]==1 && valid[4]==1 && valid[5]==1) || 
                (symbol[6]==symbol[7] && symbol[7]==symbol[8] && symbol[6]==0 && valid[6]==1 && valid[7]==1 && valid[8]==1) || 
                (symbol[0]==symbol[3] && symbol[3]==symbol[6] && symbol[0]==0 && valid[0]==1 && valid[3]==1 && valid[6]==1) || 
                (symbol[1]==symbol[4] && symbol[4]==symbol[7] && symbol[1]==0 && valid[1]==1 && valid[4]==1 && valid[7]==1) || 
                (symbol[2]==symbol[5] && symbol[5]==symbol[8] && symbol[2]==0 && valid[2]==1 && valid[5]==1 && valid[8]==1) || 
                (symbol[0]==symbol[4] && symbol[4]==symbol[8] && symbol[0]==0 && valid[0]==1 && valid[4]==1 && valid[8]==1) || 
                (symbol[2]==symbol[4] && symbol[4]==symbol[6] && symbol[2]==0 && valid[2]==1 && valid[4]==1 && valid[6]==1))begin
                game_state[0]=0;
                game_state[1]=1;
            end
            if(valid[0]==1 && valid[1]==1 && valid[2]==1 && valid[3]==1 && valid[4]==1 && valid[5]==1 && valid[6]==1 && valid[7]==1 && valid[8]==1 && game_state[0]==0 && game_state[1]==0)begin
                game_state[0]=1;
                game_state[1]=1;
            end
        end else if(reset==1) begin
            game_state[0]=0;
            game_state[1]=0;
        end
    end
    TCell t1(clk, set1[0], reset, turn, valid[0], symbol[0]);
    TCell t2(clk, set1[1], reset, turn, valid[1], symbol[1]);
    TCell t3(clk, set1[2], reset, turn, valid[2], symbol[2]);
    TCell t4(clk, set1[3], reset, turn, valid[3], symbol[3]);
    TCell t5(clk, set1[4], reset, turn, valid[4], symbol[4]);
    TCell t6(clk, set1[5], reset, turn, valid[5], symbol[5]);
    TCell t7(clk, set1[6], reset, turn, valid[6], symbol[6]);
    TCell t8(clk, set1[7], reset, turn, valid[7], symbol[7]);
    TCell t9(clk, set1[8], reset, turn, valid[8], symbol[8]);
endmodule
