// Code your design here
module fifo_method1 #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 8
)(
    input  wire                  clk,
    input  wire                  rst,
    input  wire                  wr_en,
    input  wire                  rd_en,
    input  wire [DATA_WIDTH-1:0] data_in,
    output reg  [DATA_WIDTH-1:0] data_out,
    output wire                  full,
    output wire                  empty
);

    localparam PTR_W = $clog2(DEPTH);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [PTR_W-1:0] w_ptr, r_ptr;

    assign empty = (w_ptr == r_ptr);
    assign full  = ((w_ptr + 1'b1) == r_ptr);

    always @(posedge clk) begin
        if (rst) begin
            w_ptr    <= 0;
            r_ptr    <= 0;
            data_out <= 0;
        end else begin
            // WRITE
            if (wr_en && !full) begin
                mem[w_ptr] <= data_in;
                w_ptr <= w_ptr + 1'b1;
            end

            // READ
            if (rd_en && !empty) begin
                data_out <= mem[r_ptr];
                r_ptr <= r_ptr + 1'b1;
            end
        end
    end

endmodule
