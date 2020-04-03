% We consider three objectives,
% 1. Parts dissimilarity
% 2. Minimization the number of shared machines
% 3. Machine load balancing
function [o1,o2,o3] = Objective(subchromcell,subchrommachine,subchromnumber,subchromtime,machineNumber,process,workingNumber,cmax,timeprocess)

%% O1:Parts dissimilarity
j=1;
o1cell=cell(1,cmax);
for i=subchromcell
    o1cell{i}=[o1cell{i} j];
    j=j+1;
end

s=zeros(1,length(o1cell));
for i=1:length(o1cell)
    if length(o1cell{i})==1|| length(o1cell{i})==0
        s(i)=0;
    elseif length(o1cell{i})==2
        machine1=subchrommachine(:,o1cell{i}(1));
        machine2=subchrommachine(:,o1cell{i}(2));
        machine1(isnan(machine1))=[];
        machine2(isnan(machine2))=[];
        u=intersect(machine1,machine2);
        s(i)=1-(length(u)/(length(machine1)+length(machine2)-length(u)));
    else
        st=0;
        for j=1:length(o1cell{i})-1
            machine1=subchrommachine(:,o1cell{i}(j));
            machine2=subchrommachine(:,o1cell{i}(j+1));
            machine1(isnan(machine1))=[];
            machine2(isnan(machine2))=[];
            u=intersect(machine1,machine2);
            stemp=1-(length(u)/(length(machine1)+length(machine2)-length(u)));
            st=st+stemp;
        end
        machine1=subchrommachine(:,o1cell{i}(1));
        machine2=subchrommachine(:,o1cell{i}(end));
        machine1(isnan(machine1))=[];
        machine2(isnan(machine2))=[];
        u=intersect(machine1,machine2);
        se=1-(length(u)/(length(machine1)+length(machine2)-length(u)));   
        s(i)=se+st;
    end
end

o1=sum(s);

%% O2:Minimization the number of shared machines.

r=zeros(1,length(machineNumber));
for i =1:length(machineNumber)
    for j=1:length(o1cell)
        for k=o1cell{j}
            rtemp=sum(subchromtime(find(subchrommachine(:,k)==i),k))*workingNumber(k);
            r(i)=r(i)+rtemp;
        end
    end
    r(i)=r(i)/(timeprocess(i)*machineNumber(i));
end
rmean=sum(r)/length(machineNumber);
r=abs(r-rmean);
o2=sum(r);

%% O3:Machine load balancing
m=zeros(1,process);
for i=1:process
    if  sum(subchromnumber(i,:))-machineNumber(1,i)>0
        m(1,i)=sum(subchromnumber(i,:))-machineNumber(1,i);
    else
        m(1,i)=0;
    end
end
%o3=sum(m);
o3=0;% for the first phase, we can ignore this function.
end


