package fifo_driver ;
import uvm_pkg::*;
import fifo_seqitem::*;
`include "uvm_macros.svh"

class fifo_driver extends uvm_driver #(fifo_seq_item) ;

`uvm_component_utils(fifo_driver)
//creating the virtual interface and config_obj handle

virtual fifo_interface fifo_driver_vif ;
fifo_seq_item  stim_seq_item;

function new (string name ="fifo_driver" , uvm_component parent = null);
super.new(name,parent);
endfunction


task run_phase (uvm_phase phase) ;
super.run_phase(phase);
forever 
begin 
stim_seq_item =fifo_seq_item::type_id::create("stim_seq_item");
seq_item_port.get_next_item(stim_seq_item); //request the seq_item from sequencer=====> sequence

fifo_driver_vif.rst_n = stim_seq_item.rst_n;
fifo_driver_vif.wr_en = stim_seq_item.wr_en;
fifo_driver_vif.rd_en = stim_seq_item.rd_en;
fifo_driver_vif.data_in = stim_seq_item.data_in;

@(negedge fifo_driver_vif.clk );
seq_item_port.item_done() ;
`uvm_info("run_phase",stim_seq_item.convert2string_stimulus(),UVM_HIGH)
end

endtask

endclass

endpackage