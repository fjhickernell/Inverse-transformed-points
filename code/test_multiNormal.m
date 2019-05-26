function test_multiNormal

%start with grid

d = 2;
s = 10; %sample size on each dimension
N = s^2; %total sample size
unigrid_sample = (combvec((1:2:2*s-1)/(2*s),(1:2:2*s-1)/(2*s)))'; %change this line to construct grid sample with a different dimension
grid_sample = norminv(unigrid_sample);

grid_normDisc = normal_multidiscrepancy(grid_sample)

rand_normDisc = zeros(1000,1);
for i = 1:1000
    rand_sample = randn(N,d);
    rand_normDisc(i) = normal_multidiscrepancy(rand_sample);
end
averand_normDisc = mean(rand_normDisc)



end


