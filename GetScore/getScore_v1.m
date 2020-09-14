function [score] = getScore_v1(segments, HistDiff, area, Edge, DTex, adj)
maxL = max(segments(:)) ;
score = inf(maxL, maxL) ;

W = 200 ;
for L1 = 1:maxL
    if find(segments==L1)
        neighbor = find(adj(L1,:)) ;
        SizeNeighbor = length(neighbor) ;
        for k = 1:SizeNeighbor
            if score(L1,neighbor(k))~=inf
                continue;
            end
            minArea = min(area(L1), area(neighbor(k)));
            score(L1, neighbor(k)) = (Edge(L1,neighbor(k)).Rate25+Edge(L1,neighbor(k)).Strength+Edge(L1,neighbor(k)).Rate80*0.5)*min(minArea/W,5)...
                                    +HistDiff(L1,neighbor(k))+2*DTex(L1,neighbor(k)) ;
            score(neighbor(k),L1) = score(L1,neighbor(k)); 
        end
    end
end