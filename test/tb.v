`default_nettype none

module tb ();

    reg clk;
    reg rst_n;
    reg [7:0] ui_in;

    wire [7:0] uo_out;

    tt_um_multi_protocol dut (
        .clk(clk),
        .rst_n(rst_n),
        .ui_in(ui_in),
        .uo_out(uo_out)
    );

    initial begin
        $dumpfile("tb.fst");
        $dumpvars(0, tb);
    end

endmodule
