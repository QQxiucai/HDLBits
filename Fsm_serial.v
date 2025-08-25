module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 

    parameter [2:0] IDLE=3'd0,START=3'd1,DATA=3'd2,ERROR=3'd3,STOP=3'd4;
    reg [2:0]state;
    reg [2:0]next_state;
    reg [3:0]count;

    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            count <= 4'd0;
        end
        else begin
            state <= next_state;
            if(state==DATA)
                count <= count + 1'b1;
            else
                count <= 4'd0;
        end
    end

    always @(*) begin
        case(state)
            IDLE: next_state = (in==1'b0)? START:IDLE;
            START: next_state = DATA;
            DATA: next_state = (count==4'd7)? ((in==1'b1)? STOP: ERROR) : DATA;
            ERROR: next_state = (in==1'b1)? IDLE: ERROR;
            STOP: next_state = (in==1'b1)? IDLE: START;
            default: next_state = IDLE; 
    endcase
    end

    always@(*)begin
        case(state)
            IDLE:   done = 1'b0;
            START:  done = 1'b0;
            DATA:   done = 1'b0;
            ERROR:  done = 1'b0;
            STOP:   done = 1'b1;
            default:done = 1'h0;
        endcase
    end
endmodule