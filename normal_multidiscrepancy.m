%calculate normal discrepancy of a multidimensional sample 
% input: x - Nxd vector of sample points
% output: disc - scalar, discrepancy of x w.r.t. normal probability
% distribution

function [disc] = normal_multidiscrepancy(x) 
d = size(x,2);
N = size(x,1);
D = Distance_Matrix(x);

%use matrix to calculate last sum of discrepancy
vec_x = reshape(x',1,[]);
rep_x1 = repmat(vec_x,N,1);
rep_x2 = repmat(x,1,N);

part_2Mat = reshape((1+1/2*abs(rep_x1)+1/2*abs(rep_x2)-1/2*D)',d,[])';

part_2 = sum(prod(part_2Mat,2));

% use loop, to assure the above code is correct
% temp1 = 0;
% for i = 1:N
%     for k = 1:N
%         temp=1;
%         for j = 1:d
%         temp = temp*(1+1/2*abs(x(i,j))+1/2*abs(x(k,j))-1/2*abs(x(i,j)-x(k,j)));
%         end
%     temp1 = temp1+temp;
%     end
% end

disc = sqrt((1+sqrt(2/pi))^d-2/N*sum(prod(1+1/sqrt(2*pi)+1/2*abs(x)-x.*(normcdf(x)-1/2)-normpdf(x),2))+1/N^2*part_2);
end


