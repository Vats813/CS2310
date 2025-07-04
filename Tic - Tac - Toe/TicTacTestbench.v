`include "TBox.v"

`define PRINTCELL(index) \
    if (valid[index] == 0) $write ("_ ");                               \
    else if (valid[index] == 1 && symbol[index] == 1) $write ("X ");    \
    else if (valid[index] == 1 && symbol[index] == 0) $write ("O ");    \

`define PRINTBOARD                                                      \
    $write("Board State: ");                                            \
    if (game_state == 2'b00) $display("Game on");                       \
    else if (game_state == 2'b01) $display ("X won");                   \
    else if (game_state == 2'b10) $display ("O won");                   \
    else if (game_state == 2'b11) $display ("Draw");                    \
    `PRINTCELL(0) `PRINTCELL(1) `PRINTCELL(2) $display("");             \
    `PRINTCELL(3) `PRINTCELL(4) `PRINTCELL(5) $display("");             \
    `PRINTCELL(6) `PRINTCELL(7) `PRINTCELL(8) $display("");             \
    $display("-------------");

`define PLAYMOVE(r, c)                                                  \
    reset <= 0; set <= 1; row <= r; col <= c; #20; set <= 0;            \
    `PRINTBOARD

`define RESETBOARD                                                      \
    reset <= 1; set <= 0; #40; reset <= 0;                              \
    `PRINTBOARD

module TBox_tb;
    wire [8:0] valid;
    wire [8:0] symbol;
    wire [1:0] game_state;
    reg [1:0] row, col;
    reg clk, set, reset;
    TBox tbox(clk, set, reset, row, col, valid, symbol, game_state);

    initial begin
        clk <= 0;
        #2

        if (|valid) $display("Testcase failed: Board is not empty initially");
        else if (game_state != 2'b00) $display("Testcase failed: Incorrect initial game state");
        else $display("Testcase 0 passed");
        // Game where O wins
        `PLAYMOVE(01,01)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(10,10)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(01,11)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(01,10)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(11,11)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(11,10)
        if (game_state != 2'b10) $display("Testcase failed: Incorrect game state change");
        else $display("Testcase 1 passed");

        // Game where X wins
        `RESETBOARD
        `PLAYMOVE(01,01)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(10,10)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(01,11)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(11,10)
        if (game_state != 2'b00) $display("Testcase failed: Incorrect game state change");
        `PLAYMOVE(01,10)
        if (game_state != 2'b01) $display("Testcase failed: Incorrect game state change");
        else $display("Testcase 2 passed");

        // Winning Scenarios for X
        // Top Row Win
        `RESETBOARD
        `PLAYMOVE(2'b01, 2'b01) `PLAYMOVE(2'b10, 2'b10) `PLAYMOVE(2'b01, 2'b10) `PLAYMOVE(2'b11, 2'b11) `PLAYMOVE(2'b01, 2'b11)
        if (game_state != 2'b01) $display("Testcase failed: X Top Row win"); else $display("Testcase 3 passed");

        // Middle Row Win
        `RESETBOARD
        `PLAYMOVE(2'b10, 2'b01) `PLAYMOVE(2'b01, 2'b01) `PLAYMOVE(2'b10, 2'b10) `PLAYMOVE(2'b01, 2'b10) `PLAYMOVE(2'b10, 2'b11)
        if (game_state != 2'b01) $display("Testcase failed: X Middle Row win"); else $display("Testcase 4 passed");

        // Bottom Row Win
        `RESETBOARD
        `PLAYMOVE(2'b11, 2'b01) `PLAYMOVE(2'b01, 2'b01) `PLAYMOVE(2'b11, 2'b10) `PLAYMOVE(2'b01, 2'b10) `PLAYMOVE(2'b11, 2'b11)
        if (game_state != 2'b01) $display("Testcase failed: X Bottom Row win"); else $display("Testcase 5 passed");

        // Left Column Win
        `RESETBOARD
        `PLAYMOVE(2'b01, 2'b01) `PLAYMOVE(2'b10, 2'b10) `PLAYMOVE(2'b10, 2'b01) `PLAYMOVE(2'b11, 2'b11) `PLAYMOVE(2'b11, 2'b01)
        if (game_state != 2'b01) $display("Testcase failed: X Left Column win"); else $display("Testcase 6 passed");

        // Center Column Win
        `RESETBOARD
        `PLAYMOVE(2'b01, 2'b10) `PLAYMOVE(2'b01, 2'b01) `PLAYMOVE(2'b10, 2'b10) `PLAYMOVE(2'b01, 2'b11) `PLAYMOVE(2'b11, 2'b10)
        if (game_state != 2'b01) $display("Testcase failed: X Center Column win"); else $display("Testcase 7 passed");

        // Right Column Win
        `RESETBOARD
        `PLAYMOVE(2'b01, 2'b11) `PLAYMOVE(2'b01, 2'b01) `PLAYMOVE(2'b10, 2'b11) `PLAYMOVE(2'b01, 2'b10) `PLAYMOVE(2'b11, 2'b11)
        if (game_state != 2'b01) $display("Testcase failed: X Right Column win"); else $display("Testcase 8 passed");

        // Diagonal Win (Top-left to Bottom-right)
        `RESETBOARD
        `PLAYMOVE(2'b01, 2'b01) `PLAYMOVE(2'b01, 2'b10) `PLAYMOVE(2'b10, 2'b10) `PLAYMOVE(2'b01, 2'b11) `PLAYMOVE(2'b11, 2'b11)
        if (game_state != 2'b01) $display("Testcase failed: X Diagonal win"); else $display("Testcase 9 passed");

        // (Top-right to Bottom-left)
        `RESETBOARD
        `PLAYMOVE(2'b01, 2'b11) `PLAYMOVE(2'b10, 2'b10) `PLAYMOVE(2'b11, 2'b01)
        if (game_state != 2'b00) $display("Testcase failed: X Anti-Diagonal win"); else $display("Testcase 10 passed");

        // Draw Scenario
        `RESETBOARD
        `PLAYMOVE(2'b01, 2'b01) `PLAYMOVE(2'b01, 2'b10) `PLAYMOVE(2'b01, 2'b11)
        `PLAYMOVE(2'b10, 2'b10) `PLAYMOVE(2'b10, 2'b01) `PLAYMOVE(2'b10, 2'b11)
        `PLAYMOVE(2'b11, 2'b10) `PLAYMOVE(2'b11, 2'b01) `PLAYMOVE(2'b11, 2'b11)
        if (game_state != 2'b11) $display("Testcase failed: Draw game"); else $display("Testcase 11 passed");

        // Diagonal Win from Top-Left to Bottom-Right
        `RESETBOARD
        `PLAYMOVE(2'b01, 2'b01) `PLAYMOVE(2'b01, 2'b10) `PLAYMOVE(2'b10, 2'b10)
        `PLAYMOVE(2'b11, 2'b10) `PLAYMOVE(2'b11, 2'b11)
        if (game_state != 2'b01) $display("Testcase failed: X Diagonal Top-Left to Bottom-Right win"); else $display("Testcase X Diagonal TL-BR passed");

        // Diagonal Win from Bottom-Left to Top-Right
        `RESETBOARD
        `PLAYMOVE(2'b11, 2'b01) `PLAYMOVE(2'b01, 2'b10) `PLAYMOVE(2'b10, 2'b10)
        `PLAYMOVE(2'b10, 2'b01) `PLAYMOVE(2'b01, 2'b11)
        if (game_state != 2'b01) $display("Testcase failed: X Diagonal Bottom-Left to Top-Right win"); else $display("Testcase X Diagonal BL-TR passed");

        //Checking if board updates after win
        `RESETBOARD
        `PLAYMOVE(2'b01, 2'b01) `PLAYMOVE(2'b01, 2'b10) `PLAYMOVE(2'b01, 2'b11)
        `PLAYMOVE(2'b10, 2'b01) `PLAYMOVE(2'b11, 2'b11) `PLAYMOVE(2'b10, 2'b10)
        `PLAYMOVE(2'b11, 2'b01) `PLAYMOVE(2'b10, 2'b11) `PLAYMOVE(2'b11, 2'b10)
        if (game_state != 2'b10) $display("Testcase failed: Check 1"); else $display("Testcase Check 1 passed");

        `RESETBOARD
        `PLAYMOVE(2'b01, 2'b01) `PLAYMOVE(2'b01, 2'b10) `PLAYMOVE(2'b10, 2'b11)
        `PLAYMOVE(2'b10, 2'b01) `PLAYMOVE(2'b01, 2'b11) `PLAYMOVE(2'b10, 2'b10)
        `PLAYMOVE(2'b11, 2'b01) `PLAYMOVE(2'b11, 2'b10) `PLAYMOVE(2'b11, 2'b11)
        if (game_state != 2'b10) $display("Testcase failed: Check 2"); else $display("Testcase Check 2 passed");

        $finish;
    end

    always #5 clk <= ~clk;
endmodule
