function result = main(T_ds,T_dl,T_i,T_n) %Parameters
state = 0;
wake = 0;
sleep = 0;
total_time = 0;

buffer = zeros(1,4);  %This matrix record the size and generated time of data stored in the buffer!

%0: active 1: light sleep 2: deep sleep
for t = 1:10000 %may be change!
    %Put data into buffer
    total_time = total_time+1;
    if packet_generator > 0
        if buffer(1,2) == 0 %buffer is empty
            buffer(1,1) = total_time;
            buffer(1,2) = packet_generator(1);
            buffer(1,3) = packet_generator(2);
            buffer(1,4) = packet_generator(3);
        else
            buffer(end+1,1) = total_time;
            buffer(end+1,2) = packet_generator(1);
            buffer(end+1,3) = packet_generator(2);
            buffer(end+1,4) = packet_generator(3);
        end
    end
    switch state
        case 0
            if buffer(1,2) > 0 %buffer is not empty
                ti = Ti;
                Size = size(buffer);
                if Size(1) > 1 %buffer includes more than 1 unit of data
                    %Calculate delay
                    if buffer(end,2) == 32
                        buffer(end,:) = []; %clear the buffer
                    else
                        remain = buffer(end,2); %in an unit time, 32bytes of data will be cleared!
                        buffer(end,:) = []; %clear the buffer
                        buffer(end,2) = remain;
                    end
                else
                    %Calculate delay           
                    buffer(1,:) = 0; %clear the buffer
                end
            else
                ti = ti-1;
            end
            wake = wake+1;           
            if ti == 0
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
result = [PS,D]; %PS: power saving vector, D: wake up delay
