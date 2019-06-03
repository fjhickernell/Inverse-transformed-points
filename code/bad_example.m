function [error_bad, error] = bad_example

rng(29)
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
trueIntegral2 = d

est_invx1 = mean(integrand1(normal_x))
est_invy1 = mean(integrand1(normal_y))
est_invx2 = mean(integrand2(normal_x))
est_invy2 = mean(integrand2(normal_y))


abs_err_invx1 = abs(trueIntegral1 - est_invx1)
abs_err_invy1 = abs(trueIntegral1 - est_invy1)
abs_err_invx2 = abs(trueIntegral2 - est_invx2)
abs_err_invy2 = abs(trueIntegral2 - est_invy2)

rel_err_invx2 = abs_err_invx2/abs(trueIntegral2)
rel_err_invy2 = abs_err_invy2/abs(trueIntegral2)


end





