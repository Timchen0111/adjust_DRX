% Demonstrate how to use generator.m

t_end = 10000; % time for the end of simulation (sec)
dt = 10^(-3); % unit of simulation time (sec)
rate = 32*10^3; % transmission rate (byte/sec)

buffer = generator(t_end, dt, rate);
    