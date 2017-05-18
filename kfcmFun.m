function [center, U, obj_fcn] = kfcmFun(data, cluster_n,maxit, kernel_b,expo)
data_n = size(data, 1); % ���data�ĵ�һά(rows)��,����������
obj_fcn = zeros(100, 1);	% ��ʼ���������obj_fcn
U = initkfcm(cluster_n, data_n);	% ��ʼ��ģ���������,ʹU�����������Ϊ1
index = randperm(data_n);   % �����������������
center_old = data(index(1:cluster_n),:);  % ѡȡ������е�������ǰcluster_n��
for i = 1:maxit
	[U, center, obj_fcn(i)] = stepkfcm(data,U,center_old, expo, kernel_b);
    fprintf('Iteration count = %d, obj. fcn = %f\n', i, obj_fcn(i));
    center_old = center;    % ���µľ������Ĵ����ϵľ�������
	% ��ֹ�����б�
	if i > 1
		if abs(obj_fcn(i) - obj_fcn(i-1)) < 1e-5
            break; 
        end
	end
end
iter_n = i;	
obj_fcn(iter_n+1:100) = [];

function U = initkfcm(cluster_n, data_n)
% ��ʼ��fcm�������Ⱥ�������
U = rand(cluster_n, data_n);
col_sum = sum(U);
U = U./col_sum(ones(cluster_n, 1), :);

function [U_new,center_new,obj_fcn] = stepkfcm(data,U,center,expo,kernel_b)
% ģ��C��ֵ����ʱ������һ��
feature_n = size(data,2);  % ����ά��
cluster_n = size(center,1); % �������
mf = U.^expo;      
% �����µľ�������;
KernelMat = gaussKernel(center,data,kernel_b); % �����˹�˾���
num = mf.*KernelMat * data;   
den = sum(mf.*KernelMat,2);  
center_new = num./(den*ones(1,feature_n));

% �����µ������Ⱦ���
kdist = distkfcm(center_new, data, kernel_b);    % ����������
obj_fcn = sum(sum((kdist.^2).*mf));  % ����Ŀ�꺯��ֵ
tmp = kdist.^(-1/(expo-1));     
U_new = tmp./(ones(cluster_n, 1)*sum(tmp)); 

function out = distkfcm(center, data, kernel_b)
% �������������������ĵľ���
cluster_n = size(center, 1);
data_n = size(data, 1);
out = zeros(cluster_n, data_n);
for i = 1:cluster_n % ��ÿ���������� 
    vi = center(i,:);
    out(i,:) = 2-2*gaussKernel(vi,data,kernel_b);
end

function out = gaussKernel(center,data,kernel_b)
% ��˹�˺�������
dist = zeros(size(center, 1), size(data, 1));
for k = 1:size(center, 1)
    dist(k, :) = sqrt(sum(((data-ones(size(data,1),1)*center(k,:)).^2)',1));
end
out = exp(-dist.^2/kernel_b^2);




