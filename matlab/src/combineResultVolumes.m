function finalResultVol = combineResultVolumes(resultVolLocations, slice_win, ...
    volSize, slicespan, numOfSubSections)

finalResultVol = zeros(volSize);

startslice = 1;

resultSectionObj = matfile(resultVolLocations{1});
sectionSize = size(resultSectionObj, 'resultVol');

endslice = startslice + sectionSize(3) - 1;

disp([startslice, endslice]);

finalResultVol(:, :, startslice:endslice) = resultSectionObj.resultVol(:, :, 1:end);

for n = 2:numOfSubSections
    
    resultSectionObj = matfile(resultVolLocations{n});
    sectionSize = size(resultSectionObj, 'resultVol');
    
    startslice = endslice - slice_win/2;
    endslice = startslice + sectionSize(3) - 1 - slice_win/2;
    
    disp([startslice, endslice]);
    
    finalResultVol(:, :, startslice:endslice) = resultSectionObj.resultVol(:, :, 2:end);
    
end




end




