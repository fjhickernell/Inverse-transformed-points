%calculate the distance |x_j-x'_j| matrix of each dimension of each pair of points in a sample
%input: x - Nxd matrix with N points and dimension d
%output: D - Nx(dN) [D_1|D_2|...|D_N], with D_i = [|x_i1-x_11|,...,|x_id-x_1d|;....;|x_i1-x_N1|,...,|x_id-x_Nd|]

function [D] = Distance_Matrix(x)

d = size(x,2);
N = size(x,1);

D = zeros(N,d*N);

for i = 1:N
    D(:,((i-1)*d+1): (i*d)) = abs(bsxfun(@minus, x(i,:), x));
end
end
