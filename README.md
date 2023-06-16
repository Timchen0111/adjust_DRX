# Generate ETSI Bursty Packet Data Traffic
 [Introduction to Wireless and Mobile Networking Final project]

## Synopsis
 `generator.m`: the main program to generate ESTI bursty packet data traffic.
 
 `t_pareto_rnd.m`: the function returning a series of random numbers following i.i.d truncated Pareto random variables.

## how to run
 call generator.m at the beginning of the main simulation program (**not** in the simulation loop!!!)
### To be returned
 `buffer`: an $(n\times4)$ double, containing the following information:
 
 |  1.  |  2.  |       3.       |        4.       |
 | ---- | ---- | -------------- | --------------- |
 | time | size | packet call id | packet call end |
 
 `num_to_receive`: total number of data needed to be received from the buffer.
### Some parameters may need to be modified
 `t_end`: the end time of this simulation (sec)
 
 `dt`: unit of simulation time (sec)
 
 `rate`: transmission rate (byte/sec)
