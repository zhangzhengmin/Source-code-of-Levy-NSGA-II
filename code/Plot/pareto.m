
function pareto= pareto(Sp,S1,S2,S3)
Algorithm=cell(1,3);
Algorithm{1,1}=S1;Algorithm{1,2}=S2;Algorithm{1,3}=S3;
[n,m]=size(Sp);
fd=zeros(1,m);
for i=1:m
    fd(1,i)=max(Sp(:,i))-min(Sp(:,i));
end
pareto=zeros(1,3);
for i=1:3
    ed=zeros(n,1);
    for j=1:n
        current_sp=Sp(j,:);
        fdd=zeros(size(Algorithm{i},1),m);
        for a=1:m
             fdd(:,a)=[(Algorithm{i}(:,a)-current_sp(:,a))/fd(1,a)].^2;
        end       
        ed(j,1)=min(sum(fdd,2));
    end
    pareto(1,i)=sum(ed);

end

