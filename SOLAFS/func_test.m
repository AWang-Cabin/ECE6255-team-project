[x, Fs] = audioread('tsignal.wav');
y=solafs(x',2,200,150);
soundsc(y,Fs);

