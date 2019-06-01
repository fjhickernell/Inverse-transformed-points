function [x,delta] = coordinate_exchange(x)

N = size(x,1); %number of points
d = size(x,2); %dimension

temp_x = x';

c = sqrt(2/pi);
h = @(a) 1/sqrt(2*pi)+1/2*abs(a)-a*(normcdf(a)-1/2)-normpdf(a);
k = @(a,b) 1/2*(abs(a)+abs(b)-abs(a-b));

h_vec = prod((1+arrayfun(h,x)),2); %vector H in the manuscript

%k_tilde: N^2xd matrix, [k(x_1,x_j);k(x_2,x_j);....;k(x_N,x_j)]
k_tilde = zeros(N^2,d); %matrix k_tilde in the manuscript
D = zeros(N,N*d); %distance matrix

%tic()
for i = 1:N
    D(:,((i-1)*d+1): (i*d)) = abs(bsxfun(@minus, x(i,:), x));
end

k_tilde = (reshape(1/2*(abs(repmat((temp_x(:))',N,1))+abs(repmat(x,1,N))-abs(D))',d,N*N))';
%toc()

k_mat = reshape(prod(1+k_tilde,2),N,N); %NxN matrix, each row is prod(1+k_tilde) of x_i with other points

%use the naive code to verify the above code
% tic()
% k_tilde1 = zeros(N^2,d);
% for i = 1:N
%     for j =1:N
%         for p = 1:d
%             k_tilde1((i-1)*N+j,p) = k(x(i,p),x(j,p));
%         end
%     end
% end
% toc()

row_deletion = (2*N-1)*(1+c)^d/N-2*[1/N*sum(h_vec)+(1-1/N)*h_vec]+1/N*(2*sum(k_mat,2)-diag(k_mat));

col_deletion = zeros(d,1);
for j = 1:d
    temp = arrayfun(h,x(:,j));
    part1 = h_vec.*temp./(1+temp);
    part2 = (k_tilde(:,j)./(1+k_tilde(:,j))).*reshape(k_mat,N^2,1);
    col_deletion(j) = (c-1)*c^(d-1)-2/N*sum(part1)+1/N^2*sum(part2);
end

[opt_rowde,row_choice] = max(row_deletion);
[opt_colde,col_choice] = max(col_deletion);
change_point = x(row_choice,col_choice);

k_vec = (k_mat(row_choice,:))';
k_vec(row_choice)=[];
chosen_col = x(:,col_choice);
chosen_col(row_choice)=[];

A = 2*h_vec(row_choice)/(1+h(change_point));
B = 2*(k_vec./(1+k(change_point,chosen_col)));
C = k_mat(row_choice,row_choice)/(N*(1+k(change_point,change_point)));

const = -2*h(change_point)*h_vec(row_choice)/(1+h(change_point))+1/N*2*sum(k(change_point,chosen_col).*k_vec./(1+k(change_point,chosen_col)))+1/N*k_mat(row_choice,row_choice)*k(change_point,change_point)/(1+k(change_point,change_point));

delta_function = @(y) -(A*h(y)-1/N*sum(B.*k(y,chosen_col))-C*k(y,y));
[opt_value,opt_delta] = fminsearch(delta_function,change_point);
delta = const-opt_delta;
if delta>10^(-15)
    x(row_choice,col_choice) = opt_value;
end














end
