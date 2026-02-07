// Code your design here
module fifo_method3 #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 8
)(
    input  wire clk, rst, wr_en, rd_en,
    input  wire [DATA_WIDTH-1:0] data_in,
    output reg  [DATA_WIDTH-1:0] data_out,
    output wire full, empty
);

    localparam PTR_W = $clog2(DEPTH);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [PTR_W-1:0] w_ptr, r_ptr;
    reg [$clog2(DEPTH+1)-1:0] count;

    assign empty = (count == 0);
    assign full  = (count == DEPTH);

    always @(posedge clk) begin
        if (rst) begin
            w_ptr <= 0; r_ptr <= 0; count <= 0; data_out <= 0;
        end else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: begin // WRITE
                    mem[w_ptr] <= data_in;
                    w_ptr <= w_ptr + 1'b1;
                    count <= count + 1'b1;
                end
                2'b01: begin // READ
                    data_out <= mem[r_ptr];
                    r_ptr <= r_ptr + 1'b1;
                    count <= count - 1'b1;
                end
                2'b11: begin // SIMULTANEOUS
                    mem[w_ptr] <= data_in;
                    data_out <= mem[r_ptr];
                    w_ptr <= w_ptr + 1'b1;
                    r_ptr <= r_ptr + 1'b1;
                end
            endcase
        end
    end
endmodule
