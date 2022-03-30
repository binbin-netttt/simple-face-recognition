function varargout = tsbh(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tsbh_OpeningFcn, ...
                   'gui_OutputFcn',  @tsbh_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end




function tsbh_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
%设置背景
ha=axes('units','normalized','pos',[0 0 1 1]);
uistack(ha,'bottom');    %置于底部用buttom
ii=imread('C:\Users\Administrator\Desktop\1.jpg');   %在当前文件夹下的图片名称
image(ii);
colormap gray
set(ha,'handlevisibility','off','visible','off');
guidata(hObject, handles);

handles.picture=ii;
guidata(hObject, handles);





function varargout = tsbh_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)
global h_axes1;
global h_axes2;
global edit2;

npersons=40;%选取40个人的脸
global imgrow;
global imgcol;%读取图像的列

imgrow=112;
imgcol=92;%读取的图像为112*92

set(handles.edit2,'string','读取训练数据....')%显示在句柄为edit2的文本框里
drawnow  %更新窗口的内容，不然程序结束时才会显示，这样只能看到最后一句
f_matrix=ReadFace(npersons,0);%读取训练数据
nfaces=size(f_matrix,1);%样本人脸的数量

%低维空间的图像是（npersons*5）*k的矩阵，每行代表一个主成分脸，每个脸20维特征

set(handles.edit2,'string','训练数据PCA特征提取...')
drawnow
mA=mean(f_matrix);%求每个属性的均值
k=20;%降维至20维
[pcaface,V]=fastPCA(f_matrix,k,mA);%主成分分析法特征提取
%pcaface是200*20

set(handles.edit2,'string','训练特征数据规范化....')
drawnow %每次设置完之后要更新窗口内容
lowvec=min(pcaface);
upvec=max(pcaface);
scaledface=scaling(pcaface,lowvec,upvec);

set(handles.edit2,'string','SVM样本训练...')
drawnow %每次设置完之后要更新窗口内容
gamma=0.0078;
c=128;
multiSVMstruct=multiSVMtrain(scaledface,npersons,gamma,c);
%save('recognize.mat','multiSVMstruct','npersons','k','mA','V','lowvec','upvec');

set(handles.edit2,'string','读取测试数据...')
drawnow
[testface,realclass]=ReadFace(npersons,1);

set(handles.edit2,'string','测试数据降维...')
drawnow
m=size(testface,1);
for i=1:m
    testface(i,:)=testface(i,:)-mA;
end
pcatestface=testface*V;

set(handles.edit2,'string','测试特征数据规范化...')
scaledtestface=scaling(pcatestface,lowvec,upvec);

set(handles.edit2,'string','样本分类...')
drawnow
class=multiSVM(scaledtestface,multiSVMstruct,npersons);

set(handles.edit2,'string','测试完成！')
accuracy=sum(class==realclass)/length(class);


global h_axes1
[filename,pathname]=uigetfile({'*.pgm';'*.jpg';'*.tif';'*.*'},'请选择一张用于识别的照片');
if filename==0
    msgbox('请选择一张照片文件')
else
    filepath=[pathname,filename];
    axes(handles.axes1);
    imshow(imread(filepath));
end

global h_axes1
global h_axes2
global edit2
%load('recognize.mat');
set(handles.edit2,'string','读取测试数据......')
drawnow
disp('读取测试数据...')
disp('.................................................')
img=getimage(handles.axes1);%获得之前选中的照片的信息
if isempty(img)
    msgbox('请先选择一张图片！')
end
testface=img(:)';
set(handles.edit2,'string','测试数据降维......')
drawnow
disp('测试数据特征降维...')
disp('.................................................')
Z=double(testface)-mA;
pcatestface=Z*V;
set(handles.edit2,'string','测试特征数据规范化......')
drawnow
disp('测试特征数据规范化...')
disp('.................................................')
scaledtestface=-1+(pcatestface-lowvec)./(upvec-lowvec)*2;
set(handles.edit2,'string','SVM样本识别......')
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
set(handles.edit2,'string','识别完成！')
drawnow
axes(handles.axes2);
% imshow(D_rgb);
imshow(imread(['C:\Users\Administrator\Desktop\人脸识别\改进\orl_faces\s',num2str(class),'/1.pgm']));

% msgbox(['样本识别为第',num2str(class),'个人'])
msgbox(['识别准确率：',num2str(accuracy*100),'%。'])

approx=mA;
for i=1:k
    approx=approx+pcaface(1,i)*V(:,i)';%pcaface的第一个参数代表你要重建的人脸，这里对第一个人的第一张脸脸进行重建
end
disp('人脸重建')

B=reshape(approx',112,92);
axes(handles.axes3);
imshow(B,[])




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
close;



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
