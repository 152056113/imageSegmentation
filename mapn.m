function [ img ] = mapn( I ,n)
%MAP256 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

I = double(I);
img = (I - min(min(I))) ./ (max(max(I)) - min(min(I))) * n;

end

