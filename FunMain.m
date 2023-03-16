function [] = FunMain(ROISignals_HE,ROISignals_PA,gparameter,dFCmethod,retainprocessfiles,plot_matrix,save_matrix)
% dFCmethod: sliding window
%            tapered sliding window
%            temporal derivatives
%            correlation's correlation
%% 
W = gparameter(1);
s = gparameter(2);
K = gparameter(3);
p = gparameter(4);
sigma = gparameter(5);
%% dFC
fprintf('dFC计算\n');
for i = 1 : length(ROISignals_HE(1,1,:))
    dFC_HE(:,:,:,i) = corr_dFC(ROISignals_HE(:,:,i),ones(1,W),s,dFCmethod); % 116 116 97 33
end
for i = 1 : length(ROISignals_PA(1,1,:))
    dFC_PA(:,:,:,i) = corr_dFC(ROISignals_PA(:,:,i),ones(1,W),s,dFCmethod);
end
[a1,~,a3,a4] = size(dFC_HE);
[b1,~,b3,b4] = size(dFC_PA);
%% 拼接
fprintf('拼接\n');
dFC_HE_permute = permute(dFC_HE,[1,3,2,4]);
dFC_PA_permute = permute(dFC_PA,[1,3,2,4]);
dFC_HE_Splicing = [];dFC_PA_Splicing = [];
for i = 1 : length(ROISignals_HE(1,1,:))
    dFC_HE_Splicing = [dFC_HE_Splicing,dFC_HE_permute(:,:,:,i)];
end
for i = 1 : length(ROISignals_PA(1,1,:))
    dFC_PA_Splicing = [dFC_PA_Splicing,dFC_PA_permute(:,:,:,i)];
end
dFC_HE_Splicing = permute(dFC_HE_Splicing,[1,3,2]);
dFC_PA_Splicing = permute(dFC_PA_Splicing,[1,3,2]);
%% 组合
fprintf('组合\n');
if ~exist(['matrix_dFC_',strrep(dFCmethod,' ',''),'_W',num2str(W),'_s',num2str(s),'.mat'],'file')
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
        eval(['save matrix_dFC_',strrep(dFCmethod,' ',''),'_W',num2str(W),'_s',num2str(s),' matrix_dFC_HE matrix_dFC_PA']);
    end
else
    eval(['load matrix_dFC_',strrep(dFCmethod,' ',''),'_W',num2str(W),'_s',num2str(s)]);
end

dFCNs = [matrix_dFC_HE;matrix_dFC_PA];
%% kmeans
fprintf('kmeans聚类\n');
% K = 4;
label_HE = zeros(a3*a4,1);label_PA = zeros(b3*b4,1);
tabu_HE = tabulate(label_HE(:));tabu_PA = tabulate(label_HE(:));
while(length(tabu_HE(:,3))==1 || sum(tabu_HE(:,3)<7) || sum(tabu_PA(:,3)<7))
    [label,~,~,~] = kmeans(dFCNs,K,'dist','cityblock');
    [m,~] = size(matrix_dFC_HE);
    [n,~] = size(matrix_dFC_PA);
    label_HE = label(1:m);
    label_PA = label(m+1:end);
    tabu_HE = tabulate(label_HE(:));
    tabu_PA = tabulate(label_PA(:));
end
if plot_matrix{1}
    figure;
    subplot(121);plot(label_HE);axis([-inf,inf,-1,6]);title('HE窗口状态分布');
    subplot(122);plot(label_PA);axis([-inf,inf,-1,6]);title('PA窗口状态分布');
end
%% state reconstruction
for i = 1 : K
    img_HE_state_mean(i,:) = mean(matrix_dFC_HE(label_HE == i,:));
    img_PA_state_mean(i,:) = mean(matrix_dFC_PA(label_PA == i,:));
    img_HE_state_recon_i(:,:,i) = reconstruction(img_HE_state_mean(i,:));
    img_PA_state_recon_i(:,:,i) = reconstruction(img_PA_state_mean(i,:));
end
if plot_matrix{2}
    fprintf('重建矩阵\n');
    figure;
    for i = 1 : K
        subplot(2,K,i);imagesc(img_HE_state_recon_i(:,:,i),[-1 1]);
        colormap('jet');axis square;title(['HE state '+string(i)]);
        subplot(2,K,i+K);imagesc(img_PA_state_recon_i(:,:,i),[-1 1]);
        colormap('jet');axis square;title(['PA state '+string(i)]);
    end
end
%% kmeans参数计算
fprintf('kmeans参数计算\n');
state_HE = [];z_HE = [];MDT_HE = [];a = 0;subject_HE = zeros(a4,K);
for i = 1 : a3 : m
    a = a + 1;
    [state_HE(a,:),z_HE(a,:),MDT_HE(a,:)] = kmeans_parameter(label_HE(i:i+a3-1),K);
    tabu = tabulate(label_HE(i:i+a3-1));
    subject_HE(a,tabu(:,2)>0) = 1;
end
state_PA = [];z_PA = [];MDT_PA = [];b = 0;subject_PA = zeros(b4,K);
for i = 1 : a3 : n
    b = b + 1;
    [state_PA(b,:),z_PA(b,:),MDT_PA(b,:)] = kmeans_parameter(label_PA(i:i+a3-1),K);
    tabu = tabulate(label_PA(i:i+a3-1));
    subject_PA(b,tabu(:,2)>0) = 1;
end
%% kmeans画图
if plot_matrix{3}
    bar_data = [sum(subject_HE);sum(subject_PA)];
    figure;bar(bar_data');title('受试者在每个状态的数量分布');
end
if plot_matrix{4}
    figure;
    subplot(121);plot(mean(state_HE));hold on;plot(mean(state_HE),'ob');
    plot(mean(state_PA));plot(mean(state_PA),'or');title('四个状态的时间分数');
    subplot(122);plot(nanmean(MDT_HE));hold on;plot(nanmean(MDT_HE),'ob');
    plot(nanmean(MDT_PA));plot(nanmean(MDT_PA),'or');title('四个状态的平均驻留时间');
end
if plot_matrix{5}
    figure;
    bar([1:2],[mean(z_HE),mean(z_PA)]);hold on;
    er = errorbar([1:2],[mean(z_HE),mean(z_PA)],[std(z_HE),std(z_PA)],[std(z_HE),std(z_PA)]);
    er.Color = [0 0 0];     % 设置误差条颜色：黑色
    er.LineStyle = 'none';  % 设置线形
    er.CapSize = 20;        % 设置误差线宽
    title('平均转换次数');
end
%% dFC t检验
% for k = 1 : K
%     [~,p_subject] = ttest2(matrix_HE_subject_state(:,:,k),matrix_PA_subject_state(:,:,k),p,'both');
%     sum(sum(p_subject<0.001))
% end
%% kmeans参数t检验
if save_matrix{1}
    fprintf('kmeans参数t检验\n');
    output_kmeans=fopen('output_kmeans.txt','wt');
    fprintf(output_kmeans,'聚类数为：%d\n',K);
    fprintf(output_kmeans,'=====================================================\n');
    [~,p_z,~,stats_z] = ttest2(z_PA,z_HE,p,'both');
    fprintf(output_kmeans,'HE和PA的转换次数t检验的p值为：%f，t值为：%f\n',p_z,stats_z.tstat);
    fprintf(output_kmeans,'=====================================================\n');
    for i = 1 : K
        [~,p_state,~,stats_state] = ttest2(state_PA(:,i),state_HE(:,i),p,'both');
        fprintf(output_kmeans,'HE和PA的状态%d的时间分数t检验的p值为：%f，t值为：%f\n',i,p_state,stats_state.tstat);
        [~,p_MDT,~,stats_MDT] = ttest2(MDT_PA(:,i),MDT_HE(:,i),p,'both');
        fprintf(output_kmeans,'HE和PA的状态%d的平均驻留时间t检验的p值为：%f，t值为：%f\n',i,p_MDT,stats_MDT.tstat);
        fprintf(output_kmeans,'=====================================================\n');
    end
    fclose(output_kmeans);
end
%% 图论参数计算
fprintf('图论参数计算\n');
g_deg1_HE_mean = zeros(a4,a1,K);g_Eglobal_HE_mean = zeros(a4,K);
g_Elocal1_HE_mean = zeros(a4,a1,K);g_kden_HE_mean = zeros(a4,K);
g_deg1_PA_mean = zeros(b4,b1);g_Eglobal_PA_mean = zeros(b4,1);
g_Elocal1_PA_mean = zeros(b4,b1);g_kden_PA_mean = zeros(b4,1);
for k = 1 : K
    a = 0;
    for i = 1 : a3 : m
        a = a + 1;
        subject_HE_graph = dFC_HE_Splicing(:,:,label_HE(i:i+a3-1)==k);
        g_deg1_HE = [];g_Eglobal_HE = [];g_Elocal1_HE = [];g_kden_HE = [];
        for j = 1 : length(subject_HE_graph(1,1,:))
            %   1*116(度)      1(全局效率)      1*116(局部效率)    1(网络密度)
            [~,g_deg1_HE(j,:),g_Eglobal_HE(j),g_Elocal1_HE(j,:),g_kden_HE(j)] = ...
            graph_theory(subject_HE_graph(:,:,j),sigma);
        end
        g_deg1_HE_mean(a,:,k) = nanmean(g_deg1_HE); % 33*116
        g_Eglobal_HE_mean(a,k) = nanmean(g_Eglobal_HE); % 33*1
        g_Elocal1_HE_mean(a,:,k) = nanmean(g_Elocal1_HE); % 33*116
        g_kden_HE_mean(a,k) = nanmean(g_kden_HE); % 33*1
    end
    b = 0;
    for i = 1 : b3 : n
        b = b + 1;
        subject_PA_graph = dFC_PA_Splicing(:,:,label_PA(i:i+b3-1)==k);
        g_deg1_PA = [];g_Eglobal_PA = [];g_Elocal1_PA = [];g_kden_PA = [];
        for j = 1 : length(subject_PA_graph(1,1,:))
            %   1*116(度)      1(全局效率)      1*116(局部效率)    1(网络密度)
            [~,g_deg1_PA(j,:),g_Eglobal_PA(j),g_Elocal1_PA(j,:),g_kden_PA(j)] = ...
            graph_theory(subject_PA_graph(:,:,j),sigma);
        end
        g_deg1_PA_mean(b,:,k) = nanmean(g_deg1_PA);
        g_Eglobal_PA_mean(b,k) = nanmean(g_Eglobal_PA);
        g_Elocal1_PA_mean(b,:,k) = nanmean(g_Elocal1_PA);
        g_kden_PA_mean(b,k) = nanmean(g_kden_PA);
    end
    
    [~,p_deg1(k,:),~,stats_deg1] = ttest2(g_deg1_PA_mean(:,:,k),g_deg1_HE_mean(:,:,k),p,'both');
    p_deg1_FDR(k,:) = mafdr(p_deg1(k,:),'BHFDR',true);
    [~,p_Eglobal(1,k),~,stats_Eglobal] = ttest2(g_Eglobal_PA_mean(:,k),g_Eglobal_HE_mean(:,k),p,'both');
    tstat_Eglobal(1,k) = stats_Eglobal.tstat;
    g_Elocal1_HE_mean2(:,k) = nanmean(g_Elocal1_HE_mean(:,:,k)')';
    g_Elocal1_PA_mean2(:,k) = nanmean(g_Elocal1_PA_mean(:,:,k)')';
    [~,p_Elocal1(1,k),~,stats_Elocal1] = ttest2(g_Elocal1_PA_mean2(:,k),g_Elocal1_HE_mean2(:,k),p,'both');
    tstat_Elocal1(1,k) = stats_Elocal1.tstat;
    [~,p_kden(1,k),~,stats_kden] = ttest2(g_kden_PA_mean(:,k),g_kden_HE_mean(:,k),p,'both');
    tstat_kden(1,k) = stats_kden.tstat;
end
if save_matrix{2}
    output_graph=fopen('output_graph.txt','wt');
    fprintf(output_graph,'聚类数为：%d\n',K);
    for k = 1 : K
        fprintf(output_graph,'========================状态%d========================\n',k);
        fprintf(output_graph,'HE和PA的全局效率t检验的p值为：%f，t值为：%f\n',p_Eglobal(1,k),tstat_Eglobal(1,k));
        fprintf(output_graph,'HE和PA的局部效率t检验的p值为：%f，t值为：%f\n',p_Elocal1(1,k),tstat_Elocal1(1,k));
        fprintf(output_graph,'HE和PA的网络密度t检验的p值为：%f，t值为：%f\n',p_kden(1,k),tstat_kden(1,k));
    end
    fclose(output_graph);
end
%% 图论画图
if plot_matrix{6}
    fprintf('图论画图\n');
    box_data_Eglobal = [];box_label_Eglobal = [];
    box_data_Elocal = [];box_label_Elocal = [];
    box_data_kden = [];box_label_kden = [];
    for k = 1 : K
        box_data_Eglobal = [box_data_Eglobal;g_Eglobal_HE_mean(:,k);g_Eglobal_PA_mean(:,k)];
        box_label_Eglobal_1 = repmat({['state '+string(k)+' HE']},a4,1);
        box_label_Eglobal_2 = repmat({['state '+string(k)+' PA']},b4,1);
        box_label_Eglobal = [box_label_Eglobal;box_label_Eglobal_1;box_label_Eglobal_2];

        box_data_Elocal = [box_data_Elocal;g_Elocal1_HE_mean2(:,k);g_Elocal1_PA_mean2(:,k)];
        box_label_Elocal_1 = repmat({['state '+string(k)+' HE']},a4,1);
        box_label_Elocal_2 = repmat({['state '+string(k)+' PA']},b4,1);
        box_label_Elocal = [box_label_Elocal;box_label_Elocal_1;box_label_Elocal_2];

        box_data_kden = [box_data_kden;g_kden_HE_mean(:,k);g_kden_PA_mean(:,k)];
        box_label_kden_1 = repmat({['state '+string(k)+' HE']},a4,1);
        box_label_kden_2 = repmat({['state '+string(k)+' PA']},b4,1);
        box_label_kden = [box_label_kden;box_label_kden_1;box_label_kden_2];
    end
    figure;
    subplot(1,3,1);boxplot(box_data_Eglobal,box_label_Eglobal);title('全局效率');
    subplot(1,3,2);boxplot(box_data_Elocal,box_label_Elocal);title('局部效率');
    subplot(1,3,3);boxplot(box_data_kden,box_label_kden);title('网络密度');
end
%% circularGraph环形图
if plot_matrix{7}
    try
        fprintf('circularGraph\n');
        load AAL
        figure;
        for k = 1 : K
            img_state(:,:,k) = (img_HE_state_recon_i(:,:,k) + img_PA_state_recon_i(:,:,k)) ./ 2;
            Edge_AAL = abs(double(img_state(:,:,k)>sigma));
            [r,c]= find(Edge_AAL>0);
            label = [r;c];% 组合
            label = unique(label);% 去重
            x = Edge_AAL(label,label);
            myLabel = cell(length(x),1);
            for i = 1 : length(x)
              myLabel{i} = cellstr(AAL(label(i),7));
            end
            subplot(1,K,k);
            myColorMap = lines(length(x));
            circularGraph(x,'Colormap',myColorMap,'Label',myLabel);
        end
    catch
        warning('circularGraph usage error');
    end
end
%% BrainNet画图 节点的度
if save_matrix{3}
    fprintf('生成BrainNet画图文件(节点的度)\n');
    load AAL116_Node
    p_deg1_FDR_abs = abs(p_deg1_FDR) < p;
    for k = 1 : K
        Node_state = AAL116_Node(p_deg1_FDR_abs(k,:)',:);
        dlmwrite(['BrainNet_state_'+string(k)+'.node'],char(Node_state),'delimiter', '','newline','pc');
    end
end
%% DynamicBC画图 四个状态
if save_matrix{4}
    fprintf('生成DynamicBC画图文件\n');
    load AAL
    for k = 1 : K
        img_state(:,:,k) = (img_HE_state_recon_i(:,:,k) + img_PA_state_recon_i(:,:,k)) ./ 2;
        dlmwrite(['DBC_state_'+string(k)+'.txt'],double(img_state(:,:,k)>sigma),'delimiter','	'); % InputMatrix
    end
    dlmwrite('module.txt',double(AAL(:,6)),'delimiter','	'); % InputModule
    dlmwrite('Node.txt',double(AAL(:,1)),'delimiter','	');     % select node property (num of property选择1)
end
end