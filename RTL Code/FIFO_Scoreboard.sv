package Scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sequence_item_pkg::*;
class FIFO_Scoreboard extends uvm_scoreboard;
 `uvm_component_utils(FIFO_Scoreboard)
  uvm_analysis_export #(FIFO_seq_item) sb_export;
  uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
  FIFO_seq_item seq_item_sb;  

logic [FIFO_WIDTH-1:0] data_out_ref;
logic wr_ack_ref, overflow_ref;
logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
bit [FIFO_WIDTH-1:0] FIFO_queue[$];  
integer count=0;

int error_count = 0;
int correct_count =0;

function new(string name = "FIFO_Scoreboard" , uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 sb_export = new("sb_export",this);
 sb_fifo = new("sb_fifo",this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  sb_export.connect(sb_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    sb_fifo.get(seq_item_sb);
    reference_model(seq_item_sb);
    if(data_out_ref!== seq_item_sb.data_out || 
     (wr_ack_ref!== seq_item_sb.wr_ack) || 
     (overflow_ref!== seq_item_sb.overflow) || 
     (full_ref!== seq_item_sb.full) || 
     (empty_ref!== seq_item_sb.empty) || 
     (almostfull_ref!== seq_item_sb.almostfull) || 
     (almostempty_ref!== seq_item_sb.almostempty) || 
     (underflow_ref!== seq_item_sb.underflow))begin
      `uvm_error("run_phase", $sformatf("comparison failed, transaction received by the DUT:%s while the reference data_out:0b%0b ,wr_ack:0b%0b ,overflow:0b%0b ,full:0b%0b ,empty:0b%0b ,almostfull:0b%0b ,almostempty:0b%0b ,underflow:0b%0b ", seq_item_sb.convert2string(),data_out_ref,wr_ack_ref,overflow_ref,full_ref,empty_ref,almostfull_ref,almostempty_ref,underflow_ref));
      error_count = error_count + 1;
    end
 else
 `uvm_info("run_phase", $sformatf("Correct FIFO out: %s", seq_item_sb.convert2string()), UVM_HIGH);
 correct_count = correct_count + 1;
  end
endtask  

task reference_model (FIFO_seq_item seq_item_chk);
if(seq_item_chk.rst_n==0) begin
  overflow_ref=0;
  full_ref=0;
  empty_ref=1; 
  almostfull_ref=0;
  almostempty_ref=0; 
  count=0;
  wr_ack_ref=0;
  FIFO_queue.delete();
  underflow_ref=0;
end
else if(seq_item_chk.wr_en==1 && seq_item_chk.rd_en==1 && count==8)begin
   data_out_ref=FIFO_queue.pop_back();
   wr_ack_ref=0;
   overflow_ref=1;
   underflow_ref=0;
   count=count-1;
end
else if(seq_item_chk.wr_en==1 && seq_item_chk.rd_en==1 && count==0)begin
   FIFO_queue.push_front(seq_item_chk.data_in);
   wr_ack_ref=1;
   overflow_ref=0;
   underflow_ref=1;
   count=count+1;
end
else if(seq_item_chk.wr_en==1 && count==8)begin
   wr_ack_ref=0;
   overflow_ref=1;
   underflow_ref=0;
end
else if(seq_item_chk.rd_en==1 && count==0)begin
   wr_ack_ref=0;
   overflow_ref=0;  
   underflow_ref=1;
end
else if(seq_item_chk.wr_en==1 && seq_item_chk.rd_en==1)begin
   FIFO_queue.push_front(seq_item_chk.data_in);
   data_out_ref=FIFO_queue.pop_back();
   wr_ack_ref=1;
   overflow_ref=0;
   underflow_ref=0;
end
else if(seq_item_chk.wr_en==1)begin
   FIFO_queue.push_front(seq_item_chk.data_in);
   count=count+1;
   wr_ack_ref=1;
   overflow_ref=0;
   underflow_ref=0;
end
else if(seq_item_chk.rd_en==1)begin
   data_out_ref=FIFO_queue.pop_back();
   count=count-1;
   wr_ack_ref=0;
   overflow_ref=0;
   underflow_ref=0;
end
else begin
   overflow_ref=0;
   underflow_ref=0;
   wr_ack_ref=0;
end   
if(count == 0)begin
  full_ref=0;
  empty_ref=1; 
  almostfull_ref=0;
  almostempty_ref=0; 
end  
else if(count == 8)begin
  full_ref=1;
  empty_ref=0; 
  almostfull_ref=0;
  almostempty_ref=0; 
end  
else if(count == 7)begin
  full_ref=0;
  empty_ref=0; 
  almostfull_ref=1;
  almostempty_ref=0; 
end  
else if(count == 1)begin
  full_ref=0;
  empty_ref=0; 
  almostfull_ref=0;
  almostempty_ref=1;
end 
else begin
  full_ref=0;
  empty_ref=0; 
  almostfull_ref=0;
  almostempty_ref=0; 
end
endtask

function void report_phase(uvm_phase phase);
 super.report_phase(phase);
 `uvm_info("report_phase", $sformatf("Total successful transactions: %0d",correct_count), UVM_MEDIUM);
 `uvm_info("report_phase", $sformatf("Total failed transactions: %0d",error_count), UVM_MEDIUM);
endfunction
endclass  
endpackage