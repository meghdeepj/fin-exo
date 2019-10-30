%% Connent arduino
 a = arduino()

%% Set-up servos
 s1 = servo(a, 'D9')
 s2 = servo(a, 'D10')

%% home postion
 hAng1=0.25;
 hAng2=0.25;

 writePosition(s1, hAng1);
 writePosition(s2, hAng2);
 pause(2);
 
%% Read postion feedback
 volt1 = readVoltage(a, 'A0');
 pos1 = -6.5485*volt1 + 21.3486
 volt2 = readVoltage(a, 'A1');
 pos2 = -6.6503*volt2 + 21.3592
 
 hPos1= pos1;
 hPos2= pos2;

%% set mode
opMode = input('0 for stall at home position \n1 for to and fro mode,       \n2 for collaborative mode \nenter opmode:');
pause(3);
% 0 for stall at home position
% 1 for to and fro mode
% 2 for collaborative mode

 if opMode==0       %hold at home position mode
    writePosition(s2, hAng2);
    writePosition(s1, hAng1);
    pause(3);
 elseif opMode==1   %to-and-fro motion mode
    %create emergency stop button to end loop
    ButtonHandle = uicontrol('Style', 'PushButton','String', ...
                         'Stop loop', 'Callback', 'delete(gcbf)');
    %reset to home position 
    writePosition(s1, hAng1); 
    writePosition(s2, hAng2);
    pause(2);

    while(1)
        if ~ishandle(ButtonHandle)
        disp('Loop stopped by user:');
        break;
        end
        pause(0.01);
        for i=0.25:0.05:0.725
            writePosition(s1,i);
            pause(0.25);
        end
        for i=0.25:0.05:0.75
            writePosition(s2,i);
            pause(0.25);
        end
        pause(1);
        for i=0.75:-0.05:0.25
            writePosition(s2,i);
            pause(0.25);
        end
        for i=0.725:-0.05:0.25
            writePosition(s1,i);
            pause(0.25);            
        end
        pause(1);
   end
    
 elseif opMode==2     %Assistance-as-required mode
    %reset to home position
    writePosition(s2, hAng2);
    writePosition(s1, hAng1);
    pause(2);
    figure;
    while(1)
              
       % collect EMG data, signal process and get state output
       % state 1 - stall
       % state 2 - flexion motion
       tim=0;
       emg=readVoltage(a, 'A2');
       tic;
       while toc<=1
           b=readVoltage(a, 'A2');
           tim=[tim,toc];
           emg=[emg,b];
       end
       plot(tim,emg)
       l =size(emg,2);
       fs = l/tim(end);
      
       % Time domain
       MAV = mean(abs(emg));
       RMS = rms(emg);
       WL=0;
       for j=2:l
           WL=WL+abs(emg(j)-emg(j-1)); 
       end
        
       % Spectral 
       mfreq= meanfreq(emg,fs);
        
       % DWT 
       [c1,l1] = wavedec(emg,4,'db7');
       [c1d1,c1d2,c1d3,c1d4]=detcoef(c1,l1,[1 2 3 4]);
       c1a4= appcoef(c1,l1,'db7');
       m1d1 = rms(c1d1);
       m1d2 = rms(c1d2);
       m1d3 = rms(c1d3);
       m1d4 = rms(c1d4);
       m1a4 = rms(c1a4);
        
       [c2,l2] = wavedec(emg,5,'bior2.2');
       [c2d1,c2d2,c2d3,c2d4,c2d5]=detcoef(c2,l2,[1 2 3 4 5]);
       c2a5= appcoef(c2,l2,'bior2.2');
       m2d1 = rms(c2d1);
       m2d2 = rms(c2d2);
       m2d3 = rms(c2d3);
       m2d4 = rms(c2d4);
       m2d5 = rms(c2d5);
       m2a5 = rms(c2a5);
        
       [c3,l3] = wavedec(emg,5,'sym4');
       [c3d1,c3d2,c3d3,c3d4,c3d5]=detcoef(c3,l3,[1 2 3 4 5]);
       c3a5= appcoef(c3,l3,'sym4');
       m3d1 = rms(c3d1);
       m3d2 = rms(c3d2);
       m3d3 = rms(c3d3);
       m3d4 = rms(c3d4);
       m3d5 = rms(c3d5);
       m3a5 = rms(c3a5);
   
       feat = [RMS MAV WL mfreq m1d1 m1d2 m1d3 m1d4 m1a4 m2d1 m2d2 m2d3 m2d4 m2d5 m2a5 m3d1 m3d2 m3d3 m3d4 m3d5 m3a5]; 
       
       [state,score] = predict(emgSVM,feat);
       
      state
       volt1 = readVoltage(a, 'A0');
       pos1 = -6.5429*volt1 + 21.2651
       volt2 = readVoltage(a, 'A1');
       pos2 = -6.6503*volt2 + 21.3592
       ang1= 0.025*pos1+0.25;
       ang2= 0.025*pos2+0.25;
       
       if(state==1)
          continue;
       elseif(state==2)
           if pos2<hPos2-0.1
               writePosition(s2, hAng2);
               continue;
           elseif pos1<19.5 && pos2<hPos2+0.05
               ang1=ang1+0.075;
               writePosition(s1, ang1);
               writePosition(s2, hAng2);
           elseif pos1>19.5 && pos2<19.5
               ang2=ang2+0.075;
               writePosition(s1, ang1);
               writePosition(s2, ang2);
           elseif pos1>19.5 &&pos2>19.5
               q = input("Flexion complete, return to home position? (0/1) :");
               if q==1
                   for i=0.75:-0.05:0.25
                    writePosition(s2,i);
                    pause(0.25);
                   end
                   for i=0.725:-0.05:0.25
                    writePosition(s1,i);
                    pause(0.25);            
                   end
                   pause(1);
               elseif q==0 
                   continue;
               end
      
           end
           pause(0.5);
       end
    end
 end
%% end of code