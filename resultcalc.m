% Author: Ratana Lim
% Created date: 25/04/2018

function resultwithDG= resultcalc(x,loadbusLocation,resultwithoutDG,nbus)
busdata = busdatas(nbus); % load the bus data
linedata=linedatas(nbus); % load the line data
% DG locations
busdata(loadbusLocation,7)=-x'+busdata(loadbusLocation,7);% add the DG power to active load
resultwithDG=nrloadflow(nbus,busdata,linedata);
end