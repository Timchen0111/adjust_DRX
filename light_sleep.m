function [ret_state,ret_sleep_time] = light_sleep(sleep_time, T_ds, T_n, buffer)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    sleep_time = sleep_time + 1;
    if (mod(sleep_time, T_ds) == 0)
        if (buffer(1, 2) > 0)
            %disp(buffer)
            ret_state = 0;
            ret_sleep_time = 0;
            return
        end
    end

    if (sleep_time == T_n)
        ret_state = 2;
        ret_sleep_time = 0;
        return
    end
    
    ret_state = 1;
    ret_sleep_time = sleep_time;
end