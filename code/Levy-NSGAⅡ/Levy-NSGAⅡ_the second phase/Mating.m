function MatingPool = Mating(Y,FrontValue,CrowdDistance)
% Mating pool selection
% Binary league selection
MatingPool = zeros(Y,1);
Rank = randperm(Y);%Randomly sort N numbers
Pointer = 1;
for i = 1 : 2 : Y%For every two adjacent individuals
    %Choose parents
    k = zeros(1,2);
    for j = 1 : 2
        if Pointer >= Y
            Rank = randperm(Y);
            Pointer = 1;
        end
        p = Rank(Pointer);
        q = Rank(Pointer+1);
        %Choose the better one
        if FrontValue(p) < FrontValue(q)
            k(j) = p;
        elseif FrontValue(p) > FrontValue(q)
            k(j) = q;
        elseif CrowdDistance(p) > CrowdDistance(q)
            k(j) = p;
        else
            k(j) = q;
        end
        Pointer = Pointer+2;
    end
    %Add into the mating pool
    MatingPool(i,:) = k(1);
    MatingPool(i+1,:) = k(2);
end
end

