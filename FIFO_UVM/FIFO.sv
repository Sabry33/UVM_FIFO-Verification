////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(fifo_interface.DUT f_if);

localparam max_fifo_addr = $clog2(f_if.FIFO_DEPTH);
reg [f_if.FIFO_WIDTH-1:0] mem [f_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count; //it has the same bits as the depth so we can equl them

//always block for write process and overflow calculations
always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		wr_ptr <= 0;
		f_if.wr_ack <= 0 ;
		f_if.overflow <= 0 ;
	end
	else if (f_if.wr_en && count < f_if.FIFO_DEPTH) begin //when fifo is full and wr_en and rd_en are high the read process takes place due to this if condition
		mem[wr_ptr] <= f_if.data_in;
		f_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		f_if.wr_ack <= 0; 
		if (f_if.full && f_if.wr_en)
			f_if.overflow <= 1;
		else
			f_if.overflow <= 0;
	end
end
//always block for read process and  underflow flag
always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		rd_ptr <= 0;
		f_if.data_out <= 0 ;
		f_if.underflow <= 0 ;
	end
	else if (f_if.rd_en && count != 0) begin  //when fifo is empty and wr_en and rd_en are high the write process takes place due to this if condition
		f_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else  begin 
		if(f_if.empty && f_if.rd_en)
		f_if.underflow <= 1 ;
		else 
		f_if.underflow <= 0 ;
	end
end

// always block for evaluating the counter
always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({f_if.wr_en, f_if.rd_en} == 2'b10) && !f_if.full) 
			count <= count + 1;
		else if ( ({f_if.wr_en, f_if.rd_en} == 2'b01) && !f_if.empty)
			count <= count - 1;
		else if (({f_if.wr_en, f_if.rd_en} == 2'b11) && f_if.empty)
		    count <= count + 1;
		else if (({f_if.wr_en, f_if.rd_en} == 2'b11) && f_if.full)
		    count <= count - 1;				
	end
end

assign f_if.full = (count == f_if.FIFO_DEPTH)? 1 : 0;
assign f_if.empty = (count == 0)? 1 : 0;
assign f_if.almostfull = (count == f_if.FIFO_DEPTH-1)? 1 : 0; 
assign f_if.almostempty = (count == 1)? 1 : 0;


endmodule