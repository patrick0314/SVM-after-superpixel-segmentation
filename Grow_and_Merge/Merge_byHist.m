function [output,area,LabHist,meanLGTex] = Merge_byHist(R0, LongContourMap, textureImg, meanLGTex, area, LabHist)
    adj = FindNeighbor(R0) ; %  An adjacency matrix. If two labeled regions i and j are adjacent, then adj(i,j)=1 and adj(j,i)=1
    L_border = get_L_Border(R0) ; % The superpixel borders are represented by their label and 0 means interior regions
    SimTable = getSimTable(R0, LabHist, area, adj) ; % [regionNum, regionNum],  more similar -> larger value
    maxL = max(R0(:)) ;
    MergeR = cell(maxL, 1) ;
    for L1 = 1:maxL
        MergeR{L1} = [] ;
        if find(R0==L1)  
            [HistSim, L2] = max(SimTable(L1,:)) ; % more similar -> larger
            if HistSim~=0
                adjBorder= get_Adj_Border(L_border, L1, L2) ; % return a binary image shows where the adjacent borders are.
                GradInd = find(adjBorder) ;
                EdgeRate = sum(LongContourMap(GradInd)) / length(GradInd) ;
                L1_border_length = length(find(L_border==L1)) ; % length of edge of superpixel
                L2_border_length = length(find(L_border==L2)) ; % length of edge of most similar superpixel
                contact_rate = length(GradInd)*0.5 / min(L1_border_length, L2_border_length) ;
                if  contact_rate>=0.07 && EdgeRate<=0.3 
                    vecT1 = meanLGTex(:, L1); vecT2 = meanLGTex(:, L2);
                    Dtex = sqrt(sum(abs(vecT1-vecT2).^2)) ;
                    if Dtex<0.25
                        MergeR{L1} = [L1, L2] ;
                    end
                end
            end
        end
    end
    
    % update merging set and data
    for r=1:maxL
        if ~isempty(MergeR{r})
            tmpL= MergeR{r}(2);
            if ~isempty(MergeR{tmpL})
               if MergeR{tmpL}(2)==r                   
                   MergeR{tmpL} = [] ;
                   R0(R0==tmpL) = r ;
                   area(r) = area(r)+area(tmpL) ; area(tmpL) = 0 ;
                   LabHist{r} = LabHist{r}+LabHist{tmpL} ; LabHist{tmpL} = [] ;
                   ind = (R0==r) ;
                   for i=1:length(textureImg)
                       meanLGTex(i,r) = sum(textureImg{i}(ind)) / area(r) ;
                   end                   
               end
            end
        end
    end           
    clear MergeR
    output = R0 ;
    %output=RenewLabel(segments);

end