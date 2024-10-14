package fifo_agt ;
import  uvm_pkg::*;
import  fifo_driver::*;
import  fifo_sqr::*;
import  fifo_config_obj::*;
import  fifo_mon::*;
import  fifo_seqitem::*;

`include"uvm_macros.svh"


class fifo_agent extends uvm_agent;

`uvm_component_utils(fifo_agent)
  
fifo_sequencer sqr;
fifo_driver drv;
fifo_config_obj agt_cnfg;
fifo_monitor mon ;

uvm_analysis_port #(fifo_seq_item) agt_ap ;

function new (string name ="fifo_agent" , uvm_component parent = null);
super.new(name,parent);
endfunction



function void build_phase (uvm_phase phase);
super.build_phase(phase);

if (!uvm_config_db #(fifo_config_obj)::get(this ,"","CFG",agt_cnfg))
`uvm_fatal("build_phase","AGENT - unable to get the virtual interface  set by the test  of fifo from the uvm_config_db");

sqr = fifo_sequencer::type_id::create("sqr",this);
drv = fifo_driver::type_id::create("drv",this);
mon = fifo_monitor::type_id::create("mon",this);
agt_ap = new ("agt_ap" ,this) ;

endfunction

function void connect_phase (uvm_phase phase) ;
super.connect_phase (phase) ;
drv.fifo_driver_vif = agt_cnfg.fifo_config_vif ;
mon.fifo_mon_vif = agt_cnfg.fifo_config_vif ;
drv.seq_item_port.connect(sqr.seq_item_export);
mon.mon_ap.connect(agt_ap) ;

endfunction


endclass


endpackage