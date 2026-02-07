// Code your design here
module fifo_method2 #(
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
    reg [PTR_W:0] w_ptr, r_ptr; // extra MSB

    assign empty = (w_ptr == r_ptr);
    assign full  = (w_ptr[PTR_W] != r_ptr[PTR_W]) &&
                   (w_ptr[PTR_W-1:0] == r_ptr[PTR_W-1:0]);

    always @(posedge clk) begin
        if (rst) begin
            w_ptr <= 0;
            r_ptr <= 0;
            data_out <= 0;
        end else begin
            if (wr_en && !full) begin
                mem[w_ptr[PTR_W-1:0]] <= data_in;
                w_ptr <= w_ptr + 1'b1;
            end

            if (rd_en && !empty) begin
                data_out <= mem[r_ptr[PTR_W-1:0]];
                r_ptr <= r_ptr + 1'b1;
            end
        end
    end
endmodule
