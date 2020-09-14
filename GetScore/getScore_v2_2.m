function [score]=getScore_v2_2(segments,HistDiff,area,Edge,DTex,meanCC,adj)
maxL = max(segments(:)) ;
score = inf(maxL, maxL) ;
W = 600 ;
for L1 = 1:maxL
    if find(segments==L1)
        neighbor = find(adj(L1,:)) ;
        SizeNeighbor = length(neighbor) ;
        Labstd = [meanCC(1,L1), meanCC(2,L1), meanCC(3,L1)]; % mean Lab of the region L1
        for k = 1:SizeNeighbor
            if score(L1,neighbor(k))~=inf
                continue;
            end
            Labsample = [meanCC(1,neighbor(k)), meanCC(2,neighbor(k)), meanCC(3,neighbor(k))] ; % mean Lab of the neighbor region of L1
            de00 = deltaE2000(Labstd, Labsample, [20,1,1]) ; % color difference between Labstd and Labsample      
            minArea = min(area(L1), area(neighbor(k))) ;
            if de00 < 10 && minArea > 500
                score(L1, neighbor(k)) =  (Edge(L1,neighbor(k)).Strength*5+Edge(L1,neighbor(k)).Rate25*0.5)*min(minArea/W,2)...                                  
                                        +HistDiff(L1,neighbor(k))+2*DTex(L1,neighbor(k)) ;
                score(neighbor(k), L1) = score(L1,neighbor(k)) ;
            elseif minArea < 500
                score(L1, neighbor(k)) = -5 ;
                score(neighbor(k), L1) = score(L1,neighbor(k)) ;
            else
                score(L1, neighbor(k)) = 10 ;
                score(neighbor(k), L1) = score(L1,neighbor(k)) ;
            end
        end
    end
end