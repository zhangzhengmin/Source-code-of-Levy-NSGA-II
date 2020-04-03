function [FrontValue,MaxFront] = NonDominateSort(FunctionValue)

[N,M] = size(FunctionValue);
MaxFront =0;
cz = zeros(1,N);
FrontValue = zeros(1,N)+inf;
[FunctionValue,Rank] = sortrows(FunctionValue);
while (sum(cz)<N) 
    MaxFront = MaxFront+1;
    d = cz;
    for i = 1 : N
        if ~d(i)
            for j = i+1 : N
                if ~d(j)
                    k = 1;
                    for m = 2 : M
                        if FunctionValue(i,m) > FunctionValue(j,m)%
                            k = 0;
                            break;
                        end
                    end
                    if k == 1
                        d(j) = 1;
                    end
                end
            end
            FrontValue(Rank(i)) = MaxFront;
            cz(i) = 1;
        end
    end
end
end


