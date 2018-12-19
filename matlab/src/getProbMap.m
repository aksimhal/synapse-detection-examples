function data = getProbMap(data, mask)
% Create Foreground Probablities
% data = getProbMap(data, mask)

data = double(data);

for z=1:size(data, 3)
    % Mask Image
    img = data(:, :, z);
    imgvec = img(:);
    
    if (mask ~= -1)
        maskSlice = mask(:, :, z);
        maskvec = maskSlice(:);
        imgvec(maskvec == 0) = [];
    end
    
    
    % Calculate foreground probabilities
    %imgvec(imgvec < (mean(imgvec) + alpha*std(double(imgvec)))) = [] ;
    probImg = normcdf(double(img), mean(imgvec), std(double(imgvec)));
    
    data(:, :, z) = probImg;
    
    %disp(mean(probImg(:))) 
    
end

end
