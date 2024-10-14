package fifo_mon ;
import  uvm_pkg::*;
import  fifo_seqitem::*;

`include "uvm_macros.svh"

class fifo_monitor extends uvm_monitor ;

`uvm_component_utils(fifo_monitor)

virtual fifo_interface fifo_mon_vif ;
fifo_seq_item  rsp_seq_item;
uvm_analysis_port #(fifo_seq_item) mon_ap ;

function new (string name ="fifo_driver" , uvm_component parent = null);
super.new(name,parent);
endfunction


function  void build_phase (uvm_phase phase) ;
super.build_phase(phase) ;
mon_ap = new ("mon_ap",this);
endfunction


task run_phase (uvm_phase phase) ;
super.run_phase(phase);
forever 
begin 
rsp_seq_item =fifo_seq_item::type_id::create("rsp_seq_item");
@(negedge fifo_mon_vif.clk );  // here the delay shows that each negedge the monitor sends the data to the scoreboard .... not all monitors have the same delay so we use sb_fifo p3 min35

//inputs
rsp_seq_item.rst_n = fifo_mon_vif.rst_n ;
rsp_seq_item.wr_en = fifo_mon_vif.wr_en ;
rsp_seq_item.rd_en = fifo_mon_vif.rd_en ;
rsp_seq_item.data_in = fifo_mon_vif.data_in ;

//outputs 
rsp_seq_item.data_out = fifo_mon_vif.data_out ;
rsp_seq_item.wr_ack = fifo_mon_vif.wr_ack ;
rsp_seq_item.overflow = fifo_mon_vif.overflow ;
rsp_seq_item.underflow = fifo_mon_vif.underflow ;
rsp_seq_item.full = fifo_mon_vif.full ;
rsp_seq_item.empty = fifo_mon_vif.empty ;
rsp_seq_item.almostfull = fifo_mon_vif.almostfull ;
rsp_seq_item.almostempty = fifo_mon_vif.almostempty ;

mon_ap.write (rsp_seq_item); //broadcasting the recieved seq from the interface to the coverage collector and scoreboards

`uvm_info("run_phase",rsp_seq_item.convert2string_stimulus(),UVM_HIGH)
end

endtask

endclass

endpackage