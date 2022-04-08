%% ECE6255 Team Project
% Arbitrary Modification of Speech Characteristics in Segmental Durations

% Kyeomeun Jang, Jiaying Li, Yinuo Wang
% April, 2022

% Description: This is the main script of the project. Users can add any 
% speech files into "input" folder to test the project performance and the 
% modified speeches will be saved in "output" folder. 
clc;
clear;
fprintf("Arbitrary Modification of Speech Characteristics in Segmental Durations\n");
fprintf("=======================================================================\n\n");

%% User Parameters

speech_file = 'input\speech2.wav';
output_file = 'output\speech2_mod.wav';

start_t = 1.0;
end_t = 2.0;
target = 0.5;
target_type = "duration"; 
% target_type = "scaling";

playSpeech = false;

%% Load the speech

[speech, Fs] = audioread(speech_file);
length_n = length(speech); % samples
length_t = length_n / Fs; % seconds

% soundsc(speech);


%% Arbitrary modification

% check input
if length(start_t) ~= length(end_t) || length(start_t) ~= length(target)
    fprintf("[ERROR] Please make sure inputs have same dimension.\n");
end
if target_type ~= "scaling" && target_type ~= "duration"
    fprintf("[ERROR] Please enter a valid target type.\n");
end
for i = 1:length(start_t)
   
    if start_t(i) < 0 || start_t(i) >= length_t
        fprintf("[ERROR] Please enter a valid starting time.\n");
    elseif end_t(i) <= 0 || end_t(i) >= length_t
        fprintf("[ERROR] Please enter a valid ending time.\n");
    elseif target(i) <= 0
        fprintf("[ERROR] Please enter a valid target duration or scaling factor.\n");

    end
end

% implement modification
speech_mod = seg_modify(speech, start_t, end_t, target, target_type, Fs);



%% Save Speech
audiowrite(output_file, speech_mod, Fs);
fprintf("Modifies speech file has been saved as %s successfully.\n",output_file);
if playSpeech == true
    fprintf("Playing the modified speech.\n");
    soundsc(speech_mod);
end

%% Visualization

figure(1);
set(gcf,'Position',[100 100 1000 800]);
row = 3;

t = linspace(0,length_t,length_n);
subplot(row,2,1);
plot(t,speech);
xlabel("Time(s)");
grid on;
title('Original Speech Waveform');

subplot(row,2,2);
t = linspace(0,length(speech_mod)/Fs,length(speech_mod));
plot(t,speech_mod);
xlabel("Time(s)");
grid on;
title('Modified Speech Waveform');

subplot(row,2,3);
spectrogram(speech,100,50,256,Fs,'yaxis');
title('Original Speech Spectrogram');

subplot(row,2,4);
spectrogram(speech_mod,100,50,256,Fs,'yaxis');
title('Modified Speech Spectrogram');

subplot(row,2,5);
pwelch(speech,hamming(500));
grid on;
title('Original Speech Power Spectrum');

subplot(row,2,6);
pwelch(speech_mod,hamming(500));
grid on;
title('Modified Speech Power Spectrum');


%axis tight;