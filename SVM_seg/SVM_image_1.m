function [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_1(segments, predicted, stage, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV)
    maxL = size(adj, 1) ;
    predicted = reshape(predicted, [maxL, maxL]) ;
    for i = 1:maxL
        for j = 1:maxL
            if predicted(i, j) ~= predicted(j, i)
                disp('wrong') ;
            end
        end
    end
    
    tmp = segments ;
    break_while = false ;
    if stage == 1
        [val, loc] = sort(predicted(:)) ;
        for order = 1:20
            [i, j] = ind2sub(size(predicted), loc(order)) ;
            if (i > j) && contact_rate(i, j) >= 0.05 && Edge(i, j).Rate80 <= 0.6 
                region_i = (segments==i) ;
                region_j = (segments==j) ;
                tmp_region_i = sum(sum(tmp(region_i))) / sum(sum(region_i)) ;
                tmp_region_j = sum(sum(tmp(region_j))) / sum(sum(region_j)) ;
                if isnan(tmp_region_j) || isinf(tmp_region_j)
                    %break_while = true ;
                    break ;
                end
                if isnan(tmp_region_i) || isinf(tmp_region_i)
                    %break_while = true ;
                    break ;
                end
                [tmp, Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj] = updated(tmp, tmp_region_i, tmp_region_j, Hist, HistDiff,area,Edge,DTex,LabIm,meanCC,textureImg,meanLGTex,SaliencyMap,meanSaliency,adj,LongContourMap25,LongContourMap80,edge_map) ;
            end
        end     
    elseif stage == 2
        for i = 1:maxL
            for j = i+1:maxL
                if predicted(i, j) == 1
                    region_i = (segments==i) ;
                    region_j = (segments==j) ;
                    tmp_region_i = sum(sum(tmp(region_i))) / sum(sum(region_i)) ;
                    tmp_region_j = sum(sum(tmp(region_j))) / sum(sum(region_j)) ;
                    if isnan(tmp_region_j) || isinf(tmp_region_j)
                        %break_while = true ;
                        break ;
                    end
                    if isnan(tmp_region_i) || isinf(tmp_region_i)
                        %break_while = true ;
                        break ;
                    end
                    [tmp, Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj] = updated(tmp, tmp_region_i, tmp_region_j, Hist, HistDiff,area,Edge,DTex,LabIm,meanCC,textureImg,meanLGTex,SaliencyMap,meanSaliency,adj,LongContourMap25,LongContourMap80,edge_map) ;
                end
            end
        end
    end
    clear region_j ;
    
    if segments == tmp
        break_while = true ;
    end
    
    segments = tmp ;
    tmp = RenewLabel(tmp) ;
end