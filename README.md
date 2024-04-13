# CHACHA20-encryption-on-hardware
Implementation of CHACHA20 encryption method on hardware (BASYS3 FPGA board), with UART interface.
##################################################################################################

The implementation is done on BASYS3 board. The idea implemented is, to store the encrypted ASCII 
data in a memory inside the FPGA. And the given inputs in from the system is looped back into the 
serial port. 

Also the ILA can give the runtime key that is getting generated.

##################################################################################################

Requirements:
1. Need two MMCM IP for 5 MHZ clock and 6 MHz clock.
2. Need an IP of ILA (integrated logic analyzer) for showing 512 bit output.
