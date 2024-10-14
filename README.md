# UVM_FIFO-Verification
verifying  the synchronous FIFO using full UVM environment
![image](https://github.com/user-attachments/assets/8f5cfc80-bf13-4785-b242-2da1f07221d7)

1. DUT (Device Under Test):
•	The FIFO module defines the FIFO functionality.
•	It has parameters for FIFO width (FIFO_WIDTH) and depth (FIFO_DEPTH).
•	It uses internal registers (mem) to store data.
•	It has separate wr_ptr (write pointer) and rd_ptr (read pointer) to track data location.
•	Two always_comb blocks handle write and read operations, updating pointers and flags (wr_ack, overflow, underflow, full, empty, almostfull, almostempty).
2. SVA Assertions (SVA.sv):
•	This module contains assertions to verify the DUT's behavior.
•	It checks the flags (full, empty, almostfull, almostempty) based on the internal counter (count).
•	It uses properties to verify write acknowledgement (wr_ack), overflow (overflow), underflow (underflow), counter increment (assert_cnt_inc), and decrement (assert_cnt_dec).
•	It uses covergroups to record coverage for these assertions.
3. Top Level (TOP.sv):
•	This module instantiates the FIFO DUT and the SVA assertion module.
•	It creates a clock signal and binds the DUT interface (f_if) to the SVA assertions.
•	It runs a test named "fifo_test" defined in the fifo_test_pkg package.
4. Test Sequence Package (fifo_test_pkg.sv):
•	This package defines classes for the test sequence and environment.
•	The fifo_test class inherits from uvm_test.
•	It creates objects for environment (env_test), configuration (fifo_config_obj_test), sequencer (sqr), driver (drv), monitor (mon), and analysis port (agt_ap).
•	The build_phase connects these objects based on configurations obtained from the UVM config database.
•	The run_phase resets the DUT, runs different test sequences (rst_seq, wr_only_seq, rd_only_seq, main_seq), and raises/drops objections during the sequence execution.
5. FIFO Agent (fifo_agt.sv):
•	This class represents the agent that drives the DUT.
•	It contains objects for the sequencer (sqr), driver (drv), monitor (mon), and analysis port (agt_ap).
•	It connects these objects based on configurations obtained during the build phase.



6. FIFO Monitor (fifo_mon.sv):
•	This class monitors the DUT's interface signals.
•	In the run_phase, it samples the interface signals (rst_n, wr_en, rd_en, data_in, data_out, wr_ack, overflow, underflow, full, empty, almostfull, almostempty) at every falling edge of the clock and creates a fifo_seq_item object containing these values.
•	It broadcasts the fifo_seq_item object to the coverage collector and scoreboard using the analysis port (mon_ap).
7. Coverage Collector (cvrgclctr.sv):
•	This class collects coverage information about the DUT's behavior.
•	It defines a covergroup (cg) and coverpoints for various input and output signals.
•	It uses cross-coverage to capture interactions between different signals (e.g., wr_enable and wr_ack).
•	It samples the received fifo_seq_item and updates the covergroup.
8. Scoreboard (scoreboard_pkg.sv):
•	This class acts as a reference model for the DUT.
•	It maintains its own internal state (count, data_out_ref, flags) to compare with the DUT's behavior.
•	The reference model function emulates the DUT's behavior based on the received fifo_seq_item.
•	It compares the DUT's data output (data_out) and flags with its reference model and reports errors if there are any mismatches.
Overall Workflow:
1.	The testbench instantiates the DUT and SVA assertions.
2.	It runs different test sequences through the sequencer and driver.
3.	The driver sends data to the DUT based on the sequence.
4.	The monitor samples the DUT's interface signals and creates a fifo_seq_item 
