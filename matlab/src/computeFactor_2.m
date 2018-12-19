function factorVol = computeFactor_2(vol)
beta = 1; 
factorVol = zeros(size(vol));
for n=1:size(vol, 3)
    
    if n == 1
        
        diff = exp(-beta*((vol(:, :, n) - vol(:, :, n+1)).^2));
        factorVol(:, :, n) = diff;
        
    elseif n == size(vol, 3)
        diff = exp(-beta*((vol(:, :, n) - vol(:, :, n-1)).^2));
        factorVol(:, :, n) = diff;
        
    else
        diff = exp(-beta*((vol(:, :, n) - vol(:, :, n+1)).^2)) ;
        factorVol(:, :, n) = diff;
    end
    
end


end

