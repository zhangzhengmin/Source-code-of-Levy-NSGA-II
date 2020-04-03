function Offspring = NSGA_Gen(chroms,MatingPool,cmax,routeNumber)
% Crossover
% Input: MatingPool,
% Output: Offspring
load('processingdata_4.mat');
N= length(MatingPool);%N means number of individuals
%Crossover operator
croPos=1;
%Mutation operator
mutPos = 0.1;

%{
Simulate the binary crossover process (two-layer crossover process)
%}
for i=1:2:N
    a=MatingPool(i);
    b=MatingPool(i+1);
    %% Crossever
    if rand(1)<croPos
        rand1=unidrnd(length(chroms{1}.cell()));
        rand2=unidrnd(length(chroms{1}.cell()));
        c1=min(rand1,rand2);
        c2=max(rand1,rand2);
        %Cell segments corossover
        c=chroms{a}.cell(c1:c2);
        chroms{a}.cell(c1:c2)=chroms{b}.cell(c1:c2);
        chroms{b}.cell(c1:c2)=c;
    else
        %Routing cross
        rand1=unidrnd(length(chroms{1}.cell()));
        rand2=unidrnd(length(chroms{1}.cell()));
        c1=min(rand1,rand2);
        c2=max(rand1,rand2);
        c=chroms{a}.route(c1:c2);
        chroms{a}.route(c1:c2)=chroms{b}.route(c1:c2);
        chroms{b}.route(c1:c2)=c;
        %Recessive chromosomes change
        c=chroms{a}.machine(:,c1:c2);
        chroms{a}.machine(:,c1:c2)=chroms{b}.machine(:,c1:c2);
        chroms{b}.machine(:,c1:c2)=c;
        c=chroms{a}.time(:,c1:c2);
        chroms{a}.time(:,c1:c2)=chroms{b}.time(:,c1:c2);
        chroms{b}.time(:,c1:c2)=c;
    end
end
%% Mutation------------------------------------------------------------
for i=1:N
    %Cell mutation
    if rand(1)<mutPos
        rand1=unidrnd(length(chroms{1}.cell()));
        chroms{i}.cell(rand1)=unidrnd(cmax);
    end
    %Routing mutation
    if rand(1)<mutPos
        rand2=unidrnd(length(chroms{1}.cell()));
        xx=unidrnd(routeNumber(rand2));
        chroms{i}.route(rand2)=xx;
        
        chroms{i}.machine(:,rand2)=[NaN];
        m= find(gongyi(:,rand2*5-3)>0);
        if m(xx)~=m(end)
            processNumber=m(xx+1)-m(xx);
        else
            processNumber=sum(gongyi(:,rand2*5-2)>0)-m(xx)+1;
        end
        chroms{i}.machine(1:processNumber,rand2)=gongyi(m(xx):(m(xx)+processNumber-1),rand2*5-2);
        chroms{i}.time(1:processNumber,rand2)=gongyi(m(xx):(m(xx)+processNumber-1),rand2*5-1);
        
    end
end
Offspring=chroms;
end