// _LLMHWS_HEADER_COMMENT_END_
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
// _LLMHWS_SECTION_VERY_HARD_BEGIN_
// _LLMHWS_SECTION_1_MEDIUM_BEGIN_
if (~ip_resetn)
begin
Data_out <= 16'h0000;
// _LLMHWS_SECTION_1_EASY_BEGIN_
Write_once_status <= 1'b0;
// _LLMHWS_SECTION_1_EASY_END_
end
// _LLMHWS_SECTION_1_MEDIUM_END_
// _LLMHWS_SECTION_2_HARD_BEGIN_
else if (write & ~Write_once_status)
begin
Data_out <= Data_in & 16'hFFFE; // Input data written to register after masking bit 0
// _LLMHWS_SECTION_2_EASY_BEGIN_
Write_once_status <= 1'b1; // Write once status set after first write.
// _LLMHWS_SECTION_2_EASY_END_
end
// _LLMHWS_SECTION_2_HARD_END_
else if (~write)
begin
// _LLMHWS_SECTION_3_EASY_BEGIN_
Data_out[15:1] <= Data_out[15:1];
Data_out[0] <= Write_once_status;
// _LLMHWS_SECTION_3_EASY_END_
end
// _LLMHWS_SECTION_VERY_HARD_END_
endmodule
