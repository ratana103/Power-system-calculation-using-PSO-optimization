% Author: Ratana Lim
% Created date: 25/04/2018

function [Pi Qi Pg Qg Pl Ql Lpij Lqij V Iijm] = loadflow(nb,V,del,BMva,busd,lined)
%---------------------------
Y = ybusppg(lined);                
xc=0;
%---------------------------
Vm = pol2rect(V,del);           
Del = 180/pi*del;               
fb = lined(:,1);                
tb = lined(:,2);                
nl = length(fb);                
Pl = busd(:,7);                 
Ql = busd(:,8);                 
Iij = zeros(nb,nb);
Sij = zeros(nb,nb);
Si = zeros(nb,1);
%---------------------------
 I = Y*Vm;
 Im = abs(I);
 Ia = angle(I);
%---------------------------
for m = 1:nl
    p = fb(m); q = tb(m);
    Iij(p,q) = -(Vm(p) - Vm(q))*Y(p,q); % Y(m,n) = -y(m,n)..
    Iij(q,p) = -Iij(p,q);
end
%--------- DG6------------------
Iij = sparse(Iij);
Iijm = abs(Iij);
Iija = angle(Iij);
%-------------------------------
for m = 1:nb
    for n = 1:nb
        if m ~= n
            Sij(m,n) = Vm(m)*conj(Iij(m,n))*BMva;
        end
    end
end
%-------------------------------
Pij = real(Sij);
Qij = imag(Sij);
Lij = zeros(nl,1);
%-------------------------------
for m = 1:nl
    p = fb(m); q = tb(m);
    Lij(m) = Sij(p,q) + Sij(q,p);
end
%-------------------------------
Lpij = real(Lij);
Lqij = imag(Lij);
%-------------------------------
for i = 1:nb
    for k = 1:nb
        Si(i) = Si(i) + conj(Vm(i))* Vm(k)*Y(i,k)*BMva;
    end
end
%-------------------------------
Pi = real(Si);
Qi = -imag(Si);
Pg = Pi+Pl;
Qg = Qi+Ql;
disp('=========================================================================================');
disp('/////////////////////////////////////////////////////////////////////////////////////////');
disp('                              Newton Raphson Loadflow Analysis ');
disp('/////////////////////////////////////////////////////////////////////////////////////////');
disp('| Bus |    V   |  Angle  |     Injection      |     Generation     |          Load      |');
disp('| No  |   pu   |  Degree |    MW   |   MVar   |    MW   |  Mvar    |     MW     |  MVar | ');
for m = 1:nb
    disp('......................................................................................');
    fprintf('%3g', m); fprintf('  %8.4f', V(m)); fprintf('   %8.4f', Del(m));
    fprintf('  %8.3f', Pi(m)); fprintf('   %8.3f', Qi(m)); 
    fprintf('  %8.3f', Pg(m)); fprintf('   %8.3f', Qg(m)); 
    fprintf('  %8.3f', Pl(m)); fprintf('   %8.3f', Ql(m)); fprintf('\n');
end
disp('////////////////////////////////////////////////////////////////////////////////////////');
fprintf(' Total                  ');fprintf('  %8.3f', sum(Pi)); fprintf('   %8.3f', sum(Qi)); 
fprintf('  %8.3f', sum(Pi+Pl)); fprintf('   %8.3f', sum(Qi+Ql));
fprintf('  %8.3f', sum(Pl)); fprintf('   %8.3f', sum(Ql)); fprintf('\n');
disp('////////////////////////////////////////////////////////////////////////////////////////');
fprintf('\n\n');
disp('========================================================================================');
disp('////////////////////////////////////////////////////////////////////////////////////////');
disp('                              Line FLow and Losses ');
disp('////////////////////////////////////////////////////////////////////////////////////////');
disp('|From|To |    P    |    Q     | From| To |    P     |   Q     |      Line Loss      |');
disp('|Bus |Bus|   MW    |   MVar   | Bus | Bus|    MW    |  MVar   |     MW   |    MVar  |');
for m = 1:nl
    p = fb(m); q = tb(m);
    disp('-------------------------------------------------------------------------------------');
    fprintf('%4g', p); fprintf('%4g', q); fprintf('  %8.3f', Pij(p,q)); fprintf('   %8.3f', Qij(p,q)); 
    fprintf('   %4g', q); fprintf('%4g', p); fprintf('   %8.3f', Pij(q,p)); fprintf('   %8.3f', Qij(q,p));
    fprintf('  %8.3f', Lpij(m)); fprintf('   %8.3f', Lqij(m));
    fprintf('\n');
end
disp('//////////////////////////////////////////////////////////////////////////////////////');
fprintf('   Total Loss                                                 ');
fprintf('  %8.3f', sum(Lpij)); fprintf('   %8.3f', sum(Lqij));  fprintf('\n');
disp('//////////////////////////////////////////////////////////////////////////////////////');
fprintf('\n\n');
disp('======================================================================================');