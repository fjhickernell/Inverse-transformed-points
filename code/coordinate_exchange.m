function [x,opt_delta] = coordinate_exchange(x)

N = size(x,1); %number of points
d = size(x,2); %dimension

temp_x = x';

c = @(a) 1+1/sqrt(2*pi)+1/2*abs(a)-a*(normcdf(a)-1/2)-normpdf(a);
h = @(a,b) 1+1/2*abs(a)+1/2*abs(b)-1/2*abs(a-b);

c_mat = arrayfun(c,x); %function c evaluated all elements of x;

%[(h_mat)_1;(h_mat)_2;...;(h_mat)_N], with (h_mat)_i as a Nxd matrix = [h(x_i1,x_11),...,h(x_id,x_1d);....;h(x_i1,x_N1),...,h(x_id,x_Nd)]
h_mat = zeros(N^2,d); %function h(x_ij,x_rj) for i,r=1,...,N,j=1,...,d.
D = zeros(N,N*d); %distance matrix

for i = 1:N
    D(:,((i-1)*d+1): (i*d)) = abs(bsxfun(@minus, x(i,:), x));
end

h_mat = (reshape((1+1/2*abs(repmat((temp_x(:))',N,1))+ 1/2*abs(repmat(x,1,N))-1/2*abs(D))',d,N*N))';

row_deletion = -2*prod(c_mat,2)+(N-1)*(2*sum(reshape(prod(h_mat,2),N,N)',2)-prod((1+abs(x)),2));

col_deletion = zeros(d,1);
for j = 1:d
    c_new = zeros(N,d);
    h_new = zeros(N^2,d);
    c_new = c_mat;
    c_new(:,j) = c_mat(:,j)-1;
    h_new = h_mat;
    h_new(:,j) = h_mat(:,j)-1;
    col_deletion(j) = -2*sum(prod(c_new,2))+1/N*sum(prod(h_new,2));
end

[opt_rowde,row_choice] = max(row_deletion);
[opt_colde,col_choice] = max(col_deletion);

change_row = x(row_choice,:);
change_point = change_row(col_choice);
change_col = x(:,col_choice);
change_col(row_choice) = [];
change_row(col_choice) = [];
h_change = h_mat((row_choice-1)*N+2:row_choice*N,:);
h_change(:,col_choice) = [];

h_prime = @(z) h(z,change_col);
delta_function = @(y) 2*(c(change_point)-c(y))*prod(arrayfun(c,change_row))-1/N*(2*sum((h_prime(change_point)-h_prime(y)).*prod(h_change,2))+(abs(change_point)-abs(y))*prod(1+abs(change_row)));
[opt_value,opt_delta] = fminsearch(delta_function,change_point);
if opt_delta< -1*10^(-10)
    x(row_choice,col_choice) = opt_value;
end



end
