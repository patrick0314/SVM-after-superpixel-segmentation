function [ output ] = get_Adj_Border( L_border, L1, L2 )
%GET_ADJ_BORDER get the adjacent labeled border 
%   Input:
%       L_border - The superpixel borders are represented by their label and 0
%                  means interior regions
%       L1, L2: The labels of region 1 and region 2, respectively.
%   Output: A binary image shows where the adjacent borders are.
%           1, adjacent borders of two superpixels, L1 and L2
%           0, otherwise. 

    R0 = L_border;
    
    A = (R0 == L1);
    B = (R0 == L2);
    
    Aborder = A & ( B([1,1:end-1],:) | B([2:end,end],:) | B(:,[1,1:end-1]) | B(:,[2:end,end]) );
    Bborder = B & ( A([1,1:end-1],:) | A([2:end,end],:) | A(:,[1,1:end-1]) | A(:,[2:end,end]) );
    output=Aborder | Bborder;
end

