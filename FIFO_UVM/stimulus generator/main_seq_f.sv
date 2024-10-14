package main_seq;
import uvm_pkg::*;
import fifo_seqitem::*;
`include "uvm_macros.svh"
class fifo_main_seq extends uvm_sequence #(fifo_seq_item);
`uvm_object_utils(fifo_main_seq);

fifo_seq_item seq_item ;

function new(string name ="fifo_main_seq");
super.new(name);
endfunction 


task body;
repeat (10000) begin 
seq_item = fifo_seq_item::type_id::create("seq_item");
start_item(seq_item);

assert(seq_item.randomize());

finish_item(seq_item);
end
endtask
endclass 




endpackage