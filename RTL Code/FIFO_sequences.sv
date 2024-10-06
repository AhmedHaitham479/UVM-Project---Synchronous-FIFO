package sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sequence_item_pkg::*;
class FIFO_main_sequence extends uvm_sequence #(FIFO_seq_item);
 `uvm_object_utils(FIFO_main_sequence)
 FIFO_seq_item seq_item;
  
function new(string name = "FIFO_main_sequence");
  super.new(name);
endfunction

task body;
 repeat(10000) begin
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    start_item(seq_item);
    assert(seq_item.randomize);
    finish_item(seq_item);
 end
endtask
endclass 

class FIFO_reset_sequence extends uvm_sequence #(FIFO_seq_item);
 `uvm_object_utils(FIFO_reset_sequence)
 FIFO_seq_item seq_item;
  
function new(string name = "FIFO_reset_sequence");
  super.new(name);
endfunction

task body;
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    start_item(seq_item);
    seq_item.rst_n=0;
    seq_item.data_in=0;
    seq_item.wr_en=0;
    seq_item.rd_en=0;
    finish_item(seq_item);
endtask
endclass 

class FIFO_write_sequence extends uvm_sequence #(FIFO_seq_item);
 `uvm_object_utils(FIFO_write_sequence)
 FIFO_seq_item seq_item;
  
function new(string name = "FIFO_write_sequence");
  super.new(name);
endfunction

task body;
 repeat(20) begin
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    start_item(seq_item);
    seq_item.rst_n=1;
    seq_item.data_in=$random;
    seq_item.wr_en=1;
    seq_item.rd_en=0;
    finish_item(seq_item);
 end
endtask
endclass 

class FIFO_read_sequence extends uvm_sequence #(FIFO_seq_item);
 `uvm_object_utils(FIFO_read_sequence)
 FIFO_seq_item seq_item;
  
function new(string name = "FIFO_read_sequence");
  super.new(name);
endfunction

task body;
 repeat(20) begin
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    start_item(seq_item);
    seq_item.rst_n=1;
    seq_item.data_in=$random;
    seq_item.wr_en=0;
    seq_item.rd_en=1;
    finish_item(seq_item);
 end
endtask
endclass 

endpackage