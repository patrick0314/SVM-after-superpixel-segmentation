function quanABImg=quantizeImg_v2(LabIm,A_bins,B_bins)
% Quantize A and B Color Channels 
    % 3 color channels, Lab space
    %CC1 = double(LabIm(:, :, 1)) ;  % L channel
    CC2 = double(LabIm(:, :, 2)) ;  % a channel
    CC3 = double(LabIm(:, :, 3)) ;  % b channel

    % quantize each color channel 
    %levelcc1 = 256/L_bins ; 
    levelcc2 = 256/A_bins ;
    levelcc3 = 256/B_bins ;
    %quanCC1 = floor(CC1./levelcc1) ;
    quanCC2 = floor(CC2./levelcc2) ; 
    quanCC3 = floor(CC3./levelcc3) ; 
    quanABImg = 1 + quanCC2 + quanCC3.*levelcc2 ;
end
        
        
        