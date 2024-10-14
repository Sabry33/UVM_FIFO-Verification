interface fifo_interface(clk);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8; 
input clk ;

logic [FIFO_WIDTH-1:0] data_in,data_out;
logic  rst_n, wr_en, rd_en;
logic  wr_ack, overflow;
logic  full, empty, almostfull, almostempty, underflow;
         

modport DUT (output  data_out, wr_ack,overflow , full, empty, almostfull, almostempty, underflow, 
             input  clk,rst_n, wr_en, rd_en,data_in) ;



endinterface