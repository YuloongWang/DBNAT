function [matrix] = matrix(ResultCorr)
% 将相关系数连接为矩阵
% 输入为116*116*n
% 输出为n*6670

% tic
% fprintf('连接为矩阵\n');
[m,n,z] = size(ResultCorr);
for u = 1 : z
    output = [];
    for i = 1 : m
        for j = 1 : n
            if i < j
                corr_one = ResultCorr(:,:,u);
                output = [output,corr_one(i,j)];
            end
        end
    end
    matrix(u,:) = output;
end
% toc;

end

