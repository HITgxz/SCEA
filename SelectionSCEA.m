function Population = SelectionSCEA(Population,N)
    [FrontNo,MaxFNo] = NDSort(Population.objs,N);
    Next = false(1,length(FrontNo));
    Next(FrontNo<MaxFNo) = true;
    PopObj = Population.objs;
    fmax   = max(PopObj(FrontNo==1,:),[],1);
    fmin   = min(PopObj(FrontNo==1,:),[],1);
    PopObj = (PopObj-repmat(fmin,size(PopObj,1),1))./repmat(fmax-fmin,size(PopObj,1),1);
    Last = find(FrontNo==MaxFNo);
    del  = Truncation(PopObj(Last,:),length(Last)-N+sum(Next));
    Next(Last(~del)) = true;
    Population = Population(Next);
end

function Del = Truncation(PopObj,K)
    N = size(PopObj,1);
    Distance = pdist2(PopObj,PopObj);
    Distance(logical(eye(length(Distance)))) = inf;
    Del = false(1,N);
    while sum(Del) < K
        Remain   = find(~Del);
        Temp     = sort(Distance(Remain,Remain),2);
        [~,Rank] = sortrows(Temp);
        Del(Remain(Rank(1))) = true;
    end
end