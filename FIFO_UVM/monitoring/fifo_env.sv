package fifo_env ;
import  uvm_pkg::*;
import  fifo_agt::*;
import  cvrgclctr::*;
import  scoreboard_pkg::*;

`include"uvm_macros.svh"

class fifo_env extends uvm_env ;

`uvm_component_utils(fifo_env)

fifo_agent agt;
FIFO_scoreboard sb ;
fifo_cvrg cov;


function new (string name ="fifo_env" , uvm_component parent = null);
super.new(name,parent);
endfunction


function void build_phase (uvm_phase phase);
super.build_phase(phase);
agt = fifo_agent::type_id::create("agt",this);
sb = FIFO_scoreboard::type_id::create("sb",this);
cov = fifo_cvrg::type_id::create("cov",this);

endfunction

function void connect_phase (uvm_phase phase);
super.connect_phase(phase);
agt.agt_ap.connect(sb.sb_export);
agt.agt_ap.connect(cov.cov_export);
endfunction

endclass
endpackage