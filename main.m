function [result,result2,result3] = main(T_ds,T_dl,T_i,T_n) %Parameters
tic
state = 0;
wake = 0;
sleep = 0;
total_time = 0;
total_sleep = 0;
tt = 0;

dt = 10^(-3); % unit of simulation time (sec)

buffer = zeros(1,4);  %This matrix record the size and generated time of data stored in the buffer!
delay = []; %An array record every delay of packet calls
packet_call_end = true;
ti = T_i/dt;
T_dl = T_dl/dt;
T_ds = T_ds/dt;
T_n = T_n/dt;

result = zeros(1,6);%temp!
t_end = 100;
rate = 32*10^3;

ETSI_generate_result = generator(t_end, dt, rate); %In this simulation, the ETSI Bursty Packet Data Traffic is generated in advanced!
index = 1; %This variable record the row in the generator we is using now.
t_now = 0; %This variable record the simulation time.
t_end = t_end/dt;

%0: active 1: light sleep 2: deep sleep
for t = 1:t_end
    %Put data into buffer
    total_time = total_time+1;
    %ETSI_generate_result(index,1)
    %t_now
    buffer_size = size(ETSI_generate_result);
    if index < buffer_size(1)
        if abs(ETSI_generate_result(index,1)-t_now)< 1e-7
            packet_generated = ETSI_generate_result(index,:);
            packet_generated(1) = [];
            index = index+1;
        else
            packet_generated = [0 0 0];
        end
    else
        packet_generated = [0 0 0];
    end

    if packet_generated(1) > 0

        if packet_generated(3) == 1
            packet_call_end = true;
        else
            packet_call_end = false;
        end

        if buffer(1,2) == 0 %buffer is empty
            buffer(1,1) = total_time;
            buffer(1,2) = packet_generated(1);
            buffer(1,3) = packet_generated(2);
            buffer(1,4) = packet_generated(3);
        else
            buffer(end+1,1) = total_time;
            buffer(end,2) = packet_generated(1);
            buffer(end,3) = packet_generated(2);
            buffer(end,4) = packet_generated(3);
        end
    end

    %---------------test block---------------------------------------------
    %disp("index: "+index)
    %disp(t_now+": "+state)
    %disp(packet_generated)
    if packet_generated(1) > 0
        result(end+1,1) = t_now;
        result(end,2) = state;
        result(end,3) = index;
        result(end,4) = packet_generated(1);
        result(end,5) = packet_generated(2);
        result(end,6) = packet_generated(3);
    end
    %if total_time>50
     %   error('end')
    %end
%     if packet_generated(1) ~= 0 && state ~= 0
%         if tt == 0
%             tt = t_now;
%             bb = buffer; 
%         end
%     end
    %----------------------------------------------------------------------
    switch state
        case 0
            if buffer(1,2) > 0 %buffer is not empty
                ti = T_i;
                Size = size(buffer);
                if Size(1) > 1 %buffer includes more than 1 unit of data                    
                    if buffer(1,4) == 1
                        delay(end+1) = total_time-buffer(1,1); %Calculate delay
                    end
                    if buffer(1,2) == 32
                        buffer(1,:) = []; %clear the buffer
                    else
                        remain = buffer(end,2); %in an unit time, 32bytes of data will be cleared!
                        buffer(1,:) = []; %clear the buffer
                        buffer(1,2) = remain;
                    end
                else      
                    if buffer(end,4) == 1
                        delay(end+1) = total_time-buffer(1,1); %Calculate delay
                    end
                    buffer(1,:) = 0; %clear the buffer
                end
            else
                ti = ti-1;
            end
            wake = wake+1;           
            if ti == 0 && packet_call_end == true %%The receiver cannot sleep until the current packet call is finished.
                state = 1;
            end
        case 1
            [state, sleep] = light_sleep(sleep, T_ds, T_n, buffer);
            total_sleep = total_sleep + 1;
        case 2
            [state, sleep] = deep_sleep(sleep, T_dl, buffer);
            total_sleep = total_sleep + 1;
    end
    t_now = t_now+dt;
end

PS = total_sleep/(wake+total_sleep);
D = mean(delay)*dt;
%result = [PS D]; %PS: power saving vector, D: wake up delay

result2 = ETSI_generate_result;
result3 = [PS,D];
toc