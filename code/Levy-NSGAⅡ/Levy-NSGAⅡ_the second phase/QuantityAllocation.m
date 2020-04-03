function allocation = QuantityAllocation(structchroms,cmax,machineNumber,workingNumber,timeprocess)
tcell=cell(1,cmax);
i=1;
for j=structchroms.cell()
    tcell{j}=[tcell{j} i];
    i=i+1;
end

r=zeros(length(machineNumber),length(tcell));
for i=1:length(tcell)
    for j=1:length(machineNumber)
        for k=tcell{i}
            rtemp=sum(structchroms.time(find(structchroms.machine(:,k)==j),k))*workingNumber(k);
            r(j,i)=r(j,i)+rtemp;
        end
    end
end

for i=1:length(machineNumber)
    r(i,:)=r(i,:)/timeprocess(i);
end
allocation=ceil (r);
end