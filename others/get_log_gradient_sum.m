function [ output ] = get_log_gradient_sum( img )

[M N K] = size(img);

if K == 3    
    I = img;
    cform = makecform('srgb2lab'); 
    lab = applycform(I, cform);
    IL = lab(:,:,1);
    IA = lab(:,:,2);
    IB = lab(:,:,3);


    hyL = fspecial('log'); %邊緣提取濾波器

    hxL = hyL';
    IyL = imfilter(double(IL), hyL, 'replicate'); %通過複製外邊界的值來擴展
    IxL = imfilter(double(IL), hxL, 'replicate');
    gradmagL = sqrt(IxL.^2 + IyL.^2);

    hyA = fspecial('log'); %邊緣提取濾波器
    hxA = hyA';
    IyA = imfilter(double(IA), hyA, 'replicate'); %通過複製外邊界的值來擴展
    IxA = imfilter(double(IA), hxA, 'replicate');
    gradmagA = sqrt(IxA.^2 + IyA.^2);

    hyB = fspecial('log'); %邊緣提取濾波器
    hxB = hyB';
    IyB = imfilter(double(IB), hyB, 'replicate'); %通過複製外邊界的值來擴展
    IxB = imfilter(double(IB), hxB, 'replicate');
    gradmagB = sqrt(IxB.^2 + IyB.^2);

    if uint32(mean(gradmagL(:))) <= 40
        weight_L = 1.0;
        weight_A = 1.0;
        weight_B = 1.0;
    end
    
    if uint32(mean(gradmagL(:))) > 40
        weight_L = 1.2;
        weight_A = 0.9;
        weight_B = 0.9;
    end
    
    total_gradmag = (weight_L*gradmagL) + (weight_A*gradmagA) + (weight_B*gradmagB);
    %total_gradmag = (weight_L*gradmagL);
end

if K == 1
    I = img;
    
    hyL = fspecial('log'); %邊緣提取濾波器

    hxL = hyL';
    IyL = imfilter(double(I), hyL, 'replicate'); %通過複製外邊界的值來擴展
    IxL = imfilter(double(I), hxL, 'replicate');
    gradmagL = sqrt(IxL.^2 + IyL.^2);
    total_gradmag = gradmagL;
end


output = total_gradmag;

end

