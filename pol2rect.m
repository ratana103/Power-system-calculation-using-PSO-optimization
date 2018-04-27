% Author: Ratana Lim
% Created date: 25/04/2018

function rect = pol2rect(rho,theta)
rect = rho.*cos(theta) + j*rho.*sin(theta);