`timescale 1ns/1ps

module tb_tt_um_multi_protocol;

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

    always #5 clk = ~clk;

    initial begin

        clk   = 0;
        rst_n = 0;
        ui_in = 0;

        #20;
        rst_n = 1;

        //----------------------------------
        // UART TEST
        //----------------------------------
        $display("UART TEST");

        ui_in[3:0] = 4'b1010;
        ui_in[6:5] = 2'b00;
        ui_in[4]   = 1'b1;

        #10;
        ui_in[4]   = 1'b0;

        #100;

        //----------------------------------
        // SPI TEST
        //----------------------------------
        $display("SPI TEST");

        ui_in[3:0] = 4'b1100;
        ui_in[6:5] = 2'b01;
        ui_in[4]   = 1'b1;

        #10;
        ui_in[4]   = 1'b0;

        #100;

        //----------------------------------
        // I2C TEST
        //----------------------------------
        $display("I2C TEST");

        ui_in[3:0] = 4'b0110;
        ui_in[6:5] = 2'b10;
        ui_in[4]   = 1'b1;

        #10;
        ui_in[4]   = 1'b0;

        #100;

        $finish;

    end

    initial begin
        $monitor(
            "T=%0t mode=%b data=%b UART=%b MOSI=%b SCLK=%b SDA=%b SCL=%b BUSY=%b DONE=%b",
            $time,
            ui_in[6:5],
            ui_in[3:0],
            uo_out[0],
            uo_out[1],
            uo_out[2],
            uo_out[4],
            uo_out[5],
            uo_out[6],
            uo_out[7]
        );
    end

endmodule
