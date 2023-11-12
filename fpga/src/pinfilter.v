// filter noise from GPIO pins
// takes 2 cycles with enabled signal to stabilize a line

//`define FASTREAD

module pinfilter(
    input clk,
    input reset_n,
    input din,
    input ena,
    output dout
);

    reg [1:0] dpipe;
    reg d;
    reg d2;

    always @(posedge clk or negedge reset_n) begin

    if (~reset_n) begin

            dpipe <= 2'b11;

        end else begin

            if (ena) begin

                dpipe <= { dpipe[0], din };

                d <= (dpipe[1:0] == 2'b00) ? 1'b0 : (dpipe[1:0] == 2'b11) ? 1'b1 : d;

            end
`ifdef FASTREAD
            d <= (dpipe[1:0] == 2'b00) ? 1'b0 : (dpipe[1:0] == 2'b11) ? 1'b1 : d;
`endif

        end
    end

assign dout =  d;

endmodule
