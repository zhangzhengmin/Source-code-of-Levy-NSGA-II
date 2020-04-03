function LevyFly = LevyFly(Offspring,routeNumber,iGeneration)

load('processingdata_4.mat');
s=8;%Segment length
n=length(Offspring{1}.cell);%Number of parts
t=round(n/s);
jici=1;
chrom1=Offspring;
for inchrom=chrom1
    %Levy flights
    p=0.3-0.0005*iGeneration;
    
    for i=1:t
        if i*s<=n && rand(1)<=p
            c=randperm(s,2);
            a=inchrom{1}.cell(c(1)+(i-1)*s);
            inchrom{1}.cell(c(1)+(i-1)*s)=inchrom{1}.cell(c(2)+(i-1)*s);
            inchrom{1}.cell(c(2)+(i-1)*s)=a;
        elseif i*s>n && rand(1)<=p
            c=randperm(n-s*(i-1),2);
            a=inchrom{1}.cell(c(1)+(i-1)*s);
            inchrom{1}.cell(c(1)+(i-1)*s)=inchrom{1}.cell(c(2)+(i-1)*s);
            inchrom{1}.cell(c(2)+(i-1)*s)=a;
        end
        %Levy flight for routing
        if i*s<=n && rand(1)<=p
            c=randperm(s,1);
            r=randi(routeNumber(c+(i-1)*s));
            inchrom{1}.route(c+(i-1)*s)=r;
            inchrom{1}.machine(:,c+(i-1)*s)=[NaN];
            m= find(gongyi(:,(c+(i-1)*s)*5-3)>0);
            if m(r)~=m(end)
                processNumber=m(r+1)-m(r);
            else
                processNumber=sum(gongyi(:,(c+(i-1)*s)*5-2)>0)-m(r)+1;
            end
            %Recessive chromosome adjustment
            inchrom{1}.machine(1:processNumber,(c+(i-1)*s))=gongyi(m(r):(m(r)+processNumber-1),(c+(i-1)*s)*5-2);
            inchrom{1}.time(1:processNumber,(c+(i-1)*s))=gongyi(m(r):(m(r)+processNumber-1),(c+(i-1)*s)*5-1);
            
        elseif i*s>n && rand(1)<=p
            c=randperm(n-s*(i-1),1);
            r=randi(routeNumber(c+(i-1)*s));
            inchrom{1}.route(c+(i-1)*s)=r;
            inchrom{1}.machine(:,(c+(i-1)*s))=[NaN];
            m= find(gongyi(:,(c+(i-1)*s)*5-3)>0);
            if m(r)~=m(end)
                processNumber=m(r+1)-m(r);
            else
                processNumber=sum(gongyi(:,(c+(i-1)*s)*5-2)>0)-m(r)+1;
            end
            inchrom{1}.machine(1:processNumber,(c+(i-1)*s))=gongyi(m(r):(m(r)+processNumber-1),(c+(i-1)*s)*5-2);
            inchrom{1}.time(1:processNumber,(c+(i-1)*s))=gongyi(m(r):(m(r)+processNumber-1),(c+(i-1)*s)*5-1);
        end
    end
    chrom1(jici)=inchrom;
    jici=jici+1;
end
LevyFly=chrom1;

