%% Colocalize a single synaptic side
function outputVol = combineVolumes_oneside(baseVol, targetVolList, ...
    baseThresh, edge_win, search_win)

% search_win must be even

% Allocate memory
outputVol = zeros(size(baseVol));

% Create lookup tables
for volItr=1:length(targetVolList)
    for n=1:size(baseVol, 3)
        targetVolList{volItr}(:, :, n) = cumsum(cumsum(targetVolList{volItr}(:, :, n), 2), 1);
    end
end

disp('starting to loop through each slice');
% Loop through each slice
for zInd = 1:size(baseVol, 3)
    
    img = baseVol(:, :, zInd) > baseThresh;
    imgvec = find(img==1);
    
    [r, c] = ind2sub(size(img), imgvec);
    
    % Avoid edges
    for n=1:length(r)
        if r(n)-edge_win < 1
            continue;
        elseif r(n) + edge_win > size(img, 1)
            continue;
        elseif c(n) - edge_win < 1
            continue;
        elseif c(n) + edge_win > size(img, 2)
            continue;
        end
        
        localizationGrid = zeros(length(targetVolList), 1);
        
        rstart = r(n) - search_win/2;
        cstart = c(n) - search_win/2;
        
        for volItr=1:length(targetVolList)
            % populate each square in the grid
            sumIF1 = targetVolList{volItr}(rstart+search_win, cstart+search_win, zInd) + ...
                targetVolList{volItr}(rstart, cstart, zInd) - ...
                targetVolList{volItr}(rstart+search_win, cstart, zInd) - ...
                targetVolList{volItr}(rstart, cstart + search_win, zInd);
            % Normalize value
            localizationGrid(volItr) = sumIF1/(search_win * search_win);
        end
        
        outputVol(r(n), c(n), zInd) = prod(localizationGrid) * baseVol(r(n), c(n), zInd);
        
    end
    fprintf('slice %d calculuated \n ', zInd);
    
end

end