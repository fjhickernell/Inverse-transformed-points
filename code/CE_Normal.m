%use coordinate exchange to optimize the discrepancy

function [low_discNormal,normaldisc] = CE_Normal(x)

maxrun = 200;
count = 0;
flag=1;
delta = 1;


while delta>10^(-15) && count<200
    [x,delta] = coordinate_exchange(x);
    count = count+1;
    normaldisc = normal_multidiscrepancy(x);
end

low_discNormal=x;


end






