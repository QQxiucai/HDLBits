module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    parameter LEFT  = 0;
    parameter RIGHT = 1;

    reg state;
    reg next_state;

    wire [1:0] bump;
    assign bump = {bump_left, bump_right};

    // 组合逻辑：状态转移
    always @(*) begin
        case (bump)
            2'b00: next_state = state;
            2'b01: next_state = (state == RIGHT) ? LEFT : state;
            2'b10: next_state = (state == LEFT)  ? RIGHT : state;
            2'b11: next_state = ~state;
            default: next_state = state;
        endcase
    end

    // 时序逻辑：状态寄存器，带异步复位
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;  // 复位时向左走
        else
            state <= next_state;
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule
