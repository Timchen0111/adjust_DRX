function result = main() %Parameters
state = 0;
%0: active 1: light sleep 2: deep sleep
for t = 1:10000 %may be change!
    switch state
        case 0
            active()
        case 1
            light_sleep()
        case 2
            deep_sleep()
    end
end
result = [PS,D]; %PS: power saving vector, D: wake up delay

