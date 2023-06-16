function result = main(T_ds,T_dl,T_i,T_n) %Parameters
state = 0;
wake = 0;
sleep = 0;
total_time = 0;
buffer = zeros(1,4);  %This matrix record the size and generated time of data stored in the buffer!
delay = []; %An array record every delay of packet calls
packet_call_end = true;

ti = T_i;
%0: active 1: light sleep 2: deep sleep
for t = 1:10000 
    %Put data into buffer
    total_time = total_time+1;
    packet_generated = packet_generator(); 
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
            buffer(end+1,2) = packet_generated(1);
            buffer(end+1,3) = packet_generated(2);
            buffer(end+1,4) = packet_generated(3);
        end
    end
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
                tds = T_ds;
                tn = T_n;
            end
        case 1
            light_sleep()
        case 2
            deep_sleep()
    end
end
PS = sleep/(wake+sleep);
D = mean(delay);
result = [PS,D]; %PS: power saving vector, D: wake up delay

