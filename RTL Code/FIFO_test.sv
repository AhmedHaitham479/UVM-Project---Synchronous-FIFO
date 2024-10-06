package FIFO_test_pkg;
import uvm_pkg::*;
import FIFO_env_pkg::*; 
import FIFO_driver_pkg::*;
import FIFO_config_pkg::*;
import sequence_pkg::*;
`include "uvm_macros.svh"

class FIFO_test extends uvm_test;
`uvm_component_utils(FIFO_test)

FIFO_env env;
virtual FIFO_if FIFO_vif;
FIFO_config_obj FIFO_config_obj_test;
FIFO_main_sequence main_seq;
FIFO_reset_sequence reset_seq;
FIFO_write_sequence write_seq;
FIFO_read_sequence read_seq;

function new(string name = "FIFO_test" , uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 env = FIFO_env::type_id::create("env",this);
 FIFO_config_obj_test = FIFO_config_obj::type_id::create("FIFO_config_obj_test",this); 
 main_seq = FIFO_main_sequence::type_id::create("main_seq",this); 
 reset_seq = FIFO_reset_sequence::type_id::create("reset_seq",this); 
 write_seq = FIFO_write_sequence::type_id::create("write_seq",this);
 read_seq = FIFO_read_sequence::type_id::create("read_seq",this);
 
 if(!uvm_config_db #(virtual FIFO_if)::get(this,"","FIFO_if",FIFO_config_obj_test.FIFO_vif ))
   `uvm_fatal("build_phase", "Test - unable to get the virtual interface of the FIFO from the uvm_config_db");

 uvm_config_db #(FIFO_config_obj)::set(this, "*", "CFG", FIFO_config_obj_test);
endfunction

task run_phase(uvm_phase phase);
 super.run_phase(phase);
 phase.raise_objection(this);
 //
 `uvm_info("run_phase","reset Asserted", UVM_LOW)
 reset_seq.start(env.agt.sqr);
 `uvm_info("run_phase","reset Deasserted", UVM_LOW)
 //
 `uvm_info("run_phase","full write operation started", UVM_LOW)
 write_seq.start(env.agt.sqr);
 `uvm_info("run_phase","full write operation  ended", UVM_LOW)
 //
 `uvm_info("run_phase","full read operation  started", UVM_LOW)
 read_seq.start(env.agt.sqr);
 `uvm_info("run_phase","full read operation  ended", UVM_LOW)
 //
 `uvm_info("run_phase","Stimulus Generation started", UVM_LOW)
 main_seq.start(env.agt.sqr);
 `uvm_info("run_phase","Stimulus Generation ended", UVM_LOW)
 phase.drop_objection(this);
endtask
endclass 
endpackage
