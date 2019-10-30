%% Connent arduino
a = arduino()

%% Set-up servos
s1 = servo(a, 'D9')
s2 = servo(a, 'D10')

%% Move servos
writePosition(s1, 0.25)
writePosition(s2, 0.25)
pause(3);

%% Read postion feedback
volt1 = readVoltage(a, 'A0');
pos1 = -6.5485*volt1 + 21.3486
volt2 = readVoltage(a, 'A1');
pos2 = -6.6503*volt2 + 21.3592

%% end