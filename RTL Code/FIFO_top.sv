import FIFO_test_pkg::*;
import uvm_pkg::*;
import FIFO_driver_pkg::*;
import FIFO_env_pkg::*;
`include "uvm_macros.svh"
module FIFO_top();
 bit clk;

 initial begin
    clk = 0;
    forever
     #1 clk = ~clk;
 end    

 FIFO_if F_if(clk);
 FIFO dut(F_if);
 bind FIFO FIFO_sva FIFO_sva_inst(F_if);

initial begin
  uvm_config_db#(virtual FIFO_if)::set(null, "uvm_test_top","FIFO_if", F_if);
  run_test("FIFO_test");
end

endmodule