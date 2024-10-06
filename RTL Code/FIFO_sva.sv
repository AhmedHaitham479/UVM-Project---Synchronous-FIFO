module FIFO_sva(FIFO_if.DUT F_if);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
localparam max_fifo_addr = $clog2(FIFO_DEPTH);
logic [FIFO_WIDTH-1:0] data_in;
logic clk, rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;
logic [max_fifo_addr:0] count;

assign clk = F_if.clk;
assign data_in = F_if.data_in;
assign rst_n = F_if.rst_n;
assign wr_en = F_if.wr_en;
assign rd_en = F_if.rd_en;
assign data_out = F_if.data_out;
assign wr_ack = F_if.wr_ack;
assign overflow = F_if.overflow;
assign full = F_if.full;
assign empty = F_if.empty;
assign almostfull = F_if.almostfull;
assign almostempty = F_if.almostempty;
assign underflow = F_if.underflow;
assign wr_ptr = dut.wr_ptr;
assign rd_ptr = dut.rd_ptr;
assign count = dut.count;

property p_rst;
     @(negedge clk) ((rst_n==0) |-> (rd_ptr==0 && wr_ptr==0 && count==0 && full==0 && empty==1 && almostfull==0 && almostempty==0));
endproperty

property p_full;
     @(posedge clk) ((count==FIFO_DEPTH) |-> (full==1 && empty==0 && almostfull==0 && almostempty==0));
endproperty 

property p_almostfull;
     @(posedge clk) ((count==FIFO_DEPTH-1) |-> (full==0 && empty==0 && almostfull==1 && almostempty==0));
endproperty

property p_almostempty;
     @(posedge clk) ((count==1) |-> (full==0 && empty==0 && almostfull==0 && almostempty==1));
endproperty 

property p_empty;
     @(posedge clk) ((count==0) |-> (full==0 && empty==1 && almostfull==0 && almostempty==0));
endproperty

property p_underflow;
     @(posedge clk) disable iff (!rst_n)((rd_en && empty) |=> (underflow==1));
endproperty 

property p_overflow;
     @(posedge clk) disable iff (!rst_n)((wr_en && full) |=> (overflow==1));
endproperty

property p_rd_ptr;
     @(posedge clk) disable iff (!rst_n)((rd_en && !empty) |=> (rd_ptr==$past(rd_ptr)+1'b1));
endproperty 

property p_wr_ptr;
     @(posedge clk) disable iff (!rst_n)((wr_en && !full) |=> (wr_ptr==$past(wr_ptr)+1'b1));
endproperty

property p_wr_ack;
     @(negedge clk) (( wr_en==1 && rst_n==1 && overflow==0) |-> (wr_ack==1));
endproperty

rst_assertion: assert property(p_rst);
full_assertion: assert property(p_full);
almostfull_assertion: assert property(p_almostfull);
almostempty_assertion: assert property(p_almostempty);
empty_assertion: assert property(p_empty);
underflow_assertion: assert property(p_underflow);
overflow_assertion: assert property(p_overflow);
rd_ptr_assertion: assert property(p_rd_ptr);
wr_ptr_assertion: assert property(p_wr_ptr);
wr_ack_assertion: assert property(p_wr_ack);

rst_cover: cover property(p_rst);
full_cover: cover property(p_full);
almostfull_cover: cover property(p_almostfull);
almostempty_cover: cover property(p_almostempty);
empty_cover: cover property(p_empty);
underflow_cover: cover property(p_underflow);
overflow_cover: cover property(p_overflow);
rd_ptr_cover: cover property(p_rd_ptr);
wr_ptr_cover: cover property(p_wr_ptr);
wr_ack_cover: cover property(p_wr_ack);

endmodule