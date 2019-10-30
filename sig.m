function [pks, MAV, SSC, WL, ZC, mfreq] = sig(t1,y1)

%peaks
pks= findpeaks(y1,'MinPeakProminence',1)

%mean absolute value
MAV=mean(abs(y1));

%spectral separation coefficient
N=length(y1); SSC=0;
thres=0.01
for i=2:N-1
  if (y1(i) > y1(i-1) && y1(i) > y1(i+1)) || (y1(i) < y1(i-1) && ...
      y1(i) < y1(i+1) && abs(y1(i)-y1(i+1)) >= thres) || ...
      (abs(y1(i)-y1(i-1)) >= thres)
    SSC=SSC+1; 
  end
end

%waveform length
N=length(y1); WL=0;
for i=2:N
  WL=WL+abs(y1(i)-y1(i-1)); 
end

%zero crossing
N=length(y1); ZC=0; 
for i=1:N-1
  if (y1(i) > 0 && y1(i+1) < 0) || (y1(i) < 0 && y1(i+1) > 0 ...
      && abs(y1(i)-y1(i+1)) >= thres)
    ZC=ZC+1;
    
  end
end
yf=fft(y1);
figure;
pspectrum(y1);
mfreq= meanfreq(y1);

figure;
pwelch(y1)
end