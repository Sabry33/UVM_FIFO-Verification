package  cvrgclctr ;
import uvm_pkg::*;
import fifo_seqitem::*;
`include "uvm_macros.svh"

class fifo_cvrg extends uvm_component ;

`uvm_component_utils(fifo_cvrg) ;

uvm_analysis_export #(fifo_seq_item) cov_export ;
uvm_tlm_analysis_fifo #(fifo_seq_item)  cov_fifo ;

fifo_seq_item seq_item_cov;

covergroup cg ;
//////coverpoints for input sigs//////
wr_enable_cvp : coverpoint seq_item_cov.wr_en{
    bins wr_en0 ={0};
    bins wr_en1 ={1};
    option.weight =0 ;}
rd_enable_cvp : coverpoint seq_item_cov.wr_en{
    bins rd_en0 ={0};
    bins rd_en1 ={1};
    option.weight =0 ;}

//////coverpoints for output sigs//////
wr_ack_cvp :coverpoint  seq_item_cov.wr_ack{
    bins wr_ak0 ={0};
    bins wr_ak1 ={1};
    option.weight =0 ;}

overf_cvp :coverpoint  seq_item_cov.overflow{
    bins overflow0 ={0};
    bins overflow1 ={1};
    option.weight =0 ;}
    
fl_cvp :coverpoint  seq_item_cov.full{
    bins full0 ={0};
    bins full1 ={1};
    option.weight =0 ;}

mt_cvp :coverpoint  seq_item_cov.empty{
    bins empty0 ={0};
    bins empty1 ={1};
    option.weight =0 ;}

al_f_cvp :coverpoint  seq_item_cov.almostfull{
    bins almostfull0 ={0};
    bins almostfull1 ={1};
    option.weight =0 ;}

al_e_cvp :coverpoint  seq_item_cov.almostempty{
    bins almostempty0 ={0};
    bins almostempty1 ={1};
    option.weight =0 ;}

underf_cvp :coverpoint  seq_item_cov.underflow{
    bins underflow0 ={0};
    bins underflow1 ={1};
    option.weight =0 ;}

cross wr_enable_cvp,rd_enable_cvp,wr_ack_cvp {
    bins wren_ack  = binsof(wr_enable_cvp.wr_en1) && binsof (wr_ack_cvp.wr_ak1) ;
    bins rden_ack  = binsof(wr_enable_cvp.wr_en1) && binsof (wr_ack_cvp.wr_ak1) && binsof (rd_enable_cvp.rd_en1) ;  //must add wr_en because wr_ack wont be 1 unless wr_en is 1 
    option.cross_auto_bin_max = 0 ; 
}

cross wr_enable_cvp,rd_enable_cvp,overf_cvp {
    bins wren_of  = binsof (wr_enable_cvp.wr_en1) && binsof (overf_cvp.overflow1) ;
    bins rden_of =  binsof (rd_enable_cvp.rd_en1) && binsof (overf_cvp.overflow1) ;   //should not happen ???
    option.cross_auto_bin_max = 0 ; 
}

cross wr_enable_cvp,rd_enable_cvp,underf_cvp {
    bins wren_uf  = binsof (wr_enable_cvp.wr_en1) && binsof (underf_cvp.underflow1) ; 
    bins rden_uf =  binsof (rd_enable_cvp.rd_en1) && binsof (underf_cvp.underflow1) ;  
    option.cross_auto_bin_max = 0 ; 
}


cross wr_enable_cvp,rd_enable_cvp,fl_cvp {
    bins wren_f  = binsof (wr_enable_cvp.wr_en1) && binsof (fl_cvp.full1) ; 
    bins rden_f =  binsof (rd_enable_cvp.rd_en1) && binsof (fl_cvp.full1) ;  
    option.cross_auto_bin_max = 0 ; 
}

cross wr_enable_cvp,rd_enable_cvp,mt_cvp {
    bins wren_f  = binsof (wr_enable_cvp.wr_en1) && binsof (mt_cvp.empty1) ; 
    bins rden_f =  binsof (rd_enable_cvp.rd_en1) && binsof (mt_cvp.empty1) ;  
    option.cross_auto_bin_max = 0 ; 
}

cross wr_enable_cvp,rd_enable_cvp,al_f_cvp {
    bins wren_f  = binsof (wr_enable_cvp.wr_en1) && binsof (al_f_cvp.almostfull1) ; 
    bins rden_f =  binsof (rd_enable_cvp.rd_en1) && binsof (al_f_cvp.almostfull1) ;  
    option.cross_auto_bin_max = 0 ; 
}

cross wr_enable_cvp,rd_enable_cvp,al_e_cvp {
    bins wren_f  = binsof (wr_enable_cvp.wr_en1) && binsof (al_e_cvp.almostempty1) ; 
    bins rden_f =  binsof (rd_enable_cvp.rd_en1) && binsof (al_e_cvp.almostempty1) ;  
    option.cross_auto_bin_max = 0 ; 
}

endgroup

function new(string name = "fifo_cvrg", uvm_component parent = null);
   super.new(name, parent);
   cg =new () ;
endfunction

function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   cov_export = new("cov_export", this);
   cov_fifo = new("cov_fifo", this);
endfunction 


function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   cov_export.connect(cov_fifo.analysis_export);
endfunction 

task run_phase(uvm_phase phase);
   super.run_phase(phase);
   forever begin
      cov_fifo.get(seq_item_cov);
      cg.sample();
   end
 endtask


endclass

endpackage