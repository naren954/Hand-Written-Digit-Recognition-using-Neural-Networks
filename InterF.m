function varargout = InterF(varargin)
% INTERF MATLAB code for InterF.fig
%      INTERF, by itself, creates a new INTERF or raises the existing
%      singleton*.
%
%      H = INTERF returns the handle to a new INTERF or the handle to
%      the existing singleton*.
%
%      INTERF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERF.M with the given input arguments.
%
%      INTERF('Property','Value',...) creates a new INTERF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InterF_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InterF_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help InterF

% Last Modified by GUIDE v2.5 01-May-2018 22:21:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InterF_OpeningFcn, ...
                   'gui_OutputFcn',  @InterF_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before InterF is made visible.
function InterF_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InterF (see VARARGIN)

% Choose default command line output for InterF
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
axes(handles.axes4);
imshow('default.png');
axes(handles.axes5);
imshow('default.png');
axes(handles.axes6);
imshow('default.png');
axes(handles.axes8);
imshow('default.png');
load data;
handles.net=net;
% UIWAIT makes InterF wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = InterF_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.*'}, 'Pick an Image File');
trimg = imread([pathname,filename]);

selected_col = get(handles.edit2,'string');
selected_col = evalin('base',selected_col);

selected_ln = get(handles.edit4,'string');
selected_ln = evalin('base',selected_ln);

img = edu_imgpreprocess(trimg,selected_col,selected_ln);

for cnt = 1:selected_ln * selected_col;
    bw2 = edu_imgcrop(img{cnt});
    charvec = edu_imgresize(bw2);
    out(:,cnt) = charvec;
end
P = out(:,1:40); 
T = [eye(10) eye(10) eye(10) eye(10)];



net = edu_createnn(P,T);
handles.net = net;


assignin('base','net',net);
guidata(hObject, handles);
set(handles.pushbutton3,'Enable','on');
set(handles.pushbutton5,'Enable','on');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load ('Net.mat');
handles.net=net;
set(handles.pushbutton3,'Enable','on');
set(handles.pushbutton5,'Enable','on');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'}, 'Pick an Image File');
S = imread([pathname,filename]);
axes(handles.axes4);
imshow(S);
axes(handles.axes5);
imshow('default.png');
axes(handles.axes6);
imshow('default.png');
axes(handles.axes8);
imshow('default.png');
handles.S = S;
guidata(hObject, handles);
%set(handles.text2,'String',filename);
set(handles.pushbutton11,'Enable','on')
helpdlg('Image has been Loaded Successfully.');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   %read the image file
load('num.mat');
load('ReadyW.mat');
bw2  = handles.bw2;
charvec = edu_imgresize(bw2);
axes(handles.axes5);
%plotchar(charvec);
handles.charvec = charvec;
guidata(hObject, handles);
charvec = handles.charvec;
selected_net = "net";

selected_net = evalin('base',selected_net);

result = sim(selected_net,charvec);
[val, num] = max(result);
axes(handles.axes8);
xax=[1,2,3,4,5,6,7,8,9,0];
bar(xax,result);
if num==10
    num=0;
end

set(handles.edit1, 'string',num);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('ReadyW.mat');
load('test.mat');
testX=testX';
testY=testY';
[dummy, f] = max(testY, [], 2);
testY=f;
pr = pred(Theta1, Theta2, testX);
acc=mean(double(pr == testY)) * 100;
ac=num2str(acc)
prin=strcat('Neural Network Accuracy: ',ac);
helpdlg(prin);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img_crop = handles.S;
if( size(img_crop,3)==3)
    imgGray = rgb2gray(img_crop);
else
    imgGray=img_crop;
end

bw = im2bw(img_crop,graythresh(imgGray));
axes(handles.axes5);
imshow(bw);
bw2 = edu_imgcrop(bw);
axes(handles.axes6);
imshow(bw2);
handles.bw2 = bw2;
guidata(hObject, handles);
set(handles.pushbutton4,'Enable','on');

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
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
