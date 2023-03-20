function [D] = cluster_test(database_path,filemat,W,s,dFCmethod,retainprocessfiles,runs)
load([database_path,'\',filemat]);
for i = 1 : length(ROISignals_HE(1,1,:))
    dFC_HE(:,:,:,i) = corr_dFC(ROISignals_HE(:,:,i),ones(1,W),s,dFCmethod);
end
for i = 1 : length(ROISignals_PA(1,1,:))
    dFC_PA(:,:,:,i) = corr_dFC(ROISignals_PA(:,:,i),ones(1,W),s,dFCmethod);
end
[~,~,~,a4] = size(dFC_HE);
[~,~,~,b4] = size(dFC_PA);

% fprintf('组合\n');
stringname = [database_path,'\matrix_dFC_',strrep(dFCmethod,' ',''),'_W',num2str(W),'_s',num2str(s),'.mat'];
if ~exist(stringname,'file')
    matrix_dFC_HE = [];
    matrix_dFC_PA = [];
    for i = 1 : a4 % HE
        matrix_dFC_HE = [matrix_dFC_HE;matrix(dFC_HE(:,:,:,i))];
        fprintf('=');
    end
    fprintf('\n');
    for i = 1 : b4
        matrix_dFC_PA = [matrix_dFC_PA;matrix(dFC_PA(:,:,:,i))];
        fprintf('=');
    end
    fprintf('\n');
    if retainprocessfiles
        save(stringname,'matrix_dFC_HE','matrix_dFC_PA');
    end
else
    load(stringname);
end

dFCNs = [matrix_dFC_HE;matrix_dFC_PA];

K = 10;
D = zeros(K-1,runs+1);
for i = 1 : runs
    for k = 2 : K
        [~,~,sumd,~] = kmeans(dFCNs,k,'dist','sqeuclidean');
        % data，n×p原始数据向量
        % lable，n×1向量，聚类结果标签
        % c，k×p向量，k个聚类质心的位置
        % sumd，k×1向量，类间所有点与该类质心点距离之和
        % d，n×k向量，每个点与聚类质心的距离
        sse1 = sum(sumd.^2);
        D(k-1,1) = k;
        D(k-1,i+1) = sse1;
        fprintf('.');
    end
    fprintf([num2str(round(i/runs*100)),'%%\n']);
%     fprintf('=');
end
fprintf('\n');
figure;
plot(D(:,1),mean(D(:,2:end),2));hold on;
plot(D(:,1),mean(D(:,2:end),2),'or');
title('不同K值聚类偏差图');
xlabel('分类数(K值)');
ylabel('簇内误差平方和');

end

