function varargout = gui38(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui38_OpeningFcn, ...
                   'gui_OutputFcn',  @gui38_OutputFcn, ...
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

function gui38_OpeningFcn(hObject, eventdata, handles, varargin)



handles.output = hObject;
%设置背景
ha=axes('units','normalized','pos',[0 0 1 1]);
uistack(ha,'bottom');    %置于底部用buttom
ii=imread('C:\Users\Administrator\Desktop\登录页.jpg');   %在当前文件夹下的图片名称
image(ii);
colormap gray
set(ha,'handlevisibility','off','visible','off');



guidata(hObject, handles);





function varargout = gui38_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
global nName;
global cName;
nName=str2double(get(hObject,'String'));
cName=get(hObject,'String');
if(isnan(nName) || length(cName)~=5)
    set(hObject,'String','');
    errordlg('账号必须为5位数字！','错误提醒','modal');
    return;
end




% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
global nMima;
global cMima;
nMima=str2double(get(hObject,'String'));
cMima=get(hObject,'String');
if(isnan(nMima)||length(cMima)<4||length(cMima)>10)
    set(hObject,'String','');
    errordlg('密码必须是4--10位数字','错误提醒','modal');
    return;
end




% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% global nName;
% global nMima;
% if(nName == 12345 && nMima == 000000)
     %%%进入名称为未命名2的GUI
%     set(handles.yonghu,'String','');
%     set(handles.mima,'String','');
    nName=0;nMima=0;   %用户名密码清零
% else
%     errordlg('用户名或密码错误','错误提醒','modal');
%     set(handles.yonghu,'String','');
%     set(handles.mima,'String','');
%     return;
% end
pause(0.5);%暂停n秒
close(gui38);
 tsbh;


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



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
