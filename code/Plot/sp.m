%Read the EXCEL file, delete the same value, and call the pareto function to calculate the objective function indicator
clc;
clear;
solution=xlsread('sp1.xls',1);
n=size(solution,2);
location=find(solution(:,1)==-1);
S1=solution(1:location(1)-1,:);
S2=solution(location(1)+1:location(2)-1,:);
S3=solution(location(2)+1:end,:);
solution(find(solution(:,1)==-1),:)=[];
[Frontvalue]=NonDominateSort(solution);
Sp=solution(find(Frontvalue==1),:);
% Use pareto function to find the value of the crowded distance
Vpd=pareto(Sp,S1,S2,S3);
Vnp=zeros(1,3);
v1=0;
for j=1:size(Sp,1)
    for z=1:size(S1,1)
        v=0;
        for i=1:n
            if S1(z,i)==Sp(j,i)
            else
                v=1;
                break
            end
        end
        if v==0
            v1=v1+1;
        end
    end
end
Vnp(1,1)=v1;
v1=0;
for j=1:size(Sp,1)
    for z=1:size(S2,1)
        v=0;
        for i=1:n
            if S2(z,i)==Sp(j,i)
            else
                v=1;
                break
            end
        end
        if v==0
            v1=v1+1;
        end
    end
end
Vnp(1,2)=v1;
v1=0;
for j=1:size(Sp,1)
    for z=1:size(S3,1)
        v=0;
        for i=1:n
            if S3(z,i)==Sp(j,i)
            else
                v=1;
                break
            end
        end
        if v==0
            v1=v1+1;
        end
    end
end
Vnp(1,3)=v1;
Vrd=[size(S1,1),size(S2,1),size(S3,1)]/300;
output=[Vpd;Vnp;Vrd]

DrawGraph(S1,'b.');
hold on
DrawGraph(S2,'g.');
hold on
DrawGraph(S3,'r.')
