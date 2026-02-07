// Code your testbench here
// or browse Examples
module tb_fifo_method1;

    reg clk, rst, wr_en, rd_en;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire full, empty;

    fifo_method1 dut (.*);

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1;
        wr_en = 0; rd_en = 0; data_in = 0;
        repeat(2) @(posedge clk);
        rst = 0;

        // WRITE until FULL
        while (!full) begin
            @(posedge clk);
            wr_en = 1;
            data_in = data_in + 1;
        end
        wr_en = 0;

        // READ until EMPTY
        while (!empty) begin
            @(posedge clk);
            rd_en = 1;
        end
        rd_en = 0;

        // SIMULTANEOUS READ & WRITE
        repeat(5) begin
            @(posedge clk);
            wr_en = 1;
            rd_en = 1;
            data_in = $random;
        end

        $finish;
    end
  initial begin
  $dumpfile("dump.vcd");
   $dumpvars();
   // FIFO internals
   #1000;
   $finish;
end
endmodule
