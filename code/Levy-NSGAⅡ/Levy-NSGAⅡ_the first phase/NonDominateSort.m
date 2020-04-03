function [FrontValue,MaxFront] = NonDominateSort(FunctionValue)

[N,M] = size(FunctionValue);
MaxFront =0;
cz = zeros(1,N);%Number of individuals
FrontValue = zeros(1,N)+inf;
[FunctionValue,Rank] = sortrows(FunctionValue);
while (sum(cz)<N) 
    MaxFront = MaxFront+1;
    d = cz;
    for i = 1 : N
        if ~d(i)%If d(i)==0
            for j = i+1 : N
                if ~d(j)
                    k = 1;
                    for m = 2 : M
                        if FunctionValue(i,m) > FunctionValue(j,m)
                            k = 0;%Means j is better
                            break;
                        end
                    end 
                    if k == 1
                        d(j) = 1;%Means i is better
                    end
                end
            end
            FrontValue(Rank(i)) = MaxFront;
            cz(i) = 1;
        end
    end
end
end


