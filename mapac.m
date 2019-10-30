function Po2 = mapac()

a = arduino()
s2 = servo(a, 'D10')

A2 = zeros(10,1);
B2 = zeros(10,1);
m=1;
    for i = 0.25:0.05:0.75
        writePosition(s2, i);
        pause(5);
        volt2 = readVoltage(a, 'A1');
        A2(m)=volt2;
        m=m+1;
    end
writePosition(s2,0.25);
m=1;
 for i = 0.25:0.05:0.75
        writePosition(s2, i);
        pause(5);
        volt2 = readVoltage(a, 'A1');
        B2(m)=volt2;
        m=m+1;
    end
writePosition(s2,0.25);
P2 = 0:2:20;
P2 = P2';
C2 = [A2 B2]
M2 = mean(C2,2);

Po2 = polyfit(M2,P2,1);
end