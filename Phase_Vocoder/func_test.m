[x, Fs] = audioread('tsignal.wav');
y=pvoc(x,2);
% y=solafs(x',2,200,150);
soundsc(y,Fs);

