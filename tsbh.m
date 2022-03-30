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
%���ñ���
ha=axes('units','normalized','pos',[0 0 1 1]);
uistack(ha,'bottom');    %���ڵײ���buttom
ii=imread('C:\Users\Administrator\Desktop\1.jpg');   %�ڵ�ǰ�ļ����µ�ͼƬ����
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

npersons=40;%ѡȡ40���˵���
global imgrow;
global imgcol;%��ȡͼ�����

imgrow=112;
imgcol=92;%��ȡ��ͼ��Ϊ112*92

set(handles.edit2,'string','��ȡѵ������....')%��ʾ�ھ��Ϊedit2���ı�����
drawnow  %���´��ڵ����ݣ���Ȼ�������ʱ�Ż���ʾ������ֻ�ܿ������һ��
f_matrix=ReadFace(npersons,0);%��ȡѵ������
nfaces=size(f_matrix,1);%��������������

%��ά�ռ��ͼ���ǣ�npersons*5��*k�ľ���ÿ�д���һ�����ɷ�����ÿ����20ά����

set(handles.edit2,'string','ѵ������PCA������ȡ...')
drawnow
mA=mean(f_matrix);%��ÿ�����Եľ�ֵ
k=20;%��ά��20ά
[pcaface,V]=fastPCA(f_matrix,k,mA);%���ɷַ�����������ȡ
%pcaface��200*20

set(handles.edit2,'string','ѵ���������ݹ淶��....')
drawnow %ÿ��������֮��Ҫ���´�������
lowvec=min(pcaface);
upvec=max(pcaface);
scaledface=scaling(pcaface,lowvec,upvec);

set(handles.edit2,'string','SVM����ѵ��...')
drawnow %ÿ��������֮��Ҫ���´�������
gamma=0.0078;
c=128;
multiSVMstruct=multiSVMtrain(scaledface,npersons,gamma,c);
%save('recognize.mat','multiSVMstruct','npersons','k','mA','V','lowvec','upvec');

set(handles.edit2,'string','��ȡ��������...')
drawnow
[testface,realclass]=ReadFace(npersons,1);

set(handles.edit2,'string','�������ݽ�ά...')
drawnow
m=size(testface,1);
for i=1:m
    testface(i,:)=testface(i,:)-mA;
end
pcatestface=testface*V;

set(handles.edit2,'string','�����������ݹ淶��...')
scaledtestface=scaling(pcatestface,lowvec,upvec);

set(handles.edit2,'string','��������...')
drawnow
class=multiSVM(scaledtestface,multiSVMstruct,npersons);

set(handles.edit2,'string','������ɣ�')
accuracy=sum(class==realclass)/length(class);


global h_axes1
[filename,pathname]=uigetfile({'*.pgm';'*.jpg';'*.tif';'*.*'},'��ѡ��һ������ʶ�����Ƭ');
if filename==0
    msgbox('��ѡ��һ����Ƭ�ļ�')
else
    filepath=[pathname,filename];
    axes(handles.axes1);
    imshow(imread(filepath));
end

global h_axes1
global h_axes2
global edit2
%load('recognize.mat');
set(handles.edit2,'string','��ȡ��������......')
drawnow
disp('��ȡ��������...')
disp('.................................................')
img=getimage(handles.axes1);%���֮ǰѡ�е���Ƭ����Ϣ
if isempty(img)
    msgbox('����ѡ��һ��ͼƬ��')
end
testface=img(:)';
set(handles.edit2,'string','�������ݽ�ά......')
drawnow
disp('��������������ά...')
disp('.................................................')
Z=double(testface)-mA;
pcatestface=Z*V;
set(handles.edit2,'string','�����������ݹ淶��......')
drawnow
disp('�����������ݹ淶��...')
disp('.................................................')
scaledtestface=-1+(pcatestface-lowvec)./(upvec-lowvec)*2;
set(handles.edit2,'string','SVM����ʶ��......')
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
set(handles.edit2,'string','ʶ����ɣ�')
drawnow
axes(handles.axes2);
% imshow(D_rgb);
imshow(imread(['C:\Users\Administrator\Desktop\����ʶ��\�Ľ�\orl_faces\s',num2str(class),'/1.pgm']));

% msgbox(['����ʶ��Ϊ��',num2str(class),'����'])
msgbox(['ʶ��׼ȷ�ʣ�',num2str(accuracy*100),'%��'])

approx=mA;
for i=1:k
    approx=approx+pcaface(1,i)*V(:,i)';%pcaface�ĵ�һ������������Ҫ�ؽ�������������Ե�һ���˵ĵ�һ�����������ؽ�
end
disp('�����ؽ�')

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
