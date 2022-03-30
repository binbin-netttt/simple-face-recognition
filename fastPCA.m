function [pcaA,V]=fastPCA(A,k,mA)
%快速PCA，主成分分析
%输入：
%    A-样本矩阵，每行是一个样本，列是样本的维数
%    k-降至k维
%     MA 矩阵均值
%输出:
%   pcaA-降的k维样本特征向量组成的矩阵，即主成分
%   V-主成分分量
m=size(A,1);%计算有多少个样本
 Z=(A-repmat(mA,m,1));%remat复制和平铺矩阵,原矩阵与均值矩阵相减
T=Z*Z';%求协方差矩阵,如果是z'*z则计算的维数为imgrow*imgcol>>npersons*5，∑(x-u)(x-u)'求协方差矩阵，T为200*200
[~,~,rate]=pcacov(T);
contr=cumsum(rate);
for k=1:length(contr)
    if contr(k)>95;
        break;
    end
end
[V,D]=eigs(T,k);%计算T的最大k个特征值和特征向量，V为特征向量，D为特征值，V为200*20
V=Z'*V;%协方差矩阵的特征向量(V是imgrow*imgcol*k)
for i=1:k  %特征向量单位化 该向量除以`该向量的单位长度
    l=norm(V(:,i));%求向量的二范数
    V(:,i)=V(:,i)/l;
end
V=V;
pcaA=Z*V;  %线性变换，降至k维 特征脸对人脸的表示(pcaA是npersons*5*k)
end
%{
SampleMatrix=A;
KDim=k;
height=112;
width=92;
[r c]=size(SampleMatrix);
temp1=cell(1,r);
L=zeros(800,56*46);
temp_he=zeros(4,56*46);
for i=1:r
    temp1{i}=reshape(SampleMatrix(i,:),height,width);
    temp2=mat2cell(temp1{i},[56 56],[46 46]);
    for j=1:4
        temp2{j}=reshape(temp2{j},1,56*46);
    end
    temp_he=[temp2{1};temp2{2};temp2{3};temp2{4}];
    L(i*4-3:i*4,:)=temp_he;
end
[pp qq]=size(L(1,:));
temp=zeros(pp,qq);
for i=800
    temp=temp+L(i,:);
end
meanVec=temp./800;
Z=(L-repmat(meanVec,800,1));
Z=reshape(Z,r,c);
%L=reshape(L,r,c);
covMatT=Z*Z';
[FastCOEFF D]=eigs(covMatT,KDim);
FastCOEFF=Z'*FastCOEFF;
for i=1:KDim
    FastCOEFF(:,i)=FastCOEFF(:,i)./sqrt(D(i,i));
end
for i=1:KDim
    FastCOEFF(:,i)=FastCOEFF(:,i)/norm(FastCOEFF(:,i));
end
FastCOEFF=FastCOEFF*3.33;
FastSCORE_temp=Z*FastCOEFF;
for i=1:50
    FastSCORE2=[FastSCORE_temp(i*4-3,:) FastSCORE_temp(i*4-2,:) FastSCORE_temp(i*4-1,:) FastSCORE_temp(i*4,:)];
    FastSCORE(i,:)=reshape(FastSCORE2,1,KDim*4);
end
V=FastSCORE;
pcaA=FastCOEFF;
V=reshape(V,200,20);
end
%}