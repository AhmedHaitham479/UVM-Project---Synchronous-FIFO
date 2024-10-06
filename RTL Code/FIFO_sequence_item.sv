package sequence_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
class FIFO_seq_item extends uvm_sequence_item;
 `uvm_object_utils(FIFO_seq_item)
rand bit [FIFO_WIDTH-1:0] data_in;
rand bit rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

  function new(string name = "FIFO_seq_item");
  super.new(name);
  endfunction

  function string convert2string();
   return $sformatf("%s data_in = 0b%b,rst_n = 0b%b,wr_en = 0b%b,rd_en = 0b%b,data_out = 0b%b,wr_ack = 0b%b,overflow = 0b%b,full = 0b%b, empty = 0b%b,almostfull = 0b%b,almostempty = 0b%b,underflow = 0b%b",
   super.convert2string(),data_in,rst_n,wr_en,rd_en,data_out,wr_ack,overflow,full,empty,almostfull,almostempty,underflow);
  endfunction

  function string convert2string_stimulus();
   return $sformatf("data_in = 0b%b,rst_n = 0b%b,wr_en = 0b%b,rd_en = 0b%b"
   ,data_in,rst_n,wr_en,rd_en);
  endfunction 

constraint rst_n_C{rst_n dist{0:=3,1:=97};}//no reset 97% of the time
constraint wr_en_C{wr_en dist{1:=70,0:=30};}
constraint rd_en_C{wr_en dist{1:=30,0:=70};}
endclass  
endpackage