function [output] = FindNeighbor(segments)
%Output: 
%    An adjacency matrix. If two labeled regions i and j are
%	 adjacent, then adj(i,j)=1 and adj(j,i)=1. Otherwise, they
%	 are zeros.
    numSegments = max(max(segments)) + 1 ;
    [w, h] = size(segments) ;
    adj = eye(numSegments) ;
    hseg = segments(:, [2:h, h]) ; % horizontal left shift one pixel
    vseg = segments([2:w, w], :) ; % vertical up shift one pixel
    f1 = find(hseg~=segments) ; % compare hseg with original
    f2 = find(vseg~=segments) ; % compare vseg with original
    adj(segments(f1)*numSegments+hseg(f1)+1) = 1 ;
    adj(segments(f2)*numSegments+vseg(f2)+1) = 1 ;
    adj = max(adj, adj') - eye(numSegments) ;
    [R, C]  = size(adj) ;
    output = adj(2:R, 2:C) ;

end
