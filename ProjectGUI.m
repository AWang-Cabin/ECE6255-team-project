function varargout = ProjectGUI(varargin)

global start_time end_time target_factor speech Fs target_type
start_time = [];
end_time = [];
target_factor = [];
speech_file = 'input\speech2.wav';
[speech, Fs] = audioread(speech_file);
length_n = length(speech); % samples
length_t = length_n / Fs; % seconds

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ProjectGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ProjectGUI_OutputFcn, ...
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


% --- Executes just before ProjectGUI is made visible.
function ProjectGUI_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


function varargout = ProjectGUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global speech Fs length_n length_t
[file_name,file_path]=uigetfile('*.wav','select speech file');
full_name = [file_path file_name];
[speech, Fs] = audioread(full_name);
axes(handles.axes1)
length_n = length(speech); % samples
length_t = length_n / Fs; % seconds
t = linspace(0,length_t,length_n);
plot(t,speech);
xlabel("Time(s)");
title('Original Speech Waveform');
axes(handles.axes2)
spectrogram(speech,100,50,256,Fs,'yaxis');
title('Original Speech Spectrogram');
axes(handles.axes3)
pwelch(speech,hamming(500));
title('Original Speech Power Spectrum');



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global speech Fs length_n length_t start_time end_time target_factor
y = ones(1,length_n);
start_time = sort([start_time str2num(get(handles.edit1, 'String'))]);
end_time = sort([end_time str2num(get(handles.edit2, 'String'))]);
target_factor = sort([target_factor str2num(get(handles.edit3, 'String'))]);
for i = 1:length(start_time)
    y(Fs*start_time(i):Fs*(end_time(i))) = target_factor(i);
end
axes(handles.axes8)
t = linspace(0,length_t,length_n);
plot(t,y);
xlabel("Time(s)");
title('User Input Contour');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global speech Fs start_time end_time target_factor target_type
speech_mod = seg_modify(speech, start_time, end_time, target_factor, target_type, Fs);

axes(handles.axes5)
t = linspace(0,length(speech_mod)/Fs,length(speech_mod));
plot(t,speech_mod);
xlabel("Time(s)");
title('Modified Speech Waveform');

axes(handles.axes6)
spectrogram(speech_mod,100,50,256,Fs,'yaxis');
title('Modified Speech Spectrogram');

axes(handles.axes7)
pwelch(speech_mod,hamming(500));
title('Modified Speech Power Spectrum');



% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
global target_type
target_type = "scaling";



% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
global target_type
target_type = "duration";
