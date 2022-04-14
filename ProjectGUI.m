function varargout = ProjectGUI(varargin)


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
global speech Fs length_n length_t speech_flag
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
speech_flag = 15;


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


% --- Executes on button press in pushbutton2.(input)
function pushbutton2_Callback(hObject, eventdata, handles)
global Fs length_n length_t start_t end_t target input_flag
y = ones(1,length_n);
start_t = str2num(get(handles.edit1, 'String'));
end_t = str2num(get(handles.edit2, 'String'));
target = str2num(get(handles.edit3, 'String'));
flag = 1;
if length(start_t) ~= length(end_t) || length(start_t) ~= length(target) || length(end_t)~= length(target)
    set(handles.text2,'string',"[ERROR] Please make sure inputs have same dimension.");
    flag = 0;
elseif isempty(get(handles.edit1,'String')) && isempty(get(handles.edit2,'String')) && isempty(get(handles.edit3,'String'))
    set(handles.text2,'string',"[ERROR] Please input starting time, ending time and target factor.");
    flag = 0;
elseif get(handles.edit1,'String')=="Start Time" && get(handles.edit2,'String')=="End Time" && get(handles.edit3,'String')=="Target Factor"
    set(handles.text2,'string',"[ERROR] Please input starting time, ending time and target factor.");
    flag = 0;
else
    for i = 1:length(start_t)       
        if start_t(i) < 0 || start_t(i) >= length_t
            set(handles.text2,'string',"[ERROR] Please enter a valid starting time");
            flag = 0;
        end
        if end_t(i) <= 0 || end_t(i) >= length_t
            set(handles.text2,'string',"[ERROR] Please enter a valid ending time");
            flag = 0;
        end
        if target(i) <= 0%
            set(handles.text2,'string',"[ERROR] Please enter a valid target duration or scaling factor");
            flag = 0;
        end
        if start_t(i) == end_t(i) || start_t(i) > end_t(i)%
            set(handles.text2,'string',"[ERROR] Ending time must be larger than starting time");
            flag = 0;
        end
        if i~=1 && start_t(i) < end_t(i-1)
            set(handles.text2,'string',"[ERROR] There must not be overlap between time intervals");
            flag = 0;
        end
        
    end
end
if flag == 1
    set(handles.text2,'string',"[OK] SUCCESSFUL INPUT");
    for i = 1:length(start_t)
        if i == 1 && start_t(1) == 0
            y(1:Fs*(end_t(1))) = target(1);
        else
            y(Fs*start_t(i):Fs*(end_t(i))) = target(i);   
        end     
    end
    axes(handles.axes8)
    t = linspace(0,length_t,length_n);
    plot(t,y);
    xlabel("Time(s)");
    title('User Input Contour');
    input_flag = 20;
end

% --- Executes on button press in pushbutton3. (Modify)
function pushbutton3_Callback(hObject, eventdata, handles)
global speech Fs start_t end_t target target_type speech_mod mod_flag speech_flag input_flag

if get(handles.radiobutton1,'value')
    target_type = "scaling";
    flag = 1;
elseif get(handles.radiobutton2,'value')
    target_type = "duration";
    flag = 1;
else
    set(handles.text2,'string',"Please choose a mode.");
    flag = 0;
end
if speech_flag ~= 15
    set(handles.text2,'string',"Please select a speech file.");
    flag = 0;
end
if input_flag ~= 20
    set(handles.text2,'string',"Please input modification parameters.");
    flag = 0;
end
if flag == 1
    speech_mod = seg_modify(speech, start_t, end_t, target, target_type, Fs);
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
    mod_flag = 10;
end

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
global target_type
target_type = "scaling";



% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
global target_type
target_type = "duration";


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton4. (play initial speech)
function pushbutton4_Callback(hObject, eventdata, handles)
global speech Fs speech_flag
if speech_flag == 15
    soundsc(speech,Fs)
else
    set(handles.text2,'string',"Please select a speech file first.");
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
global speech_mod Fs mod_flag
if mod_flag == 10
    soundsc(speech_mod,Fs)
else
    set(handles.text2,'string',"Please modify the speech first.");
end

% --- Executes on button press in pushbutton6.(Save modified speech)
function pushbutton6_Callback(hObject, eventdata, handles)
global speech_mod Fs
[filename,pathname]=uiputfile({'*.wav','speech_modified'},'save modified speech file');
fullname = [pathname filename];
audiowrite(fullname, speech_mod, Fs);
