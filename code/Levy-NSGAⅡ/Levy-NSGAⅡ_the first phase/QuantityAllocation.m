function allocation = QuantityAllocation(structchroms,cmax,machineNumber,workingNumber,timeprocess)
tcell=cell(1,cmax);
i=1;
for j=structchroms.cell()
    tcell{j}=[tcell{j} i];
    i=i+1;
end
%得到单元成组tcell
%找到每个单元内工件对应的机器及加工时间，求该单元内每一个机台类型所需要的加工时间
r=zeros(length(machineNumber),length(tcell));
for i=1:length(tcell)
    for j=1:length(machineNumber)%在某一个单元中找机台1对应的加工时间
        for k=tcell{i}
            rtemp=sum(structchroms.time(find(structchroms.machine(:,k)==j),k))*workingNumber(k);
            r(j,i)=r(j,i)+rtemp;
        end
    end
end
%计算至少需要多少机台
for i=1:length(machineNumber)
    r(i,:)=r(i,:)/timeprocess(i);
end
allocation=ceil (r);
end