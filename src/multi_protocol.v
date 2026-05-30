module tt_um_multi_protocol (
    input  wire [7:0] ui_in,
    output reg  [7:0] uo_out,

    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,

    input  wire ena,
    input  wire clk,
    input  wire rst_n
);

    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    wire [3:0] data_in = ui_in[3:0];
    wire start         = ui_in[4];
    wire [1:0] mode    = ui_in[6:5];

    reg [3:0] shift_reg;
    reg [3:0] bit_cnt;
    reg [2:0] state;

    localparam IDLE = 3'd0;
    localparam LOAD = 3'd1;
    localparam SEND = 3'd2;
    localparam DONE = 3'd3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out    <= 8'b0;
            shift_reg <= 4'b0;
            bit_cnt   <= 4'b0;
            state     <= IDLE;
        end
        else begin

            case (state)

                IDLE: begin
                    uo_out[6] <= 1'b0; // busy
                    uo_out[7] <= 1'b0; // done

                    if (start)
                        state <= LOAD;
                end

                LOAD: begin
                    shift_reg <= data_in;
                    bit_cnt   <= 4;

                    uo_out[6] <= 1'b1;

                    if (mode == 2'b01)
                        uo_out[3] <= 1'b0;
                    else
                        uo_out[3] <= 1'b1;

                    state <= SEND;
                end

                SEND: begin

                    if (mode == 2'b00) begin
                        uo_out[0] <= shift_reg[3];
                    end

                    else if (mode == 2'b01) begin
                        uo_out[1] <= shift_reg[3];
                        uo_out[2] <= ~uo_out[2];
                    end

                    else if (mode == 2'b10) begin
                        uo_out[4] <= shift_reg[3];
                        uo_out[5] <= ~uo_out[5];
                    end

                    shift_reg <= {shift_reg[2:0], 1'b0};

                    if (bit_cnt > 0)
                        bit_cnt <= bit_cnt - 1;

                    if (bit_cnt == 1)
                        state <= DONE;
                end

                DONE: begin
                    uo_out[6] <= 1'b0;
                    uo_out[7] <= 1'b1;
                    uo_out[3] <= 1'b1;
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule
