package fifo_seqitem;
import uvm_pkg::*;
import sharedpkg::*;
`include "uvm_macros.svh"

class fifo_seq_item extends uvm_sequence_item ;
`uvm_object_utils(fifo_seq_item);

function new(string name ="fifo_seq_item");
    super.new(name);
endfunction

rand bit [FIFO_WIDTH-1:0] data_in;
rand bit  rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0]  data_out ;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;


////////**********************
function string convert2string();
return $sformatf("%s reset = %0b, wr_en =%0b, rd_en =%0b,data_in = %0b",super.convert2string,rst_n,wr_en,rd_en,data_in);

endfunction

function string convert2string_stimulus();

return $sformatf(" reset = %0b, wr_en =%0b, rd_en =%0b,data_in = %0b",rst_n,wr_en,rd_en,data_in);

endfunction
////////**********************

//constrain block
int RD_EN_ON_DIST = 30  ;
int WR_EN_ON_DIST = 70 ;


constraint rst_cnstrs {
  rst_n dist {1:= 98 , 0 :=2 };  //u should make it enabled more than 1 to make it toggle more than one  
}

constraint wr_enble {
  wr_en dist {1:= WR_EN_ON_DIST , 0 := 100-WR_EN_ON_DIST}; 
}

constraint rd_enable {
  rd_en dist {1:= RD_EN_ON_DIST , 0 := 100-RD_EN_ON_DIST}; 
}

/*
constraint rd_only {
 rd_en = 1 ;
 wr_en = 0 ;
 rst_n = 1 ;
}
constraint wr_only {
 rd_en = 0 ;
 wr_en = 1 ;
 rst_n = 1 ;
}
*/
endclass

endpackage