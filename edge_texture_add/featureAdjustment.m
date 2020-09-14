%%% feature adjustment
% parameter setting
useOld = 1 ;
blockMean = zeros(100, 3) ;
blockStd = zeros(100, 3) ;
dx = floor(size(img,1)/10) ; dy = floor(size(img,2)/10) ;
for ix = 1:10
    for iy = 1:10
        currnetsmallBlock = img( 1 + (ix-1)*dx:ix*dx, 1 + (iy-1)*dy:iy*dy, :) ;
        blockMean( (ix-1)*10 + iy, :) = reshape( mean( mean( currnetsmallBlock )), 1, []) ;
        blockStd( (ix-1)*10 + iy, :) = std( double([reshape(currnetsmallBlock(:,:,1), [], 1), ...
                                                    reshape(currnetsmallBlock(:,:,2), [], 1), ...
                                                    reshape(currnetsmallBlock(:,:,3), [], 1)] )) ;
    end
end
stdOfMean = std(blockMean) ;
meanOfStd = mean(blockStd) ;
minOfStd = min(blockStd) ;
maxOfStd = max(blockStd) ;

% check if update feature and if yes, update feature
if max(stdOfMean) < 20 && min(minOfStd) > 12.5 && min(minOfStd) < 17
    SaliencyMap = SaliencyMap .* 2 ;
    edge_map = edge_map.*4.5 + E.*0.9 ;
    useOld = 0 ;
end
if max(stdOfMean) < 30 && min(meanOfStd) > 28 && max(meanOfStd) < 33 && min(minOfStd) > 12.5
    SaliencyMap = SaliencyMap .* 3 ;
    edge_map = edge_map.*1.5 + E.*0.28 ;
    useOld = 0 ;
end
if max(stdOfMean) < 33 && min(meanOfStd) > 40 && max(meanOfStd) < 47.5 && min(minOfStd) > 10
    SaliencyMap = SaliencyMap + R0dct .* 1 ;
    FinalEdge = FinalEdge.*3 ;
    SaliencyMap = SaliencyMap.*3 ;
    edge_map = edge_map + E.*0.15 ;
    useOld = 0 ;
end
if min(stdOfMean) < 14 && min(minOfStd) > 7 && max(minOfStd) < 10
    SaliencyMap = SaliencyMap + R0dct .* 1 ;
    edge_map = edge_map.*1.5 ; edge_map = edge_map + E.*0.15 ;
    useOld = 0 ;
end
if max(stdOfMean) < 20 && max(meanOfStd) < 30 && max(minOfStd) < 5
    SaliencyMap = SaliencyMap + R0dct .* 1 ;
    edge_map = edge_map.*1.5 ;
    edge_map = edge_map + E.*0.15 ;
    useOld = 0 ;
end
if 40.6 > max(stdOfMean) && max(stdOfMean) > 40 && 23.4 > min(meanOfStd) && min(meanOfStd) > 23 && min(minOfStd) < 6
    edge_map = edge_map + E.*0.25 ;
    useOld = 0 ;
end
if max(stdOfMean) < 27 && max(maxOfStd) < 75 && min(maxOfStd) > 60 && min(minOfStd) < 5 && max(meanOfStd) < 21
    for cki=1:8
        textureImg{cki} = textureImg{cki}.*2 ;
    end
    clear cki ;
end
if max(stdOfMean) < 37 && max(meanOfStd) < 24.2 && max(minOfStd) < 3.3 && max(maxOfStd) > 81
    useOld = 0 ;
end
if max(stdOfMean) < 32.5 && min(meanOfStd) > 29 && min(minOfStd) > 12
    useOld = 0 ;
end
if max(stdOfMean) < 22 && min(meanOfStd) < 16 && min(minOfStd) < 2
    useOld = 0 ;
end
if max(stdOfMean) < 50 && min(meanOfStd) > 28 && min(minOfStd) < 0.3
    useOld = 0 ;
end
if max(stdOfMean) > 72 && min(meanOfStd) > 23 && min(minOfStd) < 0.8
    useOld = 0 ;
end

if useOld
    SaliencyMap = SaliencyMapOld ;
end

