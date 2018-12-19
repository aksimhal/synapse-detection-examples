function resultVol = runQuery(query, synapticVolumes)
% Load each channel
% Convolve
% Factor
% combineVolumes
% 
% Input Parameters
% -------------
% query
% synapticVolumes


% Parameters
blobSize = 2; 
search_win = 2; 
edge_win = 8; 

% Threshold the base channel for computational simplicity
baseThresh = 0.5;

% minumum blob size
convWindow = ones(blobSize, 1);

% Load presynaptic channels
presynapticVolumes = synapticVolumes.presynapticVolumes;
postsynapticVolumes = synapticVolumes.postsynapticVolumes;
caseNum = 0;

for n=1:length(presynapticVolumes)
    
    % There are no presynaptic channels
    if strcmp(query.preIF{n}, 'NULL')
        caseNum = 3;
        break;
    end
    
    rawVol = presynapticVolumes{n};
    
    % convert to prob space
    probVol = getProbMap(rawVol, -1);
    
    % convolve volumes
    disp('Convolve volumes');
    convVol = convolveVolume(probVol, convWindow);
    disp('Convolved volumes');
    clear probVol;
    
    disp('Calculating 3D Factor...');
    if (query.preIF_z(n) == 2)
        factorVol = computeFactor_2(convVol);
        convVol = convVol .* factorVol;
    elseif(query.preIF_z(n) == 3)
            factorVol = computeFactor(convVol);
            convVol = convVol .* factorVol;
    end
    
    presynapticVolumes{n} = convVol;
    disp('volume preprocessed');
end


for n=1:length(postsynapticVolumes)
    
    % There are no postsynaptic channels
    if strcmp(query.postIF{n}, 'NULL')
        caseNum = 4;
        break;
    end
    
    rawVol = postsynapticVolumes{n};

    % convert to prob space
    probVol = getProbMap(rawVol, -1);
    
    % convolve volumes
    disp('Convolve volumes');
    convVol = convolveVolume(probVol, convWindow);
    disp('Convolved volumes');
    clear probVol;
    
    disp('Calculating 3D Factor...');
    
    if (query.postIF_z(n) == 2)
        factorVol = computeFactor_2(convVol);
        convVol = convVol .* factorVol;
    elseif(query.postIF_z(n) == 3)
        factorVol = computeFactor(convVol);
        convVol = convVol .* factorVol;
    end
    
    postsynapticVolumes{n} = convVol;
    disp('volume preprocessed');
    
end

if (caseNum == 0)
    if length(query.postIF) > 1
        caseNum = 2;
    else
        caseNum = 1;
    end
end

fprintf('about to start case %d \n', caseNum);

switch caseNum
    
    case 1
        % CASE 1 -> 1-POST, N-PRE
        resultVol = combineVolumes2(postsynapticVolumes{1}, presynapticVolumes, ...
            baseThresh, edge_win, search_win);
        
    case 2
        % CASE 2 -> M-POST, N-PRE (M > 1)
        resultVol = combineVolumes_quadch(postsynapticVolumes{1}, presynapticVolumes, ...
            postsynapticVolumes(2:end), baseThresh, edge_win, search_win);
        
    case 3
        % CASE 3 -> N-POST
        resultVol = combineVolumes_oneside(postsynapticVolumes{1}, postsynapticVolumes(2:end), ...
            baseThresh, edge_win, search_win);
        
    case 4
        %CASE 4 -> N-PRE
        resultVol = combineVolumes_oneside(presynapticVolumes{1}, presynapticVolumes(2:end), ...
            baseThresh, edge_win, search_win);
end

fprintf('case %d completed \n', caseNum);

end
