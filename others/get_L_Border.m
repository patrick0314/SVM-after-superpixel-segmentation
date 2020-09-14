function [ output ] = get_L_Border( label )
%GET_L_BORDER get the labeled superpixel borders 
%   Input: A segmented image. All pixels in each region are labeled
%          by an integer.
%   Output: The superpixel borders are represented by their label and 0
%           means interior regions

    [h, w] = size(label);
    R0 = label;
    border = get_Border( R0 );
    minL = min(R0(:));
    maxL = max(R0(:));
    L_border = zeros(h,w);
        
    for k = minL : maxL
        if find(R0 == k)
            tmp = (R0==k) + border;
            L_border = (tmp==2)*k + (tmp~=2).*L_border;
        end
        clear tmp
    end  
    
    clear maxL minL k
    output = L_border;

end

