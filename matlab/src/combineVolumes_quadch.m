%% Colocalize a postsynaptic volume with multiple presynaptic volumes
function outputVol = combineVolumes_quadch(baseVol, presynapticVolList, ...
    postsynapticVolList, baseThresh, edge_win, search_win)

% search_win must be even

% Allocate memory
outputVol = zeros(size(baseVol));

% Create lookup tables
for volItr=1:length(presynapticVolList)
    for n=1:size(baseVol, 3)
        presynapticVolList{volItr}(:, :, n) = cumsum(cumsum(presynapticVolList{volItr}(:, :, n), 2), 1);
    end
end

% Create lookup tables
for volItr=1:length(postsynapticVolList)
    for n=1:size(baseVol, 3)
        postsynapticVolList{volItr}(:, :, n) = cumsum(cumsum(postsynapticVolList{volItr}(:, :, n), 2), 1);
    end
end

disp('starting to loop through each slice');
% Loop through each slice
for zInd = 1:size(baseVol, 3)
    
    img = baseVol(:, :, zInd) > baseThresh;
    imgvec = find(img==1);
    
    [r, c] = ind2sub(size(img), imgvec);
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
        
        searchgrid = zeros(27, length(presynapticVolList));
        ind = 1;
        
        if (zInd == 1)
            zrange = 1:2;
        elseif (zInd == size(baseVol, 3))
            zrange = (size(baseVol, 3) - 1):size(baseVol, 3);
        else
            zrange = (zInd-1):(zInd+1);
        end
        
        
        % PRESYNAPTIC CHANNEL
        for z=zrange
            rstart = r(n) - 1.5*search_win;
            for row = 1:3
                cstart = c(n) - 1.5*search_win;
                for col = 1:3
                    for volItr=1:length(presynapticVolList)
                        sumIF1 = ...
                            presynapticVolList{volItr}(rstart+search_win, cstart+search_win, z) + ...
                            presynapticVolList{volItr}(rstart, cstart, z) - ...
                            presynapticVolList{volItr}(rstart+search_win, cstart, z) - ...
                            presynapticVolList{volItr}(rstart, cstart + search_win, z);
                        
                        searchgrid(ind, volItr) = sumIF1/(search_win * search_win);
                    end
                    ind = ind + 1;
                    cstart = cstart + search_win;
                end
                rstart = rstart + search_win;
            end
        end
        
        % POSTSYNAPTIC CHANNEL
        localizationGrid = zeros(length(postsynapticVolList), 1);
        
        rstart = r(n) - search_win/2;
        cstart = c(n) - search_win/2;
        
        for volItr=1:length(postsynapticVolList)
            sumIF1 = postsynapticVolList{volItr}(rstart+search_win, cstart+search_win, zInd) + ...
                postsynapticVolList{volItr}(rstart, cstart, zInd) - ...
                postsynapticVolList{volItr}(rstart+search_win, cstart, zInd) - ...
                postsynapticVolList{volItr}(rstart, cstart + search_win, zInd);
            
            localizationGrid(volItr) = sumIF1/(search_win * search_win);
        end
        
        
        % Find the max of the first presynaptic channel
        [~, max_ind] = max(searchgrid(:, 1));
        outputVol(r(n), c(n), zInd) = baseVol(r(n), c(n), zInd) * ...
            prod(searchgrid(max_ind, :)) * prod(localizationGrid);
        
    end
    fprintf('slice %d calculuated \n ', zInd);
end

end