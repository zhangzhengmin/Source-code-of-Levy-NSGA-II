clc;
clear;
%Data information~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
Machinedata----jitai
Machine number, Processing type, Avaliable processing time in one planning period
Processing data----gongyi
Part number, Processing paths, Processing type, Processing time, Number of this part in the second phase
%}
load machinedata_4
load processingdata_4

solution=xlsread('test.xls',1,'A1:C8');

%% Related data---------------------------------------------------------
%Processing data
[m,n]=size(gongyi);

jobNumber=n/5;

workingNumber=[1,jobNumber];
for j=1:jobNumber
    workingNumber(j)=gongyi(1,j*5);
end

count=1;
routeNumber=zeros(1,jobNumber);
for i=2:5:n
    routeNumber(count)=sum(gongyi(:,i) >0);
    count=count+1;
end
%Machinedata-------------------------------
timeprocess=jitai(:,3);

machineNumber=jitai(:,2)';

process=length(machineNumber);

%Parameters
%The maximum number of iterations
Generations = 200;
%Population number
Y = 300;

chroms = cell(1,Y);
%Cmax
cmax=3;


%% Initial population--------------------------------------------------------
for i=1:Y
    structchroms=struct;
    for j=1:jobNumber%j:parts
        %Random cell allocation
        structchroms.cell(j)=randi(cmax);
        %Randomly assign process paths
        structchroms.route(j)=randi(routeNumber(j));
        %Find the corresponding processing machine type 
        m=find(gongyi(:,j*5-3)>0);
        %Recessive chromosome
        if m(structchroms.route(j))~=m(end)
            processNumber=m(structchroms.route(j)+1)-m(structchroms.route(j));
        else
            processNumber=sum(gongyi(:,j*5-2)>0)-m(structchroms.route(j))+1;
        end
        structchroms.machine(1:processNumber,j)=[gongyi(m(structchroms.route(j)):(m(structchroms.route(j))+processNumber-1),j*5-2)];

        structchroms.time(1:processNumber,j)=[gongyi(m(structchroms.route(j)):(m(structchroms.route(j))+processNumber-1),j*5-1)];
    end
    structchroms.number=QuantityAllocation(structchroms,cmax,machineNumber,workingNumber,timeprocess);
    structchroms.machine(structchroms.machine==0)=NaN;
    structchroms.time(structchroms.time==0)=NaN;
    structchroms.Fitness =zeros(1,3);%Three objectives
    chroms{1,i} = structchroms;
end

%% Main Loop---------------------------------------------
for i = 1:Y
    subchromcell=chroms{i}.cell;
    subchrommachine=chroms{i}.machine;
    subchromnumber=chroms{i}.number;
    subchromtime=chroms{i}.time;
   %Evaluate the initial population and obtain the function values
    [o1,o2,o3]=Objective(subchromcell,subchrommachine,subchromnumber,subchromtime,machineNumber,workingNumber,cmax,timeprocess,solution); %[f1,f2,f3]  评价个体
    chroms{i}.Fitness=[o1,o2,o3];
end

%Calculation of stratification and crowding distance of parent population
FunctionValue=zeros(Y,3);%Three objectives
for i=1:Y
    FunctionValue(i,:)=chroms{i}.Fitness;
end
FrontValue = NonDominateSort(FunctionValue);%Get layered results
CrowdDistance = CrowdDistances(FunctionValue,FrontValue);%Get crowd distances
%Copy the parents
Father=chroms;

for iGeneration = 1:Generations 
    %Select mating individuals and evolve
    disp(['Iterations : ',num2str(iGeneration)]); 
    MatingPool = Mating(Y,FrontValue,CrowdDistance);
   %Get offsprings
    Offspring = NSGA_Gen(chroms,MatingPool,cmax,routeNumber);
    for i=1:Y
        structchroms=Offspring{i};
        structchroms.number=QuantityAllocation(structchroms,cmax,machineNumber,workingNumber,timeprocess);
        Offspring{i}.number= structchroms.number;
    end
        Offspring1=LevyFly(Offspring,routeNumber,iGeneration );
    for i=1:Y
        structchroms=Offspring1{i};
        structchroms.number=QuantityAllocation(structchroms,cmax,machineNumber,workingNumber,timeprocess);
        Offspring1{i}.number= structchroms.number;
    end
    %Discrete Levy flight search 
    for i = 1:Y
        subchromcell= Offspring1{i}.cell;
        subchrommachine= Offspring1{i}.machine;
        subchromnumber= Offspring1{i}.number;
        subchromtime= Offspring1{i}.time;
      %Fitness calculation
        [o1,o2,o3]=Objective(subchromcell,subchrommachine,subchromnumber,subchromtime,machineNumber,workingNumber,cmax,timeprocess,solution); %[f1,f2,f3]  评价个体
        Offspring1{i}.Fitness=[o1,o2,o3];
    end

    %Choose the better individual
    for i=1:Y
        for j=1:3
            if Offspring1{i}.Fitness(j)>Offspring{i}.Fitness(j)
                break;
            end
        end
        Offspring{i}=Offspring1{i};
    end
    %Gain the new population
    if iGeneration ==1
        population =[Father,Offspring];
    else
        population =[chroms,Offspring];
    end
   
    for i = 1:2*Y
        subchromcell=population{i}.cell;
        subchrommachine=population{i}.machine;
        subchromnumber=population{i}.number;
        subchromtime=population{i}.time;
        [o1,o2,o3]=Objective(subchromcell,subchrommachine,subchromnumber,subchromtime,machineNumber,workingNumber,cmax,timeprocess,solution); %[f1,f2,f3]  
        FunctionValue(i,:)=[o1,o2,o3];
        population{i}.Fitness=[o1,o2,o3];
        %Add into functionvalue
    end 

    [FunctionValue,Rank]=unique (FunctionValue,'rows');
    population= population(Rank);

    %Calculate the Pareto layer and crowd distance
    [FrontValue,MaxFront] = NonDominateSort(FunctionValue);
    CrowdDistance = CrowdDistances(FunctionValue,FrontValue);
    
    %Choose non-dominated individuals
    Next=zeros(1,Y);
    
    NON=0;
    for i=1:MaxFront
        Pn1=find(FrontValue==i);
        p=1;
        n1=round(p*length(Pn1));
        NON=NON+n1;
        if NON<=Y
            a=randperm(length(Pn1));
            b=a(1:n1);
            Next((NON-n1+1):NON)=Pn1(b);
        else
            c=Y-(NON-n1);
            a=randperm(length(Pn1));
            b=a(1:c);
            Next(Y-c+1:Y)=Pn1(b);
        end
    end
    
  
    
    %Next generation 
    chroms = population(Next);

   
    %Calculate function values
    FunctionValue=zeros(Y,3);
    for i=1:Y
        FunctionValue(i,:)=chroms{i}.Fitness;
    end
    [FrontValue,MaxFront] = NonDominateSort(FunctionValue);%Sort the individulas
    
    %% Plot--------------------------------------------------
    cla;
   
    FrontCurrent = find(FrontValue==1);
    FunctionValueCurrent=FunctionValue(FrontCurrent,1:3);
    DrawGraph(FunctionValueCurrent,'r*');
    pause(0.01);
end

hangshu=xlsread('..\..\Plot\sp1','sheet1'); % The optimal solution set is recorded in sp1.xls in ..\..\Plot\sp1
xlswrite('..\..\Plot\sp1',[-1,-1,-1],1,['A',num2str(size(hangshu,1)+1)]);
x=FunctionValueCurrent(:,1);y=FunctionValueCurrent(:,2);z=FunctionValueCurrent(:,3);
xlswrite('..\..\Plot\sp1',[x,y,z],1,['A',num2str(size(hangshu,1)+2)]);


