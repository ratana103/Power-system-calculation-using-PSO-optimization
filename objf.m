% Author: Ratana Lim
% Created date: 25/04/2018

function fitval=objf(x,loadbusLocation,resultwithoutDG,nbus)

busdata = busdatas(nbus); % load the bus data
linedata=linedatas(nbus); % load the line data
% DG locations
busdata(loadbusLocation,7)=-x'+busdata(loadbusLocation,7);% add the DG power to active load
resultwithDG=nrloadflow(nbus,busdata,linedata);
%% real power loss index calculation
PLRI=(sum(resultwithoutDG.Lpij)-sum(resultwithDG.Lpij))/sum(resultwithoutDG.Lpij);
%% reactive power loss index calculation
QLRI=(sum(resultwithoutDG.Lqij)-sum(resultwithDG.Lqij))/sum(resultwithoutDG.Lqij);
%% voltage deviation index calculation
Vref=1;
VDI= max((Vref-resultwithDG.V)./Vref);
%% Line Loading Capacity Index calculation
LLI=max(round(resultwithDG.Pi,2)./round(resultwithoutDG.Pi,2));
%% Short Circuit Index calculation
% IfaultwithoutDG=
%% fitness value calculation
% fitval=0.35*PLRI + 0.15*QLRI + 0.30*VDI + 0.10*LLI + 0.10*SCI;
fitval=0.50*PLRI + 0.35*QLRI + 0.15*VDI ;