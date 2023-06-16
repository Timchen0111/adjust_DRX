function [x] = t_pareto_rnd(x_low, x_high, beta, total_num)
%T_PAREDO_RND Summary of this function goes here
% random number generator of Truncated Pareto Distribution

%   Detailed explanation goes here
% Transformation of a RV by its CDF leads to Unif(0,1).
% Thus, transform Unif(0,1) by inverse CDF.
u = rand(total_num, 1);
x = x_low * (1-u).^(-1/beta);

higher_bound = x_high * ones(total_num, 1);
x = min(x, higher_bound);

end

