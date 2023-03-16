function [matrix] = reconstruction(vector)
%     vector = [1:1:6670];
    matrix = zeros(116);
    num = 1;
    for i = 115 : -1 : 1
        row = 116 - i;
        e = vector(num:end);
        matrix(row,row+1:end) = e(1,1:i);
        matrix(row+1:end,row) = e(1,1:i)';
        num = num + i;
    end
%     for max_i = 1 : 116
%         for max_j = max_i + 1 : 116
%             matrix(max_j,max_i,i) = matrix(max_i,max_j,i);
%         end
%     end
end