import uvm_pkg::*; 
import fifo_test_pkg::*;

`include "uvm_macros.svh" 
module TOP ();

bit clk ;
initial 
begin
    clk =0 ;
    forever  begin 
    #10 ; 
    clk =~clk ;
    end
end

fifo_interface  f_if(clk);
FIFO  DUT  (f_if);

bind FIFO SVA sva_asserstion(f_if);

initial 
begin 
    uvm_config_db #(virtual fifo_interface )::set(null, "uvm_test_top","FIFO_IF",f_if) ;
    run_test("fifo_test"); //fifo test class name
end




endmodule