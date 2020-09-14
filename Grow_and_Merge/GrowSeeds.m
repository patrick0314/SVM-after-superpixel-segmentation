function [segments,IsSeed,meanCC,meanLGTex,LabHist,area]=GrowSeeds(segments,LabHist,area,textureImg,LabIm,edgeMap,complex_map,IsSeed,meanCC,meanLGTex,LongContourMap)
    
    adj = FindNeighbor(segments) ;  
    L_border = get_L_Border( segments );
    L_interior = get_L_Interior( segments ); 
    CC1 = LabIm(:,:,1) ; CC2 = LabIm(:,:,2) ; CC3 = LabIm(:,:,3) ;
    DiffTable = getDiffTable(segments, LabHist, area, adj) ;
    
    seedsL = find(IsSeed) ;
    numSeeds = length(seedsL) ;
    MergeR = cell(numSeeds,1) ;
    for i = 1:numSeeds
        MergeR{i} = [] ;
        if find(segments==seedsL(i))
            neighbor = find(adj(seedsL(i),:)) ;
            SizeNeighbor = length(neighbor) ;
            if SizeNeighbor>0
                Dist = repmat(struct('color', inf, 'tex', inf, 'score', inf, 'edge', inf, 'contact_rate', 0), SizeNeighbor, 1) ;
                for k = 1:SizeNeighbor     
                    Dist(k) = ComputeDistance(seedsL(i), neighbor(k), DiffTable, edgeMap, meanLGTex, meanCC, complex_map, L_border, L_interior, LongContourMap) ;
                end 
                tmp = struct2cell(Dist) ;
                [~, Loc] = min([tmp{3,:}]) ;
                clear tmp ;
                if  Dist(Loc).tex<=0.2 && Dist(Loc).color<=0.8
                    if Dist(Loc).edge<0.25 && Dist(Loc).contact_rate>0.02
                        MergeR{i} = [seedsL(i), neighbor(Loc)] ;     
                    end
                end                 
                clear Dist  
             end
         end
    end
    % update merging sets
    for r = 1:numSeeds
        if ~isempty(MergeR{r})
            check = 1 ;
            while check  % have merged -> check whole MergeR again
                [MergeR, IsSeed, check] = UpdateMergeSet(r, MergeR, numSeeds, IsSeed, seedsL) ;
            end
        end           
    end
    % update region info.  
    for r = 1:numSeeds
        if ~isempty(MergeR{r})           
            for ii = 1:length(MergeR{r})
                if MergeR{r}(ii)~=seedsL(r)
                    loc = (segments==MergeR{r}(ii)) ;
                    segments(loc) = seedsL(r);
                    area(seedsL(r)) = area(seedsL(r))+area(MergeR{r}(ii)) ; 
                    area(MergeR{r}(ii)) = 0 ;
                    LabHist{seedsL(r)} = LabHist{seedsL(r)}+LabHist{MergeR{r}(ii)} ; 
                    LabHist{MergeR{r}(ii)} = [] ;  
                end
            end
            ind = find(segments==seedsL(r)) ;
            s = length(ind) ;
            meanCC(1, seedsL(r)) = sum(CC1(ind)) / s ;
            meanCC(2, seedsL(r)) = sum(CC2(ind)) / s ;
            meanCC(3, seedsL(r)) = sum(CC3(ind)) / s ;
            for i = 1:length(textureImg)
               meanLGTex(i, seedsL(r)) = sum(textureImg{i}(ind)) / s ;
            end
        end
    end  
    clear MergeR
end