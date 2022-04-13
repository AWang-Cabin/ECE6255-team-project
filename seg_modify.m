function [speech_out] = seg_modify(speech, t1, t2, target, type, fs)
% Arbitrary Modification of Speech Characteristics in Segmental Durations

% speech -- input speech signal
% t1 -- starting time of segmantal duration (sec)
% t2 -- ending time of segmantal duration (sec)
% target -- target duration or scaling factor
% type -- target parameter type ("duration", "scaling")
% speech_out -- signal after modification
% fs -- sampling frequency

% Description:
% * "t1", "t2", "target" can be either single values representing a single 
% segment to be modified or arrays with the same length representing multiple
% segments. However, there cannot be any overlaps in the segmental time
% durations. For example, t1 = [1 2], t2 = [2.5 3] is a invalid duration
% defination.
% * Users need to specify the meaning of "target" argument using "type", 
% "duration" type represents the "target" is the desired duration length
% after modification, and "scaling" type represents the "targer is the
% scaling factor of original segments.


% Examples:
% * Modify a single segment([0.5,1])'s length in the speech to 2s
%   out = seg_modify(speech, 0.5, 1.0, 2.0, "duration");
%
% * Modify three segments in the speech with different scaling factors
%   t1 = [0.5, 1.0, 2.0];
%   t2 = [0.88, 1.5, 3.0];
%   target = [1.0, 1.5, 0.5];
%   out = seg_modify(speech, t1, t2, target, "scaling");

% Kyeomeun Jang, Jiaying Li, Yinuo Wang
% April, 2022

%% variables
seg_num = length(target);
% the number of block for unit time
numb = length_n / length_t;

%% trans time domain input to discrete samples
length_n = length(speech);
length_t = length_n / fs;
for i = 1:seg_num
    t1(i) = max(round(t1(i)*numb ), 1);
    t2(i) = min(round(t2(i)*numb ), length_n);
    if t2(i) < t1(i)
        t2(i) = t1(i);
end

%% target is the desired duration of the segmants
if type == "duration"
    for i = 1: seg_num
        seg = speech(t1(i):t2(i));

    end

%% target is the scaling fatcor of the segments
elseif type == "scaling"
    for i = 1: seg_num
        seg = speech(t1(i):t2(i));
        y=solafs(seg',1/target);
        speech_out_length = length(speech) - length(seg) + length(y)

    end

end

for i = 1:seg_num
    for j = 1:speech_out_length
        if j < t1(i)
            speech_out(j) = speech(j);
        elseif j >= t1(i) & j < (t1(i) + length(y))
            speech_out(j) = y(j - t1(i) + 1);
        else 
            speech_out(j) = speech(t2(i)+ j - (t1(i) + length(y)));
        end
    end
end


end

