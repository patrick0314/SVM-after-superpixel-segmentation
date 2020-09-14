function [ output ] = get_L_Interior( label )
%GET_L_INTERIOR get the labeled superpixel interior region    
%   Input: A segmented image. All pixels in each region are labeled
%          by an integer.
%   Output: The superpixel interior region are represented by their label and
%           0 means borders

    %%% 取得不含邊界的 superpixels ( 邊界設定為零 )    
    [h w] = size(label);
    R0 = label;
    border = get_Border( R0 );
    interior = ~border;
    minL = min(R0(:));
    maxL = max(R0(:));
    L_Interior = zeros(h,w);
        
    for k = minL : maxL
        if find(R0 == k)
            tmp = (R0==k) + interior;
            L_Interior = (tmp==2)*k + (tmp~=2).*L_Interior;
        end
        clear tmp
    end  
    
    clear maxL minL k

    output = L_Interior;
end

