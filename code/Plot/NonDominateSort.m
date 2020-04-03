function [Frontvalue] = NonDominateSort(solution)


[N,M] = size(solution);
MaxFront =0;
cz = zeros(1,N);
Frontvalue = zeros(1,N)+inf;
[solution,Rank] = sortrows(solution);
while (sum(cz)<N) 
    MaxFront = MaxFront+1;
    d = cz;
    for i = 1 : N
        if ~d(i)
            for j = i+1 : N
                if ~d(j)
                    k = 1;
                    for m = 2 : M
                        if solution(i,m) > solution(j,m)
                            k = 0;
                            break;
                        end
                    end 
                    if k == 1
                        d(j) = 1;
                    end
                end
            end
            Frontvalue(Rank(i)) = MaxFront;
            cz(i) = 1;
        end
    end
end
end


