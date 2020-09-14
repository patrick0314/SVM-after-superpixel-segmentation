function [area,abHist]=get_Region_Initial_Info_v2(segments,quanABImg,totalBins)
% Output:
%    area: (1xRegionNum) the area of each segment, number of pixel in the region
%    LabHist:  (RegionNumx1) cell type, cell_i means the region_i's quantABImg histogram
% only consider a* and b* color channels
    maxL = max(segments(:)) ;
    area = zeros(1, maxL) ;
    abHist = cell(maxL, 1) ;
    for i = 1:maxL
        ind = find(segments==i) ; % list of index of region_i
        area(i) = length(ind) ; % number of pixel in the region
        abHist{i} =  hist(quanABImg(ind), 1:totalBins) ;
    end
end

        
        