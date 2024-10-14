package scoreboard_pkg ;
import uvm_pkg::*;
import sharedpkg::*;
import fifo_seqitem::*;
`include "uvm_macros.svh"

class FIFO_scoreboard extends uvm_scoreboard ;

`uvm_component_utils(FIFO_scoreboard) ;

uvm_analysis_export #(fifo_seq_item) sb_export ;
uvm_tlm_analysis_fifo #(fifo_seq_item)  sb_fifo ;

fifo_seq_item seq_item_sb ;

function new(string name = "FIFO_scoreboard", uvm_component parent = null);
   super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   sb_export = new("sb_export", this);
   sb_fifo = new("sb_fifo", this);
endfunction 


function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   sb_export.connect(sb_fifo.analysis_export);   //this is the internal connection between the fifo and the sb
endfunction 

int count ;
bit [FIFO_WIDTH-1:0]  data_out_ref ;
bit wr_ack_ref, overflow_ref;
bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

bit [6:0] scrbrd_out_flags ;
bit [6:0] dut_out_flags ;
bit [FIFO_WIDTH-1:0] data_q[$] ;


function comb_flags_calc ;
full_ref = ( count == FIFO_DEPTH) ? 1 : 0;
empty_ref = ( count == 0) ? 1 : 0;
almostfull_ref = (count == FIFO_DEPTH - 1) ? 1 : 0;
almostempty_ref = (count == 1) ? 1 : 0;
endfunction

function reference_model ( fifo_seq_item seq_item_chk ) ;

fork
 begin 

if(!seq_item_chk.rst_n) begin 
wr_ack_ref =0 ;
overflow_ref =0;
data_q.delete();
full_ref = 0 ;
almostfull_ref = 0 ; 
end
else if (seq_item_chk.wr_en && count<FIFO_DEPTH ) 
begin 
    data_q.push_back(seq_item_chk.data_in);
    wr_ack_ref =1;
end
else begin 
    wr_ack_ref = 0 ;
    if (full_ref && seq_item_chk.wr_en)
		overflow_ref = 1;
	else
		overflow_ref = 0;
end
end 

begin 
    if(!seq_item_chk.rst_n) begin 
    data_out_ref = 0;
    underflow_ref =0; 
    empty_ref = 0 ;
    almostempty_ref = 0 ; 
    end
    else if (seq_item_chk.rd_en && count != 0)
    data_out_ref = data_q.pop_front();
    else begin 
    if (empty_ref && seq_item_chk.rd_en)
    underflow_ref = 1 ;
    else 
    underflow_ref = 0 ;
    end
end

join
if(!seq_item_chk.rst_n)  
    count = 0 ;
else begin
if	( ({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b10) && !full_ref) 
	count = count + 1;
else if ( ({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b01) && !empty_ref)
	count = count - 1;
else if (({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b11) && empty_ref)
    count = count + 1;
else if (({seq_item_chk.wr_en, seq_item_chk.rd_en} == 2'b11) && full_ref)
		    count = count - 1;				
end
comb_flags_calc();
endfunction


task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
         sb_fifo.get(seq_item_sb);

         reference_model(seq_item_sb);

         scrbrd_out_flags ={wr_ack_ref,overflow_ref,full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref} ;
         dut_out_flags ={seq_item_sb.wr_ack,seq_item_sb.overflow,seq_item_sb.full,seq_item_sb.empty,seq_item_sb.almostfull,seq_item_sb.almostempty,seq_item_sb.underflow} ;

        if (seq_item_sb.data_out !== data_out_ref) begin
            `uvm_error("run_phase", $sformatf("Comparison failed, Transaction received by the DUT:%s While the reference output:%0b", seq_item_sb.convert2string(),data_out_ref));
            error_count++;
         end

        if (dut_out_flags !== scrbrd_out_flags) begin
            `uvm_error("run_phase", $sformatf("Comparison failed, Transaction received by the DUT:%s While the reference output:%0p", seq_item_sb.convert2string(),scrbrd_out_flags));
            error_count++;
        end

         if (seq_item_sb.data_out == data_out_ref && dut_out_flags == scrbrd_out_flags) begin
            `uvm_info("run_phase", $sformatf("Correct fifo out: %s  ", seq_item_sb.convert2string()), UVM_HIGH);
            correct_count++;
         end

      end
endtask 

function void report_phase(uvm_phase phase);
   super.report_phase(phase);
   `uvm_info("report_phase", $sformatf("Total successful transactions: %0d",correct_count), UVM_MEDIUM);
   `uvm_info("report_phase", $sformatf("Total failed transactions: %0d",error_count), UVM_MEDIUM);
endfunction
/*
function check_data ( FIFO_transaction seq_item_sb) ;
reference_model(seq_item_sb);
scrbrd_out_flags ={wr_ack_ref,overflow_ref,full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref} ;
dut_out_flags ={seq_item_sb.wr_ack,seq_item_sb.overflow,seq_item_sb.full,seq_item_sb.empty,seq_item_sb.almostfull,seq_item_sb.almostempty,seq_item_sb.underflow} ;

if (seq_item_sb.data_out !== data_out_ref) begin
$display ("time %0t the output of the design and golden model are not equal",$time);
error_cntr++ ;
end
if (dut_out_flags !== scrbrd_out_flags) begin
$display ("time %0t the output flags of the design and golden model are not equal",$time);
error_cntr++ ;
end
if (seq_item_sb.data_out == data_out_ref && dut_out_flags == scrbrd_out_flags ) begin 
  $display ("time %0t Succedded comarison with data = %0p",$time,data_q);
correct_cntr++ ;  
end
endfunction
*/
endclass
endpackage