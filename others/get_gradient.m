function [ output ] = get_gradient( img, filter)
%GET_GRADIENT generate a gradient map by "imfilter" 
%   Input: 
%       img - A gray or color image 
%       filter - a string which apply to fspecial(filter);
%   Output: gradient map
%
    [~, ~, K] = size(img);
    I = img;
    hy = fspecial(filter); % returns 3-by-3 filter that emphasizes horizontal edges utilizing the smoothing effect by approximating a vertical gradient
    hx = hy'; % If you need to emphasize vertical edges, transpose the filter hy to hy'
    %% for color image
    if K == 3    
        IL = I(:,:,1);
        IA = I(:,:,2);
        IB = I(:,:,3);

        IyL = imfilter(double(IL), hy, 'replicate'); % 通過複製外邊界的值來擴展
        IxL = imfilter(double(IL), hx, 'replicate');
        gradmagL = sqrt(IxL.^2 + IyL.^2);

        IyA = imfilter(double(IA), hy, 'replicate'); % 通過複製外邊界的值來擴展
        IxA = imfilter(double(IA), hx, 'replicate');
        gradmagA = sqrt(IxA.^2 + IyA.^2);

        IyB = imfilter(double(IB), hy, 'replicate'); % 通過複製外邊界的值來擴展
        IxB = imfilter(double(IB), hx, 'replicate');
        gradmagB = sqrt(IxB.^2 + IyB.^2);
        
        if uint32(mean(gradmagL(:))) <= 80
            weight_L = 1.0;
            weight_A = 1.0;
            weight_B = 1.0;
        end
    
        if uint32(mean(gradmagL(:))) > 80
            weight_L = 1.2;
            weight_A = 0.9;
            weight_B = 0.9;
        end
        %total_gradmag=gradmagL +gradmagA +gradmagB ;     
        total_gradmag = (weight_L*gradmagL) + (weight_A*gradmagA) + (weight_B*gradmagB) ;
    end
    
    %% for gray image
    if K == 1
        IyL = imfilter(double(I), hy, 'replicate') ; % 通過複製外邊界的值來擴展
        IxL = imfilter(double(I), hx, 'replicate') ;
        gradmagL = sqrt(IxL.^2 + IyL.^2) ;
        total_gradmag = gradmagL ;
    end
    
    %% output
    output = total_gradmag;
end

