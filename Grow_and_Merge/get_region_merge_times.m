function [ output ] = get_region_merge_times( labels, FCD )
% according original superpixel loc, check its new label, let that label merge time + 1
% Input:
%    labels: region label map
%    FCD: the index of first pixel within every super-pixel
% Output:
%    output: for each superpixel, record it has merged how many times
    R0 = labels ;
    maxL = max(R0(:)) ;
    length_FCD = length(FCD);
    region_merge_times = zeros(1, maxL);
    for k = 1:length_FCD
        tmp_L = R0(FCD{k}(1), FCD{k}(2)) ;
        region_merge_times(tmp_L) = region_merge_times(tmp_L) + 1 ;
        clear tmp_L
    end
    clear k
    output = region_merge_times ;
end

