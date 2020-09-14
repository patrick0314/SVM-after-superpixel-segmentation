function SimTable=getSimTable(segments, Hist, area, adj)
%
% SimTable: RegionNum x RegionNum,  more similar -> larger value
%
    RegionNum = max(segments(:)) ;
    SimTable = zeros(RegionNum) ;
    for i = 1:RegionNum
        if find(segments==i)
            neighbor = find(adj(i,:)) ;
            SizeNeighbor = length(neighbor) ; % number of nerghbor of ith superpixel
            if SizeNeighbor>0
                for k = neighbor
                    if SimTable(i,k)==0
                        H1 = sqrt(Hist{i}/area(i)) ;
                        H2 = sqrt(Hist{k}/area(k)) ;            
                        SimTable(i,k) = H1*H2'+0.000001 ;   % more similar -> larger
                        SimTable(k,i) = SimTable(i,k) ;
                    end
                end
            end
        end
    end
    
end
