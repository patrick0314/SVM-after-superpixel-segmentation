function [Hist,HistDiff,area,Edge]=GetScoreData00(label,LongContourMap25,LongContourMap80,edge_map,adj,quanImg,totalBins)

    [area,Hist]=get_Region_Initial_Info(label,quanImg,totalBins);
    maxL=max(label(:));
    HistDiff=inf(maxL,maxL);
    Edge=repmat(struct('Rate25',0,'Rate80',0,'Strength',0),maxL,maxL);
    L_border = get_L_Border( label );    
    %stat = regionprops(label,'area');  % Get segment areas
    %area = cat(1, stat.Area);
    for i=1:maxL
        if find(label==i)
            neighbor=find(adj(i,:));
            SizeNeighbor=length(neighbor);
            H1=sqrt(Hist{i}/area(i));
            for k=1:SizeNeighbor
                if HistDiff(i,neighbor(k))~=inf
                    continue;
                end                            
                H2=sqrt(Hist{neighbor(k)}/area(neighbor(k)));            
                HistDiff(i,neighbor(k))=-(H1*H2'+0.000001);   % more similar -> smaller
                HistDiff(neighbor(k),i)=HistDiff(i,neighbor(k));
            
                adjBorder= get_Adj_Border( L_border, i, neighbor(k)); % common superpixel boundary of two adjacent regions
                BndInd=find(adjBorder);
                Edge(i,neighbor(k)).Rate25=sum(LongContourMap25(BndInd))/length(BndInd);
                Edge(neighbor(k),i).Rate25=Edge(i,neighbor(k)).Rate25;
                Edge(i,neighbor(k)).Rate80=sum(LongContourMap80(BndInd))/length(BndInd);
                Edge(neighbor(k),i).Rate80=Edge(i,neighbor(k)).Rate80;
                Edge(i,neighbor(k)).Strength=sum(edge_map(BndInd))/length(BndInd);
                Edge(neighbor(k),i).Strength=Edge(i,neighbor(k)).Strength;
    
            end
        end
    end
    
end