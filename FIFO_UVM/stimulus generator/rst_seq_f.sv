package rst_seq_f;
import uvm_pkg::*;
import fifo_seqitem::*;
`include "uvm_macros.svh"

class fifo_reset_seq extends uvm_sequence #(fifo_seq_item);
`uvm_object_utils(fifo_reset_seq);
fifo_seq_item seq_item ;

function  new (string name = "fifo_reset_seq");
super.new(name);
endfunction

task body ;
seq_item = fifo_seq_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.rst_n = 0 ;
seq_item.data_out = 0 ;
seq_item.wr_ack = 0 ;
seq_item.overflow = 0 ;
seq_item.underflow = 0 ;
//shold i reset the counter ??...how ??
finish_item(seq_item);

endtask

endclass

endpackage