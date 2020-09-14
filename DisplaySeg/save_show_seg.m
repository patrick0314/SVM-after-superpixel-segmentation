function save_show_seg(segments, img, Show, Save, Save_all, img_name, save_path, result_mat_path)

    Rnum = max(segments(:)) ; % number of regions
    [~, ~, imgMarkup] = segoutput(img, segments); % Red boundary
    [output] = display_mean(segments, img); % Mean color 
    [~, ~, MeanImMarkup] = segoutput(output, segments);
    %if ~exist([save_path, img_name, '\'], 'dir')
    %    mkdir([save_path, img_name, '\']) ;
    %end
    if ~exist([save_path, 'all\'], 'dir')
        mkdir([save_path, 'all\']) ;
    end
    if Show
        figure(2), imshow(uint8(imgMarkup)) ; title([img_name,'   ', num2str(Rnum)]) ; % Show boundary
        figure(3), imshow(uint8(MeanImMarkup)) ; title([img_name, num2str(Rnum)]) ; % Show mean color
    end
    if Save
        imwrite(uint8(imgMarkup), [save_path, img_name, '\', img_name, '_border_', num2str(Rnum), '.jpg'], 'JPG');  % Save the boundary
        imwrite(uint8(MeanImMarkup), [save_path, img_name, '\', img_name, '_mean_', num2str(Rnum), '.jpg'], 'JPG'); % Save the image
        if exist(result_mat_path, 'dir')
            save_name = [result_mat_path, img_name, '_80.mat'] ;
            save(save_name, 'segments') ; % Save the label
        end
    end
    if Save_all
        imwrite(uint8(imgMarkup), [save_path, 'all\', img_name, '_border_', num2str(Rnum), '.jpg'], 'JPG');  % Save the boundary
        imwrite(uint8(MeanImMarkup), [save_path, 'all\', img_name, '_mean_', num2str(Rnum), '.jpg'], 'JPG'); % Save the image
    end

    clear imgMarkup output MeanImMarkup Rnum
end