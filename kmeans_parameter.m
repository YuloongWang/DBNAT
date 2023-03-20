function [state_HE,z_HE,MDT_HE] = kmeans_parameter(label_HE,K)
[m,~] = size(label_HE);
% 时间分数
for i = 1 : K
    state_HE(i) = sum(label_HE==i) / m;
end
% 转换次数
z_HE = 0;z_PA = 0;
st_HE = zeros(1,K);
st_HE_1 = label_HE(1);
eval(['st_HE('+string(st_HE_1)+') = st_HE('+string(st_HE_1)+') + 1;']);
for i = 1 : m - 1
    if label_HE(i) ~= label_HE(i+1)
        z_HE = z_HE + 1;
        
        for j = 1 : K
            if label_HE(i+1) == j
                st_HE(j) = st_HE(j) + 1;
            end
        end
        
    end
end
% 平均驻留时间
for i = 1 : K
    MDT_HE = state_HE./st_HE;
end

end

