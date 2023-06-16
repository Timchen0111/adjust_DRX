function [ret_state, ret_sleep_time] = deep_sleep(sleep_time, T_dl, buffer)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    sleep_time = sleep_time + 1;
    if (mod(time, T_dl) == 0)
        if (buffer(1, 2) > 0)
            ret_state = 0;
            ret_sleep_time = 0;
            return
        end
    end
    ret_state = 2;
    ret_sleep_time = sleep_time;
end