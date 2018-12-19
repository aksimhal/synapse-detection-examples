% Run Synapse Detection 
% Email Anish with any questions or bugs. 
% Make sure 'src' folder is in the MATLAB path 

% Load data
psd_vol = zeros(1024, 1344, 8);
synapsin_vol = zeros(1024, 1344, 8);
glur1_vol = zeros(1024, 1344, 8);

for n=0:1:7 
    fn = strcat('../data/processedandaligned_PSD95', sprintf('%02d.tif', n));
    img = imread(fn);
    psd_vol(:, :, n+1) = img;
end 
for n=0:1:7 
    fn = strcat('../data/processedandaligned_GLUR1', sprintf('%02d.tif', n));
    img = imread(fn);
    glur1_vol(:, :, n+1) = img;
end 
for n=0:1:7 
    fn = strcat('../data/processedandaligned_SYNAPSIN', sprintf('%02d.tif', n));
    img = imread(fn);
    synapsin_vol(:, :, n+1) = img;
end 

% Format into an object
synapticVolumes.presynapticVolumes = {synapsin_vol};
synapticVolumes.postsynapticVolumes = {psd_vol};


% Create query 
query.preIF = {'Synapsin'};
query.preIF_z = [2];
query.postIF = {'PSD'};
query.postIF_z = [2];

% Run synapse detection 
resultVol = runQuery(query, synapticVolumes);

% Threshold output probability map
bwVol = resultVol > 0.9; 

% Count number of connected components
CC = bwconncomp(bwVol);
disp(CC.NumObjects); 



