% Author: Ratana Lim
% Created date: 25/04/2018

%% Calculation of Power System
clc
clear 
close all  
%% NR load flow analysis
nbus = 30; 
busdata = busdatas(nbus);
linedata = linedatas(nbus);
resultWithoutDG = nrloadflow(nbus,busdata,linedata);
dim = 10;
Pmin=3; %minimum  power of solar DG unit
if nbus==30
    Pmax=30; %maximum power of solar DG unit in MW
else
    Pmax=100;
end
%% potential bus selection
R=linedata(:,3);
sourcbus=linedata(:,1);
destintnbus=linedata(:,2);
% del=180/pi*del;
 for ii=1:size(linedata,1)
         alpha(ii)=(R(ii)/(abs(resultWithoutDG.V(sourcbus(ii)))...
                        *abs(resultWithoutDG.V(sourcbus(ii)))))...
                         *cos(resultWithoutDG.del(sourcbus(ii))...
                            -resultWithoutDG.del(destintnbus(ii)));
         beta(ii)=(R(ii)/(abs(resultWithoutDG.V(sourcbus(ii)))...
                       *abs(resultWithoutDG.V(sourcbus(ii)))))...
                        *sin(resultWithoutDG.del(sourcbus(ii))...
                          -resultWithoutDG.del(destintnbus(ii)));
         SV(ii)=alpha(ii).*resultWithoutDG.Pi(destintnbus(ii))...
                     -beta(ii).*resultWithoutDG.Qi(destintnbus(ii));
 end
     
[sv,ind]=sort(SV,'descend');
po=destintnbus(ind);
[poo,ia,ic]=unique(po);
temp=po(sort(ia));
loadBusLocation = temp(1:dim);
%% GA optimisation
fitness=  @(x) objf(x,loadBusLocation,resultWithoutDG,nbus);
options = gaoptimset('MutationFcn',@mutationadaptfeasible,'PopulationSize',20);
options = gaoptimset(options,'PlotFcns',{@gaplotbestf}, ...
    'Display','iter','Generations',80);
[GAx,fval] = ga(fitness,dim,[],[],[],[],Pmin.*ones(1,dim)...
                                ,Pmax.*ones(1,dim),[],options);
finalGAresults= resultcalc(GAx,loadBusLocation,resultWithoutDG,nbus);
%% PSO optimisation
[PSOx,objval]=PSO(loadBusLocation,resultWithoutDG,nbus,dim,Pmax,Pmin);
finalPSOresults= resultcalc(PSOx',loadBusLocation,resultWithoutDG,nbus);
FIG1 = figure('Name', 'PSO Optimization','NumberTitle','off');
figure(FIG1)
plot(1./objval)
grid on;
ylabel('VL (pu)');
xlabel('time (sec)');
title('PSO optimisation')
%% Result plotting
% volatge magnitude plot
FIG2 = figure('Name', 'BUS VOLTAGE','NumberTitle','off');
figure(FIG2)
bar([finalPSOresults.V,finalGAresults.V,resultWithoutDG.V],'group')
xlim([0 nbus+1])
ylim([0.95,1.1])
grid on;
legend('PSO optimised','GA optimised','Without DG')
xlabel('Bus number')
ylabel('Volatge Magnitude in p.u.')
title('Bus Voltage')
% power loss comparison
FIG3 = figure('Name', 'Total Active Power loss','NumberTitle','off');
figure(FIG3)
bar([sum(finalPSOresults.Lpij);sum(finalGAresults.Lpij);sum(resultWithoutDG.Lpij)])
grid on;
title('Total Active Power loss in MW')
ylabel('Active Power loss(MW)')
set(gca,'Xtick',0)
text(0.8,-0.2,'PSO tuned')
text(1.8,-0.2,'GA tuned')
text(2.8,-0.2,'Without Optimisation')
% printresult


