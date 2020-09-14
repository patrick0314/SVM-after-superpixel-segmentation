function [gt_imgs gt_cnt] = view_gt_segmentation(img, name, out_path, img_name, save)

gt_imgs = readSegs('BSDS300', 'color', name) ; % return a cell array of segmentations of an image
gt_path = fullfile(out_path, img_name, '\', 'gt\') ; 
if save
    mkdir(gt_path) ;
end

gt_cnt = [] ;
for i = 1:size(gt_imgs, 2)
    if save == 1
    % Outputs: imgMasks - An image where every pixel is assigned an integer 
    %           such that pixels sharing numbers belong to the same segment
    %          imgMarkup - The same image as the inputs with the red channel 
    %           set to 1 along the borders of segments
    %          segOutline - A white background with black lines indicating the 
    %           segments borders
        %[imgMasks, segOutline, imgMarkup] = segoutput(img, gt_imgs{i}) ;
        [~, imgMarkup] = segoutput(img, gt_imgs{i}) ;
        imwrite(imgMarkup, fullfile(gt_path, [img_name, '_', int2str(i), '.jpg'])) ; 
    end
    gt_cnt(i) = max(gt_imgs{i}(:)) ;
end
