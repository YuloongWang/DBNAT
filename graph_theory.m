function [A1,deg1,Eglobal,Elocal1,kden] = graph_theory(corr_state,threshold)

%% 图论
A1 = abs(corr_state) > threshold;

deg1 = degrees_und(A1);% 计算节点的度

Eglobal = efficiency_bin(A1); % 全局效率

Elocal1 = efficiency_bin(A1,1)'; %局部效率

kden = density_und(A1); % 网络密度

% plot(Elocal1);hold on;plot(Elocal1,'or');
end