function [pcaA,V]=fastPCA(A,k,mA)
%����PCA�����ɷַ���
%���룺
%    A-��������ÿ����һ������������������ά��
%    k-����kά
%     MA �����ֵ
%���:
%   pcaA-����kά��������������ɵľ��󣬼����ɷ�
%   V-���ɷַ���
m=size(A,1);%�����ж��ٸ�����
 Z=(A-repmat(mA,m,1));%remat���ƺ�ƽ�̾���,ԭ�������ֵ�������
T=Z*Z';%��Э�������,�����z'*z������ά��Ϊimgrow*imgcol>>npersons*5����(x-u)(x-u)'��Э�������TΪ200*200
[~,~,rate]=pcacov(T);
contr=cumsum(rate);
for k=1:length(contr)
    if contr(k)>95;
        break;
    end
end
[V,D]=eigs(T,k);%����T�����k������ֵ������������VΪ����������DΪ����ֵ��VΪ200*20
V=Z'*V;%Э����������������(V��imgrow*imgcol*k)
for i=1:k  %����������λ�� ����������`�������ĵ�λ����
    l=norm(V(:,i));%�������Ķ�����
    V(:,i)=V(:,i)/l;
end
V=V;
pcaA=Z*V;  %���Ա任������kά �������������ı�ʾ(pcaA��npersons*5*k)
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