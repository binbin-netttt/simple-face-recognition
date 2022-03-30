global h_axes1;
global h_axes2;
global edit2;
h_f=figure('name','����ʶ��ϵͳ','position',[600,400,1200,800]);
%clf reset;%clf �����ǰ��ͼ���������ͼ��Reset��������ͼ���Ŀ������ΪĬ��ֵ
set(h_f,'defaultuicontrolfontsize',12);
set(h_f,'defaultuicontrolfontname','����');

h_axes1=axes('parent',h_f,'position',[0.2,0.28,0.25,0.56],'Unit','normalized','visible','on');
h_axes2=axes('parent',h_f,'position',[0.55,0.28,0.25,0.56],'Unit','normalized','visible','on');

figcolor=get(h_f,'color');
edit2=uicontrol(h_f,'style','text','position',[150,330,300,40],...
    'backgroundcolor',figcolor);%��̬�仯��ʾ
button_open=uicontrol(h_f,'style','push','string','ѡ����Ƭ'...
,'position',[250 40 100 50],'callback','GUIopen');
button_recg=uicontrol(h_f,'style','push','string','����׼ȷ��',...
    'position',[100 40 100 50],'callback','face');
button_match=uicontrol(h_f,'style','push','string','ͼ��ƥ��',...
    'position',[400 40 100 50],'callback','GUIrecg');


clc;
clear;
npersons=40;%ѡȡ40���˵���
global imgrow;
global imgcol;%��ȡͼ�����
global edit2
imgrow=112;
imgcol=92;%��ȡ��ͼ��Ϊ112*92

set(edit2,'string','��ȡѵ������....')%��ʾ�ھ��Ϊedit2���ı�����
drawnow  %���´��ڵ����ݣ���Ȼ�������ʱ�Ż���ʾ������ֻ�ܿ������һ��
f_matrix=ReadFace(npersons,0);%��ȡѵ������
nfaces=size(f_matrix,1);%��������������

%��ά�ռ��ͼ���ǣ�npersons*5��*k�ľ���ÿ�д���һ�����ɷ�����ÿ����20ά����

set(edit2,'string','ѵ������PCA������ȡ...')
drawnow
mA=mean(f_matrix);%��ÿ�����Եľ�ֵ
k=20;%��ά��20ά
[pcaface,V]=fastPCA(f_matrix,k,mA);%���ɷַ�����������ȡ
%pcaface��200*20

set(edit2,'string','ѵ���������ݹ淶��....')
drawnow %ÿ��������֮��Ҫ���´�������
lowvec=min(pcaface);
upvec=max(pcaface);
scaledface=scaling(pcaface,lowvec,upvec);

set(edit2,'string','SVM����ѵ��...')
drawnow %ÿ��������֮��Ҫ���´�������
gamma=0.0078;
c=128;
multiSVMstruct=multiSVMtrain(scaledface,npersons,gamma,c);
%save('recognize.mat','multiSVMstruct','npersons','k','mA','V','lowvec','upvec');

set(edit2,'string','��ȡ��������...')
drawnow
[testface,realclass]=ReadFace(npersons,1);

set(edit2,'string','�������ݽ�ά...')
drawnow
m=size(testface,1);
for i=1:m
    testface(i,:)=testface(i,:)-mA;
end
pcatestface=testface*V;

set(edit2,'string','�����������ݹ淶��...')
scaledtestface=scaling(pcatestface,lowvec,upvec);

set(edit2,'string','��������...')
drawnow
class=multiSVM(scaledtestface,multiSVMstruct,npersons);

set(edit2,'string','������ɣ�')
accuracy=sum(class==realclass)/length(class);
msgbox(['ʶ��׼ȷ�ʣ�',num2str(accuracy*100),'%��'])

global h_axes1
[filename,pathname]=uigetfile({'*.pgm';'*.jpg';'*.tif';'*.*'},'��ѡ��һ������ʶ�����Ƭ');
if filename==0
    msgbox('��ѡ��һ����Ƭ�ļ�')
else
    filepath=[pathname,filename];
    axes(h_axes1);
    imshow(imread(filepath));
end

global h_axes1
global h_axes2
global edit2
%load('recognize.mat');
set(edit2,'string','��ȡ��������......')
drawnow
disp('��ȡ��������...')
disp('.................................................')
img=getimage(h_axes1);%���֮ǰѡ�е���Ƭ����Ϣ
if isempty(img)
    msgbox('����ѡ��һ��ͼƬ��')
end
tic;
testface=img(:)';
set(edit2,'string','�������ݽ�ά......')
drawnow
disp('��������������ά...')
disp('.................................................')
Z=double(testface)-mA;
pcatestface=Z*V;
set(edit2,'string','�����������ݹ淶��......')
drawnow
disp('�����������ݹ淶��...')
disp('.................................................')
scaledtestface=-1+(pcatestface-lowvec)./(upvec-lowvec)*2;
set(edit2,'string','SVM����ʶ��......')
drawnow
disp('SVM����ʶ��...')
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
set(edit2,'string','ʶ����ɣ�')
drawnow
axes(h_axes2);
imshow(imread(['C:\Users\Administrator\Desktop\����ʶ��\�Ľ�\orl_faces\s',num2str(class),'/1.pgm']));
msgbox(['����ʶ��Ϊ��',num2str(class),'����'])

approx=mA;
toc;
for i=1:k
    approx=approx+pcaface(1,i)*V(:,i)';%pcaface�ĵ�һ������������Ҫ�ؽ�������������Ե�һ���˵ĵ�һ�����������ؽ�
end
disp('�����ؽ�')
figure
B=reshape(approx',112,92);
imshow(B,[])













