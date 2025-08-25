module top_module(
    input wire			clk,
    input wire			in,
    input wire			reset,
    output reg	[7:0]	out_byte,
    output reg			done
);
    
	localparam IDLE=3'd0, START=3'd1, DATA=3'd2, PARITY=3'd3, DONE=3'd4, ERROR=3'd5;
    reg	[2:0]state, next;
    reg	[3:0]cnt;
    reg	[7:0]out_t;
    wire odd, rst_par;
    reg	par;

    always@(posedge clk)begin
        if(reset) state <= IDLE;
        else state <= next;
    end
    
    always@(*)begin
        case(state)
            IDLE:next=(in==0)?START:IDLE;
            START:next=DATA;
            DATA:next=(cnt==8)?PARITY:DATA;
            PARITY:next=(in==0)?ERROR:DONE;
            ERROR:next=(in==1)?IDLE:ERROR;
            DONE:next=(in==1)?IDLE:START;
            default:next=IDLE;
    endcase
    end

    always@(posedge clk)begin
        if(next==DATA) cnt <= cnt + 1'b1;
        else cnt <= 4'd0;
        out_t[cnt]<=(next==DATA)?in:out_t[cnt];
    end

    always@(posedge clk)begin
        par<=(state==PARITY)?odd:par;
    end

    always@(*)begin
        out_byte=(state==DONE&&par==1)?out_t:8'd0;
        done=(state==DONE && par==1)?1'b1:1'b0;
    end

    assign rst_par = (next==START);

    parity u_parity(
    .clk(clk),
    .reset(rst_par),
    .in(in),
    .odd(odd)
);
endmodule
