%classdef SCEA < ALGORITHM
        function main(Algorithm,Problem)
            Population    = Problem.Initialization();
            while Algorithm.NotTerminated(Population)
                Offspring1 = [];
                PopObj = Population.objs;
                [FrontNo,MaxFNo] = NDSort(Population.objs,Problem.N);
                Winner = [];
                Winner = find(FrontNo==1);
                [~,Nwin]  = size(Winner);
                KSetlos=cell(Nwin,1);
                KNSet = zeros(Nwin,Problem.N);
                for i=1:Problem.N
                    for j=1:Nwin
                        Currentcenter = Winner(:,j);
                        if i == Currentcenter
                            K(j) = 0;
                        else
                            K(j)   =   pdist2(Population(i).dec, Population(Currentcenter).dec);
                        end
                        [~, index] = min(K); % ~=value
                        KNSet(index,i)=i;
                    end
                end
                Loscell = cell(Nwin,1);
                LoseSet = cell(Nwin,1);
                for i=1:Nwin
                    Loscell(i) = {nonzeros(KNSet(i,:))};
                end
                for i=1:Nwin
                    LoseSet(i) = {setdiff(Loscell{i,:},Winner)};
                    if length(LoseSet{i,:})<1
                        LoseSet(i) = {randperm(length(Population),1)};
                    end
                end
                neighbor = length(LoseSet);
                for i=1:Nwin
                    LoserS = LoseSet{i,:};
                    LoserS = LoserS';
                    if rand<0.5
                    WinnerS = Winner(:,i);
                    else
                    WinnerS = Winner(randi(numel(Winner),1,1));
                    end
                    Offspring      = Operator(Population(LoserS),Population(WinnerS));
                    Offspring1 = [Offspring1 Offspring];
                end
                Population = SelectionSCEA([Population,Offspring1],Problem.N);
            end
        end
    end
end

function Fitness = calFitness(PopObj)
N      = size(PopObj,1);
fmax   = max(PopObj,[],1);
fmin   = min(PopObj,[],1);
PopObj = (PopObj-repmat(fmin,N,1))./repmat(fmax-fmin,N,1);
Dis    = inf(N);
for i = 1 : N
    SPopObj = max(PopObj,repmat(PopObj(i,:),N,1));
    for j = [1:i-1,i+1:N]
        Dis(i,j) = norm(PopObj(i,:)-SPopObj(j,:));
    end
end
Fitness = min(Dis,[],2);
end
