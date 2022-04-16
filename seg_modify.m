function [energy_loss, exec_time, speech_out] = seg_modify(speech, method, t1, t2, target, type, fs)
% Arbitrary Modification of Speech Characteristics in Segmental Durations

% speech -- input speech signal
% method -- sound modification methods
% t1 -- starting time of segmantal duration (sec)
% t2 -- ending time of segmantal duration (sec)
% target -- target duration or scaling factor
% type -- target parameter type ("duration", "scaling")
% speech_out -- signal after modification
% fs -- sampling frequency

% Description:
% Methods can be one of 'SOLAFS', 'Phase_Vocoder', 'WSOLA'
% * "t1", "t2", "target" can be either single values representing a single 
% segment to be modified or arrays with the same length representing multiple
% segments. However, there cannot be any overlaps in the segmental time
% durations. For example, t1 = [1 2], t2 = [2.5 3] is a invalid duration
% defination.
% * Users need to specify the meaning of "target" argument using "type", 
% "duration" type represents the "target" is the desired duration length
% after modification, and "scaling" type represents the "targer is the
% scaling factor of original segments.
% Notice that value of numbers in t1 and t2 must be ascending.

% Examples:
% * Modify a single segment([0.5,1])'s length in the speech to 2s
%   out = seg_modify(speech, 0.5, 1.0, 2.0, "duration");
%
% * Modify three segments in the speech with different scaling factors
%   t1 = [0.5, 1.0, 2.0];
%   t2 = [0.88, 1.5, 3.0];
%   target = [1.0, 1.5, 0.5];
%   out = seg_modify(speech, t1, t2, target, "scaling");
% 
% 
% Kyeomeun Jang, Jiaying Li, Yinuo Wang
% April, 2022

%% variables
seg_num = length(target);
%% trans time domain input to discrete samples
t1 = t1*fs;
t2 = t2*fs;
if t1(1) == 0
    t1(1) = 1;
end
speech_out = []; % initialize speech out

%% for type == "duration" case
scale_factor = (t2-t1)./(target*fs);
%% target is the desired duration of the segmants
if type == "duration"   
    tic
    for i = 1: seg_num
        seg = speech(t1(i):t2(i)); 
        
        if method == "SOLAFS"
            y=solafs(seg',scale_factor(i))';   
        elseif method == "Phase_Vocoder"
            y=pvoc(seg,scale_factor(i));
        else 
             y = stretchAudio(seg,scale_factor(i),"Method","wsola");
        end
        exec_time_temp(i) = toc;
        if i == 1
            head = speech(1:t1(1)); 
            speech_out = [head; y];
        else
            head = speech(t2(i-1):t1(i));
            speech_out = [speech_out; head; y];
        end
    end
    tail = speech(t2(seg_num):end);
    speech_out = [speech_out; tail];
    exec_time = toc;
%% target is the scaling fatcor of the segments (target > 1 means speedup)
elseif type == "scaling"
    tic
    for i = 1: seg_num
        seg = speech(t1(i):t2(i));
        
        if method == "SOLAFS"
            y=solafs(seg',target(i))';
            
        elseif method == "Phase_Vocoder"
            y=pvoc(seg,target(i));
        else 
            y = stretchAudio(seg,target(i),"Method","wsola");            
        end
        
        if i == 1
            head = speech(1:t1(1)); 
            speech_out = [head; y];
        else
            head = speech(t2(i-1):t1(i));
            speech_out = [speech_out; head; y];
        end
    end
    tail = speech(t2(seg_num):end);
    speech_out = [speech_out; tail];
    
    if length(speech_out) == 0
    end
    exec_time = toc;
end

%% calculate energy loss

energy_loss = sum(speech.^2) - sum(speech_out.^2);


