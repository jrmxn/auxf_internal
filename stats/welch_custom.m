function [psd, f] = welch_custom(Y, fs)
h = hamming(size(Y,1))./norm(hamming(size(Y,1)));
Y = Y.*h;
n = 2^nextpow2(size(Y,1));
f = (0:n-1)*(fs/n);
psd = abs(fft(Y, n)).^2;
psd = psd/(fs/2);
psd = psd(1:n/2+1,:);
f = f(1:n/2+1);
end