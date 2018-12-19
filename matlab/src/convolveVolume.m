function vol = convolveVolume(vol, filt)

vol = log(double(vol));

synapsinkernal = filt * filt';

for n=1:size(vol, 3)
    vol(:, :, n) = conv2(vol(:, :, n), synapsinkernal, 'same');
    %disp(mean(mean(vol(:, :, n)))); 
end

kernalsize = length(filt) * length(filt);
vol = vol ./kernalsize;
vol = exp(vol);

end
