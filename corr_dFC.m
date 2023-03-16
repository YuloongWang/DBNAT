function w_corr = corr_dFC(ROISignals,kernel,s,method)
% input data size: time series * brain region
% output data size: corr matrix row * corr matrix column * number of windows
% dFCmethod: sliding window
%            tapered sliding window
%            temporal derivatives
%            correlation''s correlation
%% 
if strcmp(method,'sliding window')
    l = length(kernel);
    [T,N] = size(ROISignals(:,:,1));
    w_corr = zeros(N,N,floor((T - l) / s) + 1);
    for i = 1 : floor((T - l) / s) + 1
        idx1 = (i - 1) * s + 1;
        idx2 = (i - 1) * s + l;
        w_corr(:,:,i) = corr(ROISignals(idx1:idx2,:));
    end
elseif strcmp(method,'tapered sliding window')
    x = 1:1:length(kernel);
    gaussian_kernel = gaussmf(x,[3*length(kernel)/20 length(x)/2]);
    l = length(gaussian_kernel);
    [T,N] = size(ROISignals(:,:,1));
    w_corr = zeros(N,N,floor((T - l) / s) + 1);
    for i = 1 : floor((T - l) / s) + 1
        idx1 = (i - 1) * s + 1;
        idx2 = (i - 1) * s + l;
        w_corr(:,:,i) = weightedcorrs(ROISignals(idx1:idx2,:),gaussian_kernel);
    end
elseif strcmp(method,'correlation''s correlation')
    l = length(kernel);
    [T,N] = size(ROISignals(:,:,1));
    w_corr = zeros(N,N,floor((T - l) / s) + 1);
    for i = 1 : floor((T - l) / s) + 1
        idx1 = (i - 1) * s + 1;
        idx2 = (i - 1) * s + l;
        w_corr(:,:,i) = corr(corr(ROISignals(idx1:idx2,:)));
    end
elseif strcmp(method,'temporal derivatives')
    w_corr = coupling(ROISignals,length(kernel));
end


end
