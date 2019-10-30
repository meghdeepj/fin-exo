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
 
%% Read postion feedback
 volt1 = readVoltage(a, 'A0');
 pos1 = -6.5485*volt1 + 21.3486
 volt2 = readVoltage(a, 'A1');
 pos2 = -6.6503*volt2 + 21.3592
 
 accuracy =  sum((predict(SVMModel,te_feat(:,:))) == te_label)/length(te_label)*100

%% set mode
opMode = input('0 for stall at home position \n1 for to and fro mode,       \n2 for collaborative mode \nenter opmode:');
pause(3);
% 0 for stall at home position
% 1 for to and fro mode
% 2 for collaborative mode

 if opMode==0       %hold at home position mode
    writePosition(s1, hAng1);
    writePosition(s2, hAng2);
    pause(4);
 elseif opMode==1   %to-and-fro motion mode
    %create emergency stop button to end loop
    ButtonHandle = uicontrol('Style', 'PushButton','String', ...
                         'Stop loop', 'Callback', 'delete(gcbf)');
    %reset to home position 
    writePosition(s1, hAng1); 
    writePosition(s2, hAng2);
    pause(3);

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
    writePosition(s1, ang1);
    writePosition(s2, ang2);
    pause(4);
    while(1)
       state =0;
       
       % collect EMG data, signal process and get state output
       % state 0 - stall
       % state 1 - grasp motion
       volt1 = readVoltage(a, 'A0');
       pos1 = -6.5429*volt1 + 21.2651;
       volt2 = readVoltage(a, 'A1');
       pos2 = -6.5429*volt2 + 21.2651;
       ang1= 0.025*pos1+0.25;
       ang2= 0.025*pos2+0.25;
       if(state==1)
          continue;
       elseif(state==2)
             for i=0.25:0.05:0.725
            writePosition(s1,i);
            pause(0.05);
        end
        for i=0.25:0.05:0.75
            writePosition(s2,i);
            pause(0.05);
        end
        pause(1);
        for i=0.75:-0.05:0.25
            writePosition(s2,i);
            pause(0.05);
        end
        for i=0.725:-0.05:0.25
            writePosition(s1,i);
            pause(0.05);            
        end
       end
       %elseif(state==2)
           %if pos2<hpos-0.1
               % writePosition(s2, hAng2);
               % continue;
           % elseif pos1<19.5 && pos2<hpos+0.05
           %    ang1=ang1-0.05;
           %    writePosition(s1, ang1);
           %    writePosition(s1, hAng2);
         %  elseif pos1>19.5 && pos2<19.5
          %     ang2=ang2-0.05;
          %     writePosition(s1, ang1);
          %     writePosition(s2, ang2);
          % elseif pos1>19.5 &&pos2>19.5
           %    pos1 = 19.9;
           %    pos2 = 19.9;
           %    continue;
    end
 end
        
%% end of code