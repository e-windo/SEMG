function varargout = analysisTool(varargin)
% ANALYSISTOOL MATLAB code for analysisTool.fig
%      ANALYSISTOOL, by itself, creates a new ANALYSISTOOL or raises the existing
%      singleton*.
%
%      H = ANALYSISTOOL returns the handle to a new ANALYSISTOOL or the handle to
%      the existing singleton*.
%
%      ANALYSISTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSISTOOL.M with the given input arguments.
%
%      ANALYSISTOOL('Property','Value',...) creates a new ANALYSISTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analysisTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analysisTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analysisTool

% Last Modified by GUIDE v2.5 20-Jun-2017 17:37:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysisTool_OpeningFcn, ...
                   'gui_OutputFcn',  @analysisTool_OutputFcn, ...
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


% --- Executes just before analysisTool is made visible.
function analysisTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analysisTool (see VARARGIN)

% Choose default command line output for analysisTool
handles.output = hObject;

set(handles.figure1,'name','sEMG Analysis tool','numbertitle','off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes analysisTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = analysisTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valid = true;
ri = 'Run ID';
pasn = 'Plot and Store number';
msg = 'Error occurred.';
disp('Beginning import...');
try
    runID =  str2double(handles.edit1.String);
    if isnan(runID)
        error(msg);
    else
        handles.runID = runID;
    end
catch
    handles.edit1.String = ri;
    disp(['Invalid ',ri]);
    valid = false;
end
try
    plotID =  str2double(handles.edit2.String);
    if isnan(plotID)
        error(msg);
    else
        handles.plotID = plotID;
    end
catch
    handles.edit2.String = pasn;
    disp(['Invalid ',pasn]);
    valid = false;
end
if valid
    try
        [d,~,o] = getMVCScaledData(handles.runID);
        data = d{handles.plotID};
        origData = o{handles.plotID};
        handles.data = getTableData(data,'EMG');
        handles.origData = getTableData(origData,'EMG');
        handles.t = data{:,1};
        disp('Data loaded');
    catch
        disp('Error in data import');
        valid = false;
    end
end

handles.validData = valid;

handles.checkbox1.Value = 0;
handles.checkbox2.Value = 0;
handles.checkbox3.Value = 0;

handles.checkbox4.Value = 0;
handles.checkbox5.Value = 0;
handles.checkbox6.Value = 0;

handles.checkbox7.Value = 0;
handles.checkbox8.Value = 0;
handles.checkbox9.Value = 0;

handles.checkbox10.Value = 0;
handles.checkbox11.Value = 0;
handles.checkbox12.Value = 0;

handles.checkbox13.Value = 0;

handles.checkBoxStates = zeros(1,13);
handles.lockX = 0;
handles.lockY = 0;

guidata(hObject,handles);

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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
handles.checkBoxStates(1) = hObject.Value;
guidata(hObject,handles);

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
handles.checkBoxStates(2) = hObject.Value;
guidata(hObject,handles);

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
handles.checkBoxStates(3) = hObject.Value;
guidata(hObject,handles);

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
handles.checkBoxStates(4) = hObject.Value;
guidata(hObject,handles);

% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
handles.checkBoxStates(5) = hObject.Value;
guidata(hObject,handles);

% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
handles.checkBoxStates(6) = hObject.Value;
guidata(hObject,handles);

% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
handles.checkBoxStates(7) = hObject.Value;
guidata(hObject,handles);

% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
handles.checkBoxStates(8) = hObject.Value;
guidata(hObject,handles);

% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9
handles.checkBoxStates(9) = hObject.Value;
guidata(hObject,handles);

% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10
handles.checkBoxStates(10) = hObject.Value;
guidata(hObject,handles);

% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11
handles.checkBoxStates(11) = hObject.Value;
guidata(hObject,handles);

% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12
handles.checkBoxStates(12) = hObject.Value;
guidata(hObject,handles);

% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13
handles.checkBoxStates(13) = hObject.Value;
guidata(hObject,handles);


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
try
temp = ceil(str2double(hObject.String));
if isnan(temp)
    err('Nope');
end
catch
   temp = NaN;
   disp('Invalid lower axis limit'); 
end
handles.lowerLim = temp;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
try
    temp = ceil(str2double(hObject.String));
    if isnan(temp)
        err('Nope');
    end
catch
    temp = NaN;
    disp('Invalid upper axis limit');
end
handles.upperLim = temp;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
    handles.lockX = hObject.Value;
    guidata(hObject,handles);

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
    handles.lockY = hObject.Value;
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N = sum(handles.checkBoxStates);
for i = 1:length(handles.currData)
    figure
for j = 1:length(handles.currData{i})
    sel = handles.currData{i}{j}(:,logical(handles.checkBoxStates));
    ax = cell(1,N);
    for k = 1:N
        ax{k} = subplot(N,1,k);
        hold on;
        plot(1:length(sel{:,k}),sel{:,k});
    end
    lockXY(ax,handles.radiobutton1.Value,handles.radiobutton2.Value);
    for k = 1:N
        subplot(N,1,k);
        setAxis(handles.lowerLim,handles.upperLim);
    end
end
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N = sum(handles.checkBoxStates);
for i = 1:length(handles.currData)
    figure
for j = 1:length(handles.currData{i})
    sel = handles.currData{i}{j}(:,logical(handles.checkBoxStates));
    ax = cell(1,N);
    for k = 1:N
        ax{k} = subplot(N,1,k);
        hold on;
        temp = sel{:,k};
        temp = rmsFilter(temp,500);
        plot(1:length(temp),temp);
    end
    lockXY(ax,handles.radiobutton1.Value,handles.radiobutton2.Value);
    for k = 1:N
        subplot(N,1,k);
        setAxis(handles.lowerLim,handles.upperLim);
    end
end
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N = sum(handles.checkBoxStates);
for i = 1:length(handles.currData)
    figure
for j = 1:length(handles.currData{i})
    sel = handles.currData{i}{j}(:,logical(handles.checkBoxStates));
    ax = cell(1,N);
    for k = 1:N
        ax{k} = subplot(N,1,k);
        hold on;
        aNiceFSpectrum(sel{:,k},2000);
    end
    lockXY(ax,handles.radiobutton1.Value,handles.radiobutton2.Value);
    for k = 1:N
        subplot(N,1,k);
        setAxis(handles.lowerLim,handles.upperLim);
    end
end
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

idX = handles.popupmenu3.Value;
idY = handles.popupmenu4.Value;


for i = 1:length(handles.currData)
    figure
for j = 1:length(handles.currData{i})
    
    coco = getCocontraction([],[],handles.currData{i}{j}{:,idX},handles.currData{i}{j}{:,idY});
    plot(1:length(coco),coco);
    hold on;
    setAxis(handles.lowerLim,handles.upperLim);
end
end

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

N = sum(handles.checkBoxStates);
for i = 1:length(handles.currData)
    figure
for j = 1:length(handles.currData{i})
    sel = handles.currData{i}{j}(:,logical(handles.checkBoxStates));
    ax = cell(1,N);
    for k = 1:N
        ax{k} = subplot(N,1,k);
        hold on;
        temp = getMedFreqFramed(sel{:,k},200);
        plot(1:length(temp),temp);
    end
    lockXY(ax,handles.radiobutton1.Value,handles.radiobutton2.Value);
    for k = 1:N
        subplot(N,1,k);
        setAxis(handles.lowerLim,handles.upperLim);
    end
end
end
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N = sum(handles.checkBoxStates);
for i = 1:length(handles.currData)
    figure
    temp = zeros(size(handles.currData{i}{1}{:,:}));
    for j = 1:length(handles.currData{i})
        temp = temp + handles.currData{i}{j}{:,:};
    end
    temp = temp ./ length(handles.currData{i});
    
    sel = temp(:,logical(handles.checkBoxStates));
    ax = cell(1,N);
    for k = 1:N
        ax{k} = subplot(N,1,k);
        hold on;
        temp = morphOps(activityDetHMM(sel(:,k),4,[],[]),'erodeSpan',5,'dilateSpan',10);
        stem(1:length(temp),temp);
    end
    lockXY(ax,handles.radiobutton1.Value,handles.radiobutton2.Value);
    for k = 1:N
        subplot(N,1,k);
        setAxis(handles.lowerLim,handles.upperLim);
    end
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Beginning partition...');
handles.currData = handles.data;
handles.currOrig = handles.origData;
studyType = handles.popupmenu1.Value;
try
nRepeats = round(str2double(handles.edit4.String)); 
if isnan(nRepeats)
    error('Nope');
end
catch
    nRepeats = 1;
    disp('Invalid number of repeats');
end
handles.nRepeats = nRepeats;
section = handles.edit3.String;

if studyType == 1
    [~,~,raw] = xlsread('FATIGUE_AMENDED.xlsx',['timings_',num2str(handles.runID)]);
else
    technique = 'TECHNIQUE_AMENDED.xlsx';
    [~,sheets] = xlsfinfo(technique);
    m = regexp(sheets,[num2str(handles.runID),'_'],'match');
    sheets = sheets(~cellfun(@isempty,m));
    [~,~,raw] = xlsread(technique,sheets{handles.plotID});
end

fh = @(x) all(isnan(x(:)));
firstcol = raw(:,1);
firstcol(cellfun(fh,firstcol)) = {'NO'};
firstrow = raw(1,:);
firstrow(cellfun(fh,firstrow)) = {'NO'};
matchesCol = regexp(firstcol,['^',section],'match');
matchesRow = regexp(firstrow,'(^.*Plot and Store.*)','match');
nPlotAndStore = sum(~cellfun(@isempty,matchesRow));

bounds = zeros(length(matchesCol),2*nPlotAndStore);
usedIndices = ~cellfun(@isempty,matchesCol);

for i= 1:length(matchesCol)
    if usedIndices(i)==1
        for j = 0:nPlotAndStore-1
            bounds(i,1+2*j) = raw{i,4+2*j};
            bounds(i,2+2*j) = raw{i+1,4+2*j};
        end
    end
end
bounds(~usedIndices,:) = [];
rowNames = cellfun(@(x)(x(:)),matchesCol(usedIndices));
bounds = array2table(bounds,'RowNames',rowNames);
currData = cell(1,height(bounds));
for i = 1:height(bounds)
    selector = @(x)((x>bounds{i,1}')&(x<bounds{i,2}'));
    indices = selector(handles.t);
    N = sum(indices);
    ords = num2words(1:N); 
    sectionedNames = strcat({nameFormat(rowNames{i})},{'_'},ords);
    sectionedData = array2table(handles.data{indices,:},'RowNames',sectionedNames,'VariableNames',handles.data.Properties.VariableNames);
    temp = cell(1,nRepeats);
    for j = 1:nRepeats
        temp{j} = sectionedData((round(1+(j-1)*height(sectionedData)/nRepeats):round(j*height(sectionedData)/nRepeats)),:);
    end
    currData{i} = temp;
end


handles.currData = currData;
guidata(hObject,handles);
disp('Data partitioned');

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.figure1, 'HandleVisibility', 'off');
close all;
set(handles.figure1, 'HandleVisibility', 'on');


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
