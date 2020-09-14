function [model] = boost(label, feature)
    % random seed
    randidx = randperm(size(label, 1)) ;
    randidx1 = randidx(1:round((9/10)*length(randidx))) ;
    randidx2 = randidx(round((9/10)*length(randidx)):length(randidx)) ;
    
    % validation data
    train_data = feature(randidx1, 1:3) ;
    val_data = feature(randidx2, 1:3) ;
    train_label = label(randidx1) ;
    val_label = label(randidx2) ;
    
    % boost
    epoch = 1 ;
    while epoch <= 8
        disp(['epoch: ', num2str(epoch)]) ;
        model = svmtrain(train_label, train_data,'-c 1 -g 0.07 -h 0') ;
        [predicted, accuracy, d_values] = svmpredict(val_label, val_data, model) ;
        for i = 1:length(predicted)
            if predicted(i) ~= val_label(i)
                train_label = cat(1, train_label, val_label(i)) ;
                train_data = cat(1, train_data, val_data(i, 1:3)) ;
            end
        end
        epoch = epoch + 1 ;
    end
    
end