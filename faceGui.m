global h_axes1;
global h_axes2;
global edit2;
h_f=figure('name','人脸识别系统','position',[600,400,1200,800]);
%clf reset;%clf 清除当前的图像的所有自图像，Reset重新设置图像的目标属性为默认值
set(h_f,'defaultuicontrolfontsize',12);
set(h_f,'defaultuicontrolfontname','宋体');

h_axes1=axes('parent',h_f,'position',[0.2,0.28,0.25,0.56],'Unit','normalized','visible','on');
h_axes2=axes('parent',h_f,'position',[0.55,0.28,0.25,0.56],'Unit','normalized','visible','on');

figcolor=get(h_f,'color');
edit2=uicontrol(h_f,'style','text','position',[150,330,300,40],...
    'backgroundcolor',figcolor);%动态变化提示
button_open=uicontrol(h_f,'style','push','string','选择照片'...
,'position',[250 40 100 50],'callback','GUIopen');
button_recg=uicontrol(h_f,'style','push','string','测试准确率',...
    'position',[100 40 100 50],'callback','face');
button_match=uicontrol(h_f,'style','push','string','图像匹配',...
    'position',[400 40 100 50],'callback','GUIrecg');


clc;
clear;
npersons=40;%选取40个人的脸
global imgrow;
global imgcol;%读取图像的列
global edit2
imgrow=112;
imgcol=92;%读取的图像为112*92

set(edit2,'string','读取训练数据....')%显示在句柄为edit2的文本框里
drawnow  %更新窗口的内容，不然程序结束时才会显示，这样只能看到最后一句
f_matrix=ReadFace(npersons,0);%读取训练数据
nfaces=size(f_matrix,1);%样本人脸的数量

%低维空间的图像是（npersons*5）*k的矩阵，每行代表一个主成分脸，每个脸20维特征

set(edit2,'string','训练数据PCA特征提取...')
drawnow
mA=mean(f_matrix);%求每个属性的均值
k=20;%降维至20维
[pcaface,V]=fastPCA(f_matrix,k,mA);%主成分分析法特征提取
%pcaface是200*20

set(edit2,'string','训练特征数据规范化....')
drawnow %每次设置完之后要更新窗口内容
lowvec=min(pcaface);
upvec=max(pcaface);
scaledface=scaling(pcaface,lowvec,upvec);

set(edit2,'string','SVM样本训练...')
drawnow %每次设置完之后要更新窗口内容
gamma=0.0078;
c=128;
multiSVMstruct=multiSVMtrain(scaledface,npersons,gamma,c);
%save('recognize.mat','multiSVMstruct','npersons','k','mA','V','lowvec','upvec');

set(edit2,'string','读取测试数据...')
drawnow
[testface,realclass]=ReadFace(npersons,1);

set(edit2,'string','测试数据降维...')
drawnow
m=size(testface,1);
for i=1:m
    testface(i,:)=testface(i,:)-mA;
end
pcatestface=testface*V;

set(edit2,'string','测试特征数据规范化...')
scaledtestface=scaling(pcatestface,lowvec,upvec);

set(edit2,'string','样本分类...')
drawnow
class=multiSVM(scaledtestface,multiSVMstruct,npersons);

set(edit2,'string','测试完成！')
accuracy=sum(class==realclass)/length(class);
msgbox(['识别准确率：',num2str(accuracy*100),'%。'])

global h_axes1
[filename,pathname]=uigetfile({'*.pgm';'*.jpg';'*.tif';'*.*'},'请选择一张用于识别的照片');
if filename==0
    msgbox('请选择一张照片文件')
else
    filepath=[pathname,filename];
    axes(h_axes1);
    imshow(imread(filepath));
end

global h_axes1
global h_axes2
global edit2
%load('recognize.mat');
set(edit2,'string','读取测试数据......')
drawnow
disp('读取测试数据...')
disp('.................................................')
img=getimage(h_axes1);%获得之前选中的照片的信息
if isempty(img)
    msgbox('请先选择一张图片！')
end
tic;
testface=img(:)';
set(edit2,'string','测试数据降维......')
drawnow
disp('测试数据特征降维...')
disp('.................................................')
Z=double(testface)-mA;
pcatestface=Z*V;
set(edit2,'string','测试特征数据规范化......')
drawnow
disp('测试特征数据规范化...')
disp('.................................................')
scaledtestface=-1+(pcatestface-lowvec)./(upvec-lowvec)*2;
set(edit2,'string','SVM样本识别......')
drawnow
disp('SVM样本识别...')
disp('.................................................')
voting=zeros(1,npersons);
for i=1:npersons-1
    for j=i+1:npersons
        class=svmclassify(multiSVMstruct{i}{j},scaledtestface);
        voting(i)=voting(i)+(class==1);
        voting(j)=voting(j)+(class==0);
    end
end
[~,class]=max(voting);
set(edit2,'string','识别完成！')
drawnow
axes(h_axes2);
imshow(imread(['C:\Users\Administrator\Desktop\人脸识别\改进\orl_faces\s',num2str(class),'/1.pgm']));
msgbox(['样本识别为第',num2str(class),'个人'])

approx=mA;
toc;
for i=1:k
    approx=approx+pcaface(1,i)*V(:,i)';%pcaface的第一个参数代表你要重建的人脸，这里对第一个人的第一张脸脸进行重建
end
disp('人脸重建')
figure
B=reshape(approx',112,92);
imshow(B,[])













