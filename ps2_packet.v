module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //

	parameter BYTE1=2'b00,BYTE2=2'b01,BYTE3=2'b10,finish=2'b11;
    reg [1:0]state;
    reg [1:0]next_state;

    always @(posedge clk) begin
        if(reset)
            state <= BYTE1;
        else
            state <= next_state;
    end

    always @(*) begin
        case(state)
            BYTE1: next_state = (in[3]==1)? BYTE2: BYTE1;
            BYTE2: next_state =  BYTE3;
            BYTE3: next_state=finish;
            finish: next_state=in[3]==1? BYTE2: BYTE1;
            default: next_state=BYTE1;
        endcase
    end

    reg done_wire;
    always@(*)begin
        case(state)
            BYTE1:   done_wire = 1'b0;
            BYTE2:   done_wire = 1'b0;
            BYTE3:   done_wire = 1'b0;
            finish:  done_wire = 1'b1;
            default: done_wire = 1'h0;
        endcase
    end

    assign done = done_wire;
endmodule