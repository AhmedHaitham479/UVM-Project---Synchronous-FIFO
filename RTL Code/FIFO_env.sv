package FIFO_env_pkg;
import uvm_pkg::*;
import agent_pkg::*;
import Coverage_pkg::*;
import Scoreboard_pkg::*;
`include "uvm_macros.svh"
class FIFO_env extends uvm_env;
  `uvm_component_utils(FIFO_env); 

FIFO_agent agt;
FIFO_Scoreboard sb;
FIFO_Coverage cov;

function new(string name = "FIFO_env" , uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 agt = FIFO_agent::type_id::create("agt",this);
 sb = FIFO_Scoreboard::type_id::create("sb",this);
 cov = FIFO_Coverage::type_id::create("cov",this);
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  agt.agt_ap.connect(sb.sb_export);
  agt.agt_ap.connect(cov.cov_export);
endfunction

endclass
endpackage 
 