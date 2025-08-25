module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //

    parameter BYTE1=2'b00,BYTE2=2'b01,BYTE3=2'b10,finish=2'b11;
    reg [1:0]state;
    reg [1:0]next_state;
    reg [23:0] out_mem;

    always @(posedge clk) begin
        if(reset) state <= BYTE1;
        else state <= next_state;
    end

    always @(*)begin
        case(state)
            BYTE1: next_state=in[3]==1? BYTE2: BYTE1;
            BYTE2: next_state=BYTE3;
            BYTE3: next_state=finish;
            finish: next_state=in[3]==1? BYTE2: BYTE1;
            default: next_state=BYTE1;
        endcase
    end

    always@(*)begin
        case(state)
            BYTE1:   done = 1'b0;
            BYTE2:   done = 1'b0;
            BYTE3:   done = 1'b0;
            finish:  done = 1'b1;
            default: done = 1'h0;
        endcase
    end

    always @(posedge clk) begin
            case(state)
                BYTE1: out_mem[23:16] <= in;
                BYTE2: out_mem[15:8] <= in;
                BYTE3: out_mem[7:0] <= in;
                finish: out_mem[23:16] <= in[3]==1?in:8'd0;
                default: out_mem <= 24'hx;
            endcase
        end
    assign out_bytes = state==finish?out_mem:8'dx;

endmodule