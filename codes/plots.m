

clear 
close all
clc


SE_CI   =   1.64; 
year    = (0:1:12)';

%  Average effect
raw = readtable('.../figure2_all.csv', 'ReadRowNames', true);
raw.Properties.RowNames = {'b', 'se'};
results = rows2vars(raw);
results.OriginalVariableNames = [];
results = results{:,:};
CI_u = (results(:,1) + SE_CI*results(:,2))';
CI_l = (results(:,1) - SE_CI*results(:,2))';
beta = results(:,1);


figure('Name','Average effect')
subplot(1,2,1)
    hold on
    plot(year,beta,'k-','Linewidth',2.5,'Color','cyan')
    ciplot(CI_l,CI_u,year,'cyan');
    plot(year, zeros(length(year),1),'k-','Linewidth',1)
    xlabel('Quarters since shock','FontSize',12)
    ylabel('Percent','FontSize',12)
    grid()


SE_CI   =   1.64; 
year    = (0:1:12)';

%  Average effect
raw = readtable('.../figure2_serv.csv', 'ReadRowNames', true);
raw.Properties.RowNames = {'b', 'se'};
results = rows2vars(raw);
results.OriginalVariableNames = [];
results = results{:,:};
CI_u = (results(:,1) + SE_CI*results(:,2))';
CI_l = (results(:,1) - SE_CI*results(:,2))';
beta = results(:,1);


% (b) Effect of service
raw     = readtable('.../figure2_manuf.csv', 'ReadRowNames', true);
raw.Properties.RowNames = {'b', 'se'};
results = rows2vars(raw);
results.OriginalVariableNames = [];
results = results{:,:};
CI_u_d  = (results(:,1) + SE_CI*results(:,2))';
CI_l_d  = (results(:,1) - SE_CI*results(:,2))';
beta_d  = results(:,1);




subplot(1,2,2)
    plot(year,beta,'k-','Linewidth',2.5,'Color', 'blue')
    hold on
    plot(year,beta_d,'k-','Linewidth',2.5,'Color','red')
    ciplot(CI_l,CI_u,year,'blue');
    ciplot(CI_l_d,CI_u_d,year,'red');
    plot(year, zeros(length(year),1),'k-','Linewidth',1)
    xlabel('Quarters since shock','FontSize',12)
    ylabel('Percent','FontSize',12)
    legend('Service', 'Manufacturing','FontSize',12)
    grid()



