%% setup
a = arduino();
%% 
interv=200;
init_time=1;


%% read
x=0;
figure;     
while 1
    b=readVoltage(a, 'A1');
    x=[x,b];
    %x=lowpass(x,0.01);
    plot(x);
    grid on; grid minor;
    drawnow;
end 