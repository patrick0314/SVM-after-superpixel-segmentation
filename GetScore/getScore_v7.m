function [score]=getScore_v7(segments,HistDiff,Edge,DTex,adj)

maxL=max(segments(:));
score=inf(maxL,maxL);
for L1=1:maxL
    if find(segments==L1)
        neighbor=find(adj(L1,:));
        SizeNeighbor=length(neighbor);
        for k=1:SizeNeighbor
            if score(L1,neighbor(k))~=inf
                continue;
            end
            score(L1,neighbor(k))= HistDiff(L1,neighbor(k))+Edge(neighbor(k),L1).Rate80+2*Edge(L1,neighbor(k)).Strength+2*DTex(L1,neighbor(k));
            score(neighbor(k),L1) = score(L1,neighbor(k));             
        end
    end
end