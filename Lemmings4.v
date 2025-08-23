module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    parameter LEFT=3'b000,RIGHT=3'b001,DIG_L=3'b010,FALL_L=3'b100,DIG_R=3'b011,FALL_R=3'b101,SPLAT=3'b111,DEAD=3'b110;
    reg [2:0]state;
    reg [2:0]next_state;
    wire [1:0]bump;
    assign bump = {bump_left,bump_right};
    reg [4:0] FALL_TIME;

    always @(posedge clk or posedge areset) begin
        if(areset)
            FALL_TIME <= 5'b0;
        else if (next_state == FALL_L || next_state == FALL_R)
            FALL_TIME <= FALL_TIME + 1'b1;
        else
            FALL_TIME <= 5'b0;
    end

    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground) next_state = FALL_L;
                else if (dig) next_state = DIG_L;
                else if (bump == 2'b10||bump==2'b11) next_state = RIGHT;
                else next_state = LEFT;
            end
            RIGHT: begin
                if (!ground) next_state = FALL_R;
                else if (dig) next_state = DIG_R;
                else if (bump == 2'b01||bump==2'b11) next_state = LEFT;
                else next_state = RIGHT;
            end
            DIG_L: begin
                if (!ground) next_state = FALL_L;
                else next_state = DIG_L;
            end
            DIG_R: begin
                if (!ground) next_state = FALL_R;
                else next_state = DIG_R;
            end
            FALL_L:begin
            if((ground ==1'b0) &&(FALL_TIME < 5'd20)) 
                next_state = FALL_L;
            else if((ground ==1'b0) &&(FALL_TIME >= 5'd20))
                next_state = SPLAT;
            else    
                next_state = LEFT;   
            end    
            FALL_R:begin
            if((ground ==1'b0) &&(FALL_TIME < 5'd20)) 
                next_state = FALL_R;
            else if((ground ==1'b0) &&(FALL_TIME >= 5'd20))
                next_state = SPLAT;     
            else
                next_state = RIGHT;   
            end
            SPLAT:begin
                if( ground ==1'b1 ) 
                next_state = DEAD;
            else
                next_state = SPLAT;   
            end  
            DEAD:
                next_state = DEAD;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if(areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT); 
    assign digging = (state == DIG_L || state == DIG_R);
    assign aaah = ((state == FALL_L) || (state == FALL_R) || (state == SPLAT));
endmodule