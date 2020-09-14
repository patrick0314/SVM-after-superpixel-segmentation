function [area,LabHist]=get_Region_Initial_Info(segments,quanImg,totalBins)
% Output:
%    area: (1xRegionNum) the area of each segment, number of pixel in the region
%    LabHist:  (RegionNumx1) cell type, cell_i means the region_i's quantImg histogram
    maxL = max(segments(:)) ;
    area = zeros(1, maxL) ;
    LabHist = cell(maxL, 1) ;
    for i = 1:maxL
        ind = find(segments==i) ; % list of index of region_i
        area(i) = length(ind) ; % number of pixel in superpixel
        LabHist{i}= hist(quanImg(ind), 1:totalBins) ;
    end
end

        
        