ps = [];
d = [];
for i = 1:100
    result = main(2,10,2,10,3600);
    if ~isnan(result(2))
        ps(end+1) = result(1);
        d(end+1) = result(2);
    end
end

meanps = mean(ps);
meand = mean(d);