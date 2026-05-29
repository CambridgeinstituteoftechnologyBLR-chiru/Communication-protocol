module tt_um_single_wire_uart (
    input  wire       clk,
    input  wire       rst_n,

    input  wire [7:0] ui_in,
    output reg  [7:0] uo_out,

    input  wire [7:0] uio_in,
    output reg  [7:0] uio_out,
    output reg  [7:0] uio_oe,

    input  wire       ena
);

reg [3:0] tx_state;
reg [3:0] rx_state;

reg [7:0] tx_shift;
reg [7:0] rx_shift;

reg [2:0] tx_count;
reg [2:0] rx_count;

localparam IDLE  = 0;
localparam START = 1;
localparam DATA  = 2;
localparam STOP  = 3;

// Transmitter
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        tx_state <= IDLE;
        tx_shift <= 8'd0;
        tx_count <= 3'd0;

        uio_out[0] <= 1'b1;
        uio_oe[0]  <= 1'b1;
    end
    else
    begin
        case(tx_state)

        IDLE:
        begin
            tx_shift <= ui_in;
            tx_count <= 0;
            tx_state <= START;
        end

        START:
        begin
            uio_out[0] <= 1'b0;
            tx_state <= DATA;
        end

        DATA:
        begin
            uio_out[0] <= tx_shift[0];
            tx_shift <= tx_shift >> 1;

            if(tx_count == 7)
                tx_state <= STOP;
            else
                tx_count <= tx_count + 1;
        end

        STOP:
        begin
            uio_out[0] <= 1'b1;
            tx_state <= IDLE;
        end

        endcase
    end
end

// Receiver
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        rx_state <= IDLE;
        rx_shift <= 8'd0;
        rx_count <= 3'd0;
        uo_out   <= 8'd0;
    end
    else
    begin
        case(rx_state)

        IDLE:
        begin
            if(uio_in[0] == 1'b0)
            begin
                rx_count <= 0;
                rx_state <= DATA;
            end
        end

        DATA:
        begin
            rx_shift[rx_count] <= uio_in[0];

            if(rx_count == 7)
                rx_state <= STOP;
            else
                rx_count <= rx_count + 1;
        end

        STOP:
        begin
            uo_out <= rx_shift;
            rx_state <= IDLE;
        end

        endcase
    end
end

endmodule
