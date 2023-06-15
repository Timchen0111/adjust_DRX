function result = main(T_ds,T_dl,T_i,T_n) %Parameters
state = 0;
wake = 0;
sleep = 0;
buffer = 0; %This variable record the size of data stored in the buffer!
%0: active 1: light sleep 2: deep sleep
for t = 1:10000 %may be change!
    switch state
        case 0
            if buffer>0
                ti = Ti;
                if biffer > 32
                    buffer = buffer-32;
                else
                    buffer = 0;
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

