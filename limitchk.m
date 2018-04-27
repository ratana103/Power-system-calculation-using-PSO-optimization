% Author: Ratana Lim
% Created date: 25/04/2018

function x=limitchk(x,up,low,nbus,loadbusLocation)
for ii=1:numel(x)
if x(ii)<low
x(ii)=low;
elseif x(ii)>up
x(ii)=up;
end
end
%% volateg constraint check

% busdata = busdatas(nbus); % load the bus data
% linedata=linedatas(nbus); % load the line data
% % DG locations
% busdata(loadbusLocation,7)=-x+busdata(loadbusLocation,7);% add the DG power to active load
% resultwithDG=nrloadflow(nbus,busdata,linedata);
% V=resultwithDG.V;
% Vmax=1.1; Vmin=0.95;
% cond=numel(unique((Vmin<=V&V<=Vmax)));
% dim=numel(x);
% while cond==2
%     x=(up-low).*rand(dim,1)+low;
%     busdata = busdatas(nbus);
%     busdata(loadbusLocation,7)=-x+busdata(loadbusLocation,7);% add the DG power to active load
%     resultwithDG=nrloadflow(nbus,busdata,linedata);
%     V=resultwithDG.V;
%     cond=numel(unique((Vmin<=V&V<=Vmax)));
%     display('asnfhasdfhfo')
% end
