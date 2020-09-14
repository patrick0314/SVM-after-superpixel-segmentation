function DiffTable=getDiffTable(segments,Hist,area,adj)
%
%
    RegionNum = max(segments(:));
    DiffTable=ones(RegionNum);
    for i=1:RegionNum
        if find(segments==i)
            neighbor=find(adj(i,:));
            SizeNeighbor=length(neighbor);
            if SizeNeighbor>0
                for k=neighbor
                    if DiffTable(i,k)==1
                        H1=(Hist{i}/area(i));
                        H2=(Hist{k}/area(k));        
                        c1=sqrt(sum(H1.^2)); c2=sqrt(sum(H2.^2));
                        DiffTable(i,k)=1-sum(H1.*H2)/(c1*c2);
                        DiffTable(k,i)=DiffTable(i,k);
                    end
                end
            end
        end
    end
    
end
