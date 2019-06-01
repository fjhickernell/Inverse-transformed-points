%compare proposed generator with 'randn'

function  compare_generator
close all
clearvars

repeat = 500;
disc_opt = zeros(repeat,1);
disc_randn = zeros(repeat,1);
disc_low = zeros(repeat,1);
disc_center = zeros(repeat,1);
d=4;
n=2^6;

for i = 1:repeat 
    %generate normal random numbers using inverse distribution transformation
    p = sobolset(d);
    p = scramble(p,'MatousekAffineOwen');
    %Sobol sequence
    uniform = net(p,n);
    x = norminv(uniform);
    disc_low(i) = normal_multidiscrepancy(x);
    %Centered points
    [~, xwh] = sort(uniform); %sort twice
    [~, xeven] = sort(xwh); %to order the points in each direction
    xeven = (2*xeven-1)/(2*n); %this gives you evenness in one direction
    disc_center(i) = normal_multidiscrepancy(norminv(xeven));
    %C-E optimized sequence
    [low_discNormal,new_normaldisc] = CE_Normal(x);
    disc_opt(i) = new_normaldisc; 
    %random normal in Matlab
    rand_sample = randn(n,d);
    disc_randn(i) = normal_multidiscrepancy(rand_sample);
end

%read data
% disc_opt = disc_d7n130(1:500);
% disc_low = disc_d7n130(501:1000);
% disc_randn = disc_d7n130(1001:1500);


%plot opt Vs randn
disc = [disc_opt;disc_randn];
g = [ones(repeat,1);2*ones(repeat,1)];

figure
subplot(2,1,1);
boxplot(disc,g)
%title('Discrepancies of Proposed Generator and Randn Generator')
ylabel('$D(\boldmath{\Psi}(\mathcal{U}), F_\textup{normal}, K)$','Interpreter','Latex','FontSize',18)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',21)
xticklabels({'NG2','Randn'})


%plot opt Vs inversed Sobol
disc = [disc_low;disc_opt;disc_center];
g = [ones(repeat,1);2*ones(repeat,1);3*ones(repeat,1)];

subplot(2,1,2);
boxplot(disc,g)
%title('Discrepancies of Proposed Generator and Inversed Sobol')
ylabel('$D(\boldmath{\Psi}(\mathcal{U}), F_\textup{normal}, K)$','Interpreter','Latex','FontSize',18)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',21)
xticklabels({'NG1','NG2','NG3'})


%plot opt, inversed Sobol and randn
disc = [disc_low;disc_opt;disc_randn];
g = [ones(repeat,1);2*ones(repeat,1);3*ones(repeat,1)];

figure
boxplot(disc,g)
%title('Discrepancies of Three Generators')
ylabel('$D(\boldmath{\Psi}(\mathcal{U}), F_\textup{normal}, K)$','Interpreter','Latex','FontSize',18)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',21)
xticklabels({'NG1','NG2','Randn'})


end