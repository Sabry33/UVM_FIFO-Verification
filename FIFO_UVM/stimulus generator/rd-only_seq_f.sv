package rd_only_seq_f ;
import uvm_pkg::*;
import fifo_seqitem::*;
`include "uvm_macros.svh"
class fifo_rd_only_seq extends uvm_sequence #(fifo_seq_item);
`uvm_object_utils(fifo_rd_only_seq);

fifo_seq_item seq_item ;

function  new (string name = "fifo_rd_only_seq");
super.new(name);
endfunction

task body ;
repeat (50) begin 
seq_item = fifo_seq_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.rst_n = 1 ;
seq_item.wr_en = 0 ;
seq_item.rd_en = 1 ;
finish_item(seq_item);
end
endtask

endclass

endpackage

