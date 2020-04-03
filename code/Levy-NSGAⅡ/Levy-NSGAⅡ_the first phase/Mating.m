function MatingPool = Mating(Y,FrontValue,CrowdDistance)
% Mating pool selection
% Binary league selection
MatingPool = zeros(Y,1);

for j=1:2
    n=1;
    Pointer = 1;
    Rank = randperm(Y);%Randomly sort N numbers
    for i = 1 : 2 : Y%For every two adjacent individuals
        %Choose parents
        k = zeros(1,1);
        p = Rank(Pointer);
        q = Rank(Pointer+1);
        %Choose the better one
        if FrontValue(p) < FrontValue(q)
            k(1) = p;
        elseif FrontValue(p) > FrontValue(q)
            k(1) = q;
        elseif CrowdDistance(p) > CrowdDistance(q)
            k(1) = p;
        else
            k(1) = q;
        end
        MatingPool(n+(j-1)*Y/2,:) = k(1);
        Pointer = Pointer+2;
        n=n+1;
    end
    %Add into the mating pool
end
end

