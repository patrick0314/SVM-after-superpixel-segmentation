function [ output ] = display_mean( labels,img )

    [X Y] = size(labels);
    maxL = max(labels(:));
    minL = min(labels(:));
    disp_img = zeros(X,Y,3);
        
    for k = minL : maxL
        if find(labels==k)
            idx = find(labels==k);
            for j=1:3
                tmp = disp_img(:,:,j); tmp1 = img(:,:,j);
                tmp(idx) = mean(tmp1(idx)); 
                disp_img(:,:,j) = tmp; 
                clear tmp tmp1;
            end
            clear j;
            clear idx;
        end
    end
    clear k
    output = disp_img;
end

