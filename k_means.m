function [C, u] = k_means(D,k,T,expo)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

[m,n] = size(D);
%�����ʼ����������
u = zeros(k,n);
index = randperm(m);
u = u + D(index(1:k),:);

while(T)
    C = cell(1,k);
    d = zeros(1,k);
    for i = 1 : m
        for j = 1 : k
            d(j) = sqrt(sum((D(i,:) - u(j,:)).^2));
        end
        [~,iid] = min(d);
        C{iid} = [C{iid};i];
    end
    flag = 1;
    for i = 1 : k
        ut = mean(D(C{i},:));
        if abs(ut - u(i)) > expo
            flag = 0;
            u(i,:) = ut;
        end
    end
    if(flag==1)
        break;
    end
    T = T - 1;
end

end

