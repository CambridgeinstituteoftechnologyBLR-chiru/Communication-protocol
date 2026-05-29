`timescale 1ns/1ps

module tb;

reg clk;
reg rst_n;
reg [7:0] ui_in;

wire [7:0] uo_out;

wire [7:0] uio_out;
wire [7:0] uio_oe;

wire [7:0] uio_in;

assign uio_in[0] = uio_out[0]; // loopback
assign uio_in[7:1] = 7'b0;

tt_um_single_wire_uart dut (
    .clk(clk),
    .rst_n(rst_n),
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_in(uio_in),
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .ena(1'b1)
);

always #5 clk = ~clk;

initial
begin
    clk = 0;
    rst_n = 0;
    ui_in = 8'hA5;

    #20;
    rst_n = 1;

    #300;

    $display("Received Data = %h", uo_out);

    #100;
    $finish;
end

initial
begin
    $dumpfile("uart.vcd");
    $dumpvars(0,tb);
end

endmodule
