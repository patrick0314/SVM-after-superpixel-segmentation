function E0 = useSketchToken(img)
    % load('models/forest/modelSmall.mat') ;
    load('models/forest/modelFull.mat') ;
    st = stDetect(img, model) ; % sketch token probability maps
    E0 = stToEdges(st, 1) ; % edge probability map
end