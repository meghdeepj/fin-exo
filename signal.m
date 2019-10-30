%% setup
a = arduino();

interv=200;
init_time=1;

y=0;
x=0;
t=0;
%% read

while 1
    b=readVoltage(a, 'A2');
    t=[t,x];
    y=[y,b];
    plot(t,y)
    grid on; grid minor;
    drawnow;
    pause(0.01);
    x=x+0.01;
end 