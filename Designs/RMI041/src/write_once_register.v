module register_write_once_example
(
input [15:0] Data_in,
input Clk,
input ip_resetn,
input global_resetn,
input write,
output reg [15:0] Data_out
);

reg Write_once_status;

always @(posedge Clk or negedge ip_resetn)

if (~ip_resetn)
begin
Data_out <= 16'h0000;
Write_once_status <= 1'b0;
end
else if (write & ~Write_once_status)
begin
Data_out <= Data_in & 16'hFFFE; // Input data written to register after masking bit 0
Write_once_status <= 1'b1; // Write once status set after first write.
end
else if (~write)
begin
Data_out[15:1] <= Data_out[15:1];
Data_out[0] <= Write_once_status;
end

endmodule
