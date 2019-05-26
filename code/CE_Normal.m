%use coordinate exchange to optimize the discrepancy

function [low_discNormal,normaldisc] = CE_Normal(x)

delta = 0.01;
maxrun = 50;
count = 0;
opt_delta=-1;

while opt_delta< -1*10^(-10) && count<maxrun
    [x,opt_delta] = coordinate_exchange(x);
    count = count+1;
    normaldisc = normal_multidiscrepancy(x);
end

low_discNormal=x;


end






