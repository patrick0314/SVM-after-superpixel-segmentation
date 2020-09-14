function [score]=getScore_v5(segments,HistDiff,area,Edge,DTex,meanCC,adj)

maxL=max(segments(:));
score=inf(maxL,maxL);
W=1200;
for L1=1:maxL
    if find(segments==L1)
        neighbor=find(adj(L1,:));
        SizeNeighbor=length(neighbor);
        Labstd=[meanCC(1,L1),meanCC(2,L1),meanCC(3,L1)];
        for k=1:SizeNeighbor
            if score(L1,neighbor(k))~=inf
                continue;
            end
            Labsample=[meanCC(1,neighbor(k)),meanCC(2,neighbor(k)),meanCC(3,neighbor(k))];
            de00=deltaE2000(Labstd, Labsample,[20,1,1]); 
            
            minArea=min(area(L1),area(neighbor(k)));  
            score(L1,neighbor(k))= Edge(neighbor(k),L1).Rate80*(1+HistDiff(L1,neighbor(k)))*DTex(L1,neighbor(k))+Edge(L1,neighbor(k)).Strength*de00...
                                   -W/minArea+2*DTex(L1,neighbor(k))+HistDiff(L1,neighbor(k))+ Edge(neighbor(k),L1).Rate25;

            score(neighbor(k),L1) = score(L1,neighbor(k));
        end
    end
end