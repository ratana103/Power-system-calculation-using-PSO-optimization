% Author: Ratana Lim
% Created date: 25/04/2018

function [bestsol,objval]=PSO(loadbusLocation,resultwithoutDG,nbus,dim,up,low)
n = 20;          % Size of the swarm " no of birds "
bird_setp  = 50; % Maximum number of "birds steps"
% dim = 2;          % Dimension of the problem

c2 =1.2;          % PSO parameter C1 
c1 =0.12;        % PSO parameter C2 
w =0.3;           % pso momentum or inertia  
fitness=0*ones(n,bird_setp);

                                       %-----------------------------%
                                       %    initialize the parameter %
                                       %-----------------------------%
                                       
R1 = rand(dim, n);
R2 = rand(dim, n);
current_fitness =0*ones(n,1);

                                 %------------------------------------------------%
                                 % Initializing swarm and velocities and position %
                                 %------------------------------------------------%
                                 
current_position = (up-low).*rand(dim,n)+low;
velocity = 0.03*rand(dim, n) ;
local_best_position  = current_position ;


                                 %-------------------------------------------%
                                 %     Evaluate initial population           %           
                                 %-------------------------------------------%

for i = 1:n
    current_fitness(i) = objf(current_position(:,i)',loadbusLocation,resultwithoutDG,nbus);  
  
end


local_best_fitness  = current_fitness ;
[global_best_fitness,g] = min(local_best_fitness) ;

for i=1:n
    globl_best_position(:,i) = local_best_position(:,g) ;
end

handl=waitbar(0,'Kindly Wait while PSO is progressing');
%% Main Loop
iter = 0 ;        % Iterations’counter
while  ( iter < bird_setp )
iter = iter + 1;
velocity = w *velocity + c1*(R1.*(local_best_position-current_position)) + c2*(R2.*(globl_best_position-current_position));
save velocity velocity
 current_position = current_position + velocity;
for i = 1:n,
current_position(:,i)=limitchk(current_position(:,i),up,low,nbus,loadbusLocation);
current_fitness(i) = objf(current_position(:,i)',loadbusLocation,resultwithoutDG,nbus);   

end


for i = 1 : n
        if current_fitness(i) < local_best_fitness(i)
           local_best_fitness(i)  = current_fitness(i);  
           local_best_position(:,i) = current_position(:,i)   ;
        end   
 end

  
 [current_global_best_fitness,g] = min(local_best_fitness);
  
    
if current_global_best_fitness < global_best_fitness
   global_best_fitness = current_global_best_fitness;
   
    for i=1:n
        globl_best_position(:,i) = local_best_position(:,g);
    end
   
end
objval(iter)=global_best_fitness;
waitbar(iter / bird_setp)
end % end of while loop its mean the end of all step that the birds move it 
close(handl)
[Jbest_min,I] = min(current_fitness); % minimum fitness
bestsol=current_position(:,I); % best solution

               


    

%          
         