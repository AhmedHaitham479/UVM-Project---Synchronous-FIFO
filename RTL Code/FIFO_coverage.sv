package Coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sequence_item_pkg::*;
class FIFO_Coverage extends uvm_component;
 `uvm_component_utils(FIFO_Coverage)
  uvm_analysis_export #(FIFO_seq_item) cov_export;
  uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
  FIFO_seq_item seq_item_cov;  


covergroup cvr_gp;

wr_en: coverpoint seq_item_cov.wr_en;
rd_en: coverpoint seq_item_cov.rd_en;
overflow: coverpoint seq_item_cov.overflow;
almostempty: coverpoint seq_item_cov.almostempty;
empty: coverpoint seq_item_cov.empty;
almostfull: coverpoint seq_item_cov.almostfull;
underflow: coverpoint seq_item_cov.underflow;
full: coverpoint seq_item_cov.full;
wr_ack: coverpoint seq_item_cov.wr_ack;

wr_ack_cvr:cross wr_en, rd_en, wr_ack {illegal_bins wr_wr_ack = binsof(wr_en) intersect {0} && binsof(wr_ack) intersect {1};}//no write achknowlege can happen if there is no write operation 
overflow_cvr:cross wr_en, rd_en, overflow{illegal_bins write_overflow = binsof(wr_en) intersect {0} && binsof(overflow) intersect {1};}//no overflow can happen if there is no write operation
full_cvr:cross wr_en, rd_en, full{illegal_bins read_full = binsof(rd_en) intersect {1} && binsof(full) intersect {1};}//the fifo can't be full if a read operation occured
empty_cvr:cross wr_en, rd_en, empty;
almostfull_cvr:cross wr_en, rd_en, almostfull;
almostempty_cvr:cross wr_en, rd_en, almostempty;
underflow_cvr:cross wr_en, rd_en, underflow{illegal_bins read_full = binsof(rd_en) intersect {0} && binsof(underflow) intersect {1};}//no underflow can happen if there is no read operation
endgroup

function new(string name = "FIFO_Coverage" , uvm_component parent = null);
  super.new(name,parent);
   cvr_gp=new();
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 cov_export = new("cov_export",this);
 cov_fifo = new("cov_fifo",this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    cov_fifo.get(seq_item_cov);
    cvr_gp.sample();
  end
endtask  

endclass  
endpackage