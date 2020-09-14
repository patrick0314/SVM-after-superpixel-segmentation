function [label, features, contact_rate, dSV] = SVM_seg_4(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency)

    % find label
    gt_imgs = readSegs('BSDS300', 'color', BSDS_INFO(1, idx)) ;
    maxL = size(adj, 1) ;
    label_all = [] ;
    for k = 1:length(gt_imgs)
        gt_tmp = gt_imgs{k} ;
        label = zeros(maxL, maxL) ;
        for i = 1:maxL
            if find(segments==i)
                neighbor = find(adj(i, :)) ;
                SizeNeighbor = length(neighbor) ;
                for j = 1:SizeNeighbor
                    tmp1 = round(sum(gt_tmp(segments==i)) / area(i)) ;
                    tmp2 = round(sum(gt_tmp(segments==neighbor(j))) / area(neighbor(j))) ;
                    if tmp1 == tmp2
                        label(i, neighbor(j)) = 1 ;
                    end
                end
            end
        end
        label_all = cat(2, label_all, label(:)) ;
    end
    label = (mean(label_all')>=0.5)' ;
    label = double(label) ;
    
    % input data dim changing
    minArea = zeros(maxL, maxL) ;
    de00 = zeros(maxL, maxL) ;
    dSV = zeros(maxL, maxL) ;
    contact_rate = zeros(maxL, maxL) ;
    L_border = get_L_Border(segments);
    for i = 1:maxL
        if find(segments==i)
            neighbor = find(adj(i, :)) ;
            SizeNeighbor = length(neighbor) ;
            Labstd = [meanCC(1,i), meanCC(2,i), meanCC(3,i)] ;
            for j = 1:SizeNeighbor
                minArea(i, neighbor(j)) = min(area(i), area(neighbor(j))) ;
                Labsample = [meanCC(1, neighbor(j)), meanCC(2, neighbor(j)), meanCC(3, neighbor(j))] ; % mean Lab of the neighbor region of L1
                de00(i, neighbor(j)) = deltaE2000(Labstd, Labsample, [20, 1, 1]) ;
                dSV(i, neighbor(j)) = abs(meanSaliency(i) - meanSaliency(neighbor(j))) ;
                
                adjBorder = get_Adj_Border(L_border, i, neighbor(j)) ;
                BndInd = find(adjBorder) ;
                L1_border_length = length(find(L_border==i)) ;
                L2_border_length = length(find(L_border==neighbor(j))) ;
                contact_rate(i, neighbor(j)) = length(BndInd)*0.5 / min( L1_border_length, L2_border_length) ;
            end
        end
    end
    minArea_f = minArea(:) ;
    W = 1200 ;
    a = max(1, W./minArea) ;
    b = 0.2 ;
    c = max(2, a*2) ;
    c = replace(c) ;
    % (1-b)*HistDiff(L1,neighbor(k))
    HistDiff_f = HistDiff(:) ;
    % minArea/W*(Edge(L1,neighbor(k)).Strength+Edge(L1,neighbor(k)).Rate25)+Edge(L1,neighbor(k)).Rate80
    Edge_f1 = zeros(maxL, maxL) ;
    Edge_f2 = zeros(maxL, maxL) ;
    Edge_f3 = zeros(maxL, maxL) ;
    for i = 1:maxL
        if find(segments==i)
            neighbor = find(adj(i, :)) ;
            SizeNeighbor = length(neighbor) ;
            for j = 1:SizeNeighbor                
                Edge_f1(i, neighbor(j)) = de00(i, neighbor(j)) * Edge(i, neighbor(j)).Strength ;
                Edge_f2(i, neighbor(j)) = (1 + HistDiff(i ,neighbor(j))) * Edge(i, neighbor(j)).Rate25 ;
                Edge_f3(i, neighbor(j)) = 0.4 * Edge(i, neighbor(j)).Rate80 ;
            end
        end
    end
    Edge_f1 = Edge_f1(:) ;
    Edge_f2 = Edge_f2(:) ;
    Edge_f3 = Edge_f3(:) ;
    % c*DTex(L1,neighbor(k))
    DTex_f = 2 .* DTex(:) ;
    
    % b*de00
    de00_f = b .* de00(:) ;
    
    contact_rate_f = contact_rate(:) ;
    
    dSV_f = dSV(:) ;
    
    % features concatenate and scaling
    features = cat(2, HistDiff_f, Edge_f1, Edge_f2, Edge_f3, DTex_f, dSV_f) ;
    features = replace(features) ;
    mean_f = mean(features) ;
    nrm = diag(1./std(features, 1)) ;
    features = (features - ones(maxL*maxL, 1)*mean_f) * nrm ;
    
end