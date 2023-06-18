function buffer = generator(t_end, dt, rate, lambda_ipc)
% Generate ETSI Bursty Packet Data Traffic

% Parameters for simulation
%t_end = 10000; % time for the end of simulation (sec)
%dt = 10^(-3); % unit of simulation time (sec)
%rate = 32*10^3; % transmission rate (byte/sec)
rate_dt = rate * dt; % transmission in a dt (byte/dt)

buffer = zeros(ceil(t_end/dt), 4); % [1. time | 2. size | 3. packet call id | 4. packet call end]
num_to_receive = 0;

% Parameters for idle time
lambda_is = 1/2000; %(1/sec) %temp change
%lambda_ipc = 1/30; %(1/sec)
lambda_ip = 10; %(1/sec)

% Parameters for number
mu_pc = 5; 
mu_p = 25; 

% Parameters for packet size
packet_size_low = 81.5; %(byte) lower bound / scale parameter
packet_size_high = 66666; %(byte) upper bound
packet_size_beta = 1.1; % shape parameter

%t_is = exprnd(1/lambda_is); % inter-session idle time (sec)
%t_ipc = exprnd(1/lambda_ipc); % inter-packet call idle time (sec)
%t_ip = exprnd(1/lambda_ip); % inter-packet idle time (sec)

%N_pc = 1 + geornd(1/mu_pc); % number of packet call per session
%N_p = 1 + geornd(1/mu_p); % number of packet per packet call

%S_d = t_pareto_rnd(packet_size_low, packet_size_high, packet_size_beta, 1); % packet size (byte)

t = 0;

while t < t_end
    % Session start
    N_pc = 1 + geornd(1/mu_pc); % number of packet call in this session
    N_p = 1 + geornd(1/mu_p, N_pc, 1); 
    for pc_id = 1:N_pc % packet call start
        S_d = t_pareto_rnd(packet_size_low, packet_size_high, packet_size_beta, N_p(pc_id));
        S_d = ceil(S_d*100)*0.01;
        num_of_sending = ceil(S_d/(rate * dt));
        for p_id = 1:N_p(pc_id) % packet start
            for i = 1:num_of_sending(p_id)-1 
                num_to_receive = num_to_receive + 1;
                to_buffer = [t rate_dt pc_id 0]; 
                % buffer = [buffer; to_buffer]; % DON'T do this again
                buffer(num_to_receive,:) = to_buffer;
                t = t + dt;       
            end
            num_to_receive = num_to_receive + 1;
            remain_part = S_d(p_id) - (num_of_sending(p_id) - 1) * rate_dt;
            to_buffer = [t remain_part pc_id 0];
            buffer(num_to_receive,:) = to_buffer;
            t = t + dt;
            t_ip = ceil(exprnd(1/lambda_ip) / dt) * dt; % inter-packet idle time (sec)
            t = t + t_ip;     
        end % packet end
        t_ipc = ceil(exprnd(1/lambda_ipc) / dt) * dt; % inter-packet call idle time (sec)
        t = t + t_ipc - t_ip;
        buffer(num_to_receive, 4) = 1;
    end % packet call end

    % wait for next session
    t_is = ceil(exprnd(1/lambda_is) / dt) * dt;
    t = t + t_is - t_ipc;
end
buffer(num_to_receive+1:ceil(t_end/dt), :) = [];

end

