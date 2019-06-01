function [error_bad, error] = bad_example

N = 512;
d = 10;

%generate 2-d uniform random numbers
p = sobolset(d);
p = scramble(p,'MatousekAffineOwen');
x = net(p,N);

%shift the largest point in x to the right a little bit
y = x;
changed = zeros(1,d)+10^(-15);

[~,ind] = min(vecnorm(y'));
y(ind,:) = changed;

disc_x = uniform_multidiscrepancy(x); %discrepancy of y w.r.t. uniforma measure
disc_x
normal_x = norminv(x); % the normal points using shifted low discrepancy sequence y
disc_normalx = normal_multidiscrepancy(normal_x); %discrepancy of inverse transformed y w.r.t. normal measure
disc_normalx

disc_y = uniform_multidiscrepancy(y); %discrepancy of y w.r.t. uniforma measure
disc_y
normal_y = norminv(y); % the normal points using shifted low discrepancy sequence y
disc_normaly = normal_multidiscrepancy(normal_y); %discrepancy of inverse transformed y w.r.t. normal measure
disc_normaly


% est_invx = mean(exp(abs(sum(normal_x,2))))
% est_invy = mean(exp(abs(sum(normal_y,2))))

% est_invx = mean((abs(sum(normal_x,2))).^(0.99))
% est_invy = mean((abs(sum(normal_y,2))).^(0.99))
% true = 2^(0.99/2)*gamma(199/200)*d^(0.99/2)/sqrt(pi)
% error_invx = abs(est_invx-true)/true
% error_invy = abs(est_invy-true)/true

c = 1e-4;
integrand1 =@(z) sum(z,2)./(1+c^2*sum(z.^2,2)); trueIntegral1 = 0
integrand2 =@(z) sum(z.^2,2)./(1+c^2*sum(z.^2,2)); 
trueIntegral23 = ...
(2*c^3*(-1 + c^2) + exp(1/(2*c^2))*sqrt(2*pi)*erfc(1/(sqrt(2)*c)))/(2*c^5)
trueIntegral2 = ...
   2^(-1-d/2) * c^(-2-d) * d * exp(1/(2*c^2)) * WGamma(-d/2, 1/(2*c^2))


est_invx1 = mean(integrand1(normal_x))
est_invy1 = mean(integrand1(normal_y))
est_invx2 = mean(integrand2(normal_x))
est_invy2 = mean(integrand2(normal_y))





end

function y = WGamma(a,x)
%Wolfram's definition of Gamma(a,x) = gammainc(x,a,'upper')*gamma(a)
%Since gamma(x,a) only works for a>0 we need to use the 
a1 = mod(a,1) + 1;
a2 = a - a1;
if a2 >= 0
   y = gammainc(x,a,'upper')*gamma(a);
else 
   y = gammainc(x,a1,'upper')*gamma(a1);
   for aa = a1-1:-1:a
      y = (y - x.^aa * exp(-x))/aa;
   end
end



end



