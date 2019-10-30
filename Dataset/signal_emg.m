%% setup
a = arduino();
%% 
interv=200;
init_time=1;
tim=zeros(50,100);
emg=zeros(50,100);
%% read
i=1;
figure;
while 1
    fprintf ('Take reading %d?(0/1)', i);
    promt = input(': ');
    if promt == 1
        t=0;
        y=readVoltage(a, 'A1');
        tic;
        while toc<=1
            b=readVoltage(a, 'A1');
            t=[t,toc];
            y=[y,b];
            %plot(t,y)
            %grid on; grid minor;
            %drawnow;
        end
        tim(i,1:size(t,2))=t;
        emg(i,1:size(y,2))=y;
        plot(t,y);
        i=i+1;
    end
    
end