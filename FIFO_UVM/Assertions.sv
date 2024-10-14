module SVA (fifo_interface.DUT f_if) ;



always_comb begin ;
	if(DUT.count == f_if.FIFO_DEPTH) 
	assert_full : assert (f_if.full==1);
    
	if (DUT.count == 0)
	assert_empty : assert (f_if.empty == 1) ;

	if (DUT.count == f_if.FIFO_DEPTH-1)
	assert_almostfull : assert (f_if.almostfull ==1 ) ;

	if (DUT.count == 1)
	assert_almostempty : assert (f_if.almostempty == 1) ;
end

property  assert_wr_ack;
@(posedge f_if.clk)  disable iff(!f_if.rst_n)  (f_if.wr_en && DUT.count < f_if.FIFO_DEPTH) |=> (f_if.wr_ack ) ; //##
endproperty

property  assert_overflow ;
@(posedge f_if.clk)  disable iff(!f_if.rst_n)  (f_if.full &&  f_if.wr_en) |=> (f_if.overflow ) ;
endproperty

property  assert_underflow ;
@(posedge f_if.clk)  disable iff(!f_if.rst_n)  (f_if.empty && f_if.rd_en) |=> (f_if.underflow ) ;
endproperty

property  assert_cnt_inc ;
@(posedge f_if.clk)  disable iff(!f_if.rst_n)  (f_if.wr_en && !f_if.rd_en && !f_if.full) |=> (DUT.count == $past(DUT.count) + 1 ) ;
endproperty

property  assert_cnt_dec ;
@(posedge f_if.clk)  disable iff(!f_if.rst_n)  (!f_if.wr_en && f_if.rd_en && !f_if.empty) |=> (DUT.count == $past(DUT.count) - 1 ) ;
endproperty


assert_wr_ack_flag :assert property(assert_wr_ack);
assert_of_flag :assert property(assert_overflow);
assert_un_flag :assert property(assert_underflow);
assert_cnt_increment :assert property(assert_cnt_inc);
assert_cnt_decrement :assert property(assert_cnt_dec);


always_comb begin ;
	if(DUT.count == f_if.FIFO_DEPTH) 
	cover_full : cover (f_if.full==1);
    
	if (DUT.count == 0)
	cover_empty : cover (f_if.empty == 1) ;

	if (DUT.count == f_if.FIFO_DEPTH-1)
	cover_almostfull : cover (f_if.almostfull ==1 ) ;

	if (DUT.count == 1)
	cover_almostempty : cover (f_if.almostempty == 1) ;
end

cover_wr_ack_flag :cover property(assert_wr_ack);
cover_of_flag :cover property(assert_overflow);
cover_un_flag :cover property(assert_underflow);
cover_cnt_increment :cover property(assert_cnt_inc);
cover_cnt_decrement :cover property(assert_cnt_dec);


endmodule