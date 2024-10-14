package fifo_test_pkg ;
import  uvm_pkg::*;
import  fifo_env::*;
import  fifo_config_obj::*;
import  main_seq::*;
import  rd_only_seq_f::*;
import  wr_only_seq_f::*;
import  rst_seq_f::*;

`include"uvm_macros.svh"

class fifo_test extends uvm_test ;

`uvm_component_utils(fifo_test)
//object declration
fifo_env env_test;
fifo_config_obj fifo_config_obj_test ;
virtual fifo_interface fifo_test_vif ; 
fifo_reset_seq  rst_seq;
fifo_wr_only_seq wr_only_seq;
fifo_rd_only_seq rd_only_seq;
fifo_main_seq    main_seq ;


//constructs the class
function new (string name ="fifo_test" , uvm_component parent = null);
super.new(name,parent);
endfunction

//build_phase
function void build_phase (uvm_phase phase) ;
super.build_phase(phase) ;

env_test =fifo_env::type_id::create("env_test",this) ;
fifo_config_obj_test = fifo_config_obj::type_id::create("fifo_config_obj_test");
rst_seq = fifo_reset_seq::type_id::create("rst_seq");
wr_only_seq = fifo_wr_only_seq::type_id::create("wr_only_seq");
rd_only_seq = fifo_rd_only_seq::type_id::create("rd_only_seq");
main_seq = fifo_main_seq::type_id::create("main_seq");

if (!uvm_config_db #(virtual fifo_interface) :: get(this ,"","FIFO_IF",fifo_config_obj_test.fifo_config_vif))
`uvm_fatal("build_phase","TEST - unable to get the virtual interface of the  fifo from the uvm_config_db");

uvm_config_db #(fifo_config_obj)::set (this ,"*","CFG",fifo_config_obj_test); 
endfunction

//remember test is the intellegent boy who knows which seq opens to which sqr 
task run_phase (uvm_phase phase) ;
super.run_phase(phase);
phase.raise_objection(this);

`uvm_info("run_phase","reset asserted",UVM_LOW)
rst_seq.start(env_test.agt.sqr) ;
`uvm_info("run_phase","reset deasserted",UVM_LOW) 

`uvm_info("run_phase","write only seq is asserted",UVM_LOW)
wr_only_seq.start(env_test.agt.sqr) ;
`uvm_info("run_phase","write only seq is deasserted",UVM_LOW) 

`uvm_info("run_phase","read only seq is asserted",UVM_LOW)
rd_only_seq.start(env_test.agt.sqr) ;
`uvm_info("run_phase","read only seq is deasserted",UVM_LOW) 

`uvm_info("run_phase"," randomized stimulus generation started",UVM_LOW)
main_seq.start(env_test.agt.sqr) ;
`uvm_info("run_phase","stimulus generation finished",UVM_LOW)
phase.drop_objection(this);

endtask

endclass
endpackage



