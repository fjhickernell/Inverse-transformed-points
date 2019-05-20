%test the normal discrepancy after inverse transformation of a low
%discrepancy sequence for dimonesion d.
%input: N - scalar, number of points in low discrepancy sequence
%       d - scalar, dimension of variable
%ouput: disc_normal - discrepancy of points after inverse transformation
%w.r.t. normal distribution 

function [disc_x, disc_y, disc_normalx, disc_normaly] = test_multidisc(N,d)
repeat = 20;
%d=6;
% s = 2; %size per dimension
% N = s^d;
N = 50;

%try different dimensions
corr = zeros(10,1);
for d = 5
    disc_z = zeros(repeat,1);
    disc_normalz = zeros(repeat,1);
    for i = 1:repeat
        %generate sobol sequence
        %     p = sobolset(d);
        %     p = scramble(p,'MatousekAffineOwen');
        %     x = net(p,N);
        
        %     disc_x = uniform_multidiscrepancy(x); %discrepancy of x w.r.t. uniforma measure
        %     disc_x
        %     normal_1 = norminv(x); % the normal points using low discrepancy sequence x
        %     disc_normalx = normal_multidiscrepancy(normal_1); %discrepancy of inverse transformed x w.r.t. normal measure
        %     disc_normalx
        %
        %     %shift the largest point in x to the right a little bit
        %     y = x;
        %     changed = 10^(-15);
        %
        %     %randomly pick a point to change
        %     y(randsample(N,1),:) = changed+zeros(1,d);
        %
        %     %pick the smallest one to change
        %     % distances = sqrt(sum(bsxfun(@minus, y, zeros(N,d)).^2,2));
        %     % y(find(distances==min(distances)),:) = changed+zeros(1,d);
        %
        %
        %     disc_y = uniform_multidiscrepancy(y); %discrepancy of y w.r.t. uniforma measure
        %     disc_y
        %     normal_2 = norminv(y); % the normal points using shifted low discrepancy sequence y
        %     disc_normaly = normal_multidiscrepancy(normal_2); %discrepancy of inverse transformed y w.r.t. normal measure
        %     disc_normaly
        
        %start with random uniform numbers
        z = rand(N,d);
        disc_z(i) = uniform_multidiscrepancy(z);
        %disc_z
        normal_3 = norminv(z);
        disc_normalz(i) = normal_multidiscrepancy(normal_3);
        %disc_normalz
    end
    temp = corrcoef(disc_z,disc_normalz);
    corr(d) = temp(1,2);
end


% plot(1:10,corr,'o-','LineWidth',2,'MarkerFaceColor','b')
% xlabel('Dimension','FontSize',20)
% ylabel('Correlation','FontSize',20)


scatter(disc_z,disc_normalz,'o', 'MarkerFaceColor', 'b')
h = lsline;
h.Color = 'r';
h.LineWidth = 2;
h.LineStyle = '--';
%title('Uniform Discrepancy Vs. Normal Discrepancy after Inverse Transformation')
xlabel('Uniform Discrepancy','FontSize',14)
ylabel('Normal Discrepancy after Inverse Transformation','FontSize',14)


% figure
% histogram(normal_1)
% figure
% histogram(normal_2)
end