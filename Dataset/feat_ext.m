function [feat] = feat_ext(emg,tim)
    l = length(emg);
    fs = l/tim(end);
    b = size(emg,1);
    %initialise features
    MAV= zeros(b,1);
    RMS = zeros(b,1);
    %SSC= zeros(b,1);
    WL = zeros(b,1);
    mfreq = zeros(b,1);
    m1d1 = zeros(b,1);
    m1d2 = zeros(b,1);
    m1d3 = zeros(b,1);
    m1d4 = zeros(b,1);
    m1a4 = zeros(b,1);
    m2d1 = zeros(b,1);
    m2d2 = zeros(b,1);
    m2d3 = zeros(b,1);
    m2d4 = zeros(b,1);
    m2d5 = zeros(b,1);
    m2a5 = zeros(b,1);
    m3d1 = zeros(b,1);
    m3d2 = zeros(b,1);
    m3d3 = zeros(b,1);
    m3d4 = zeros(b,1);
    m3d5 = zeros(b,1);
    m3a5 = zeros(b,1);
    
    for i=1:b
        % Time domain
        MAV(i) = mean(abs(emg(i,:)));
        RMS(i) = rms(emg(i,:));
        %thres=0.01;
        %for j=2:l-1
            %if (emg(i,j) > emg(i,j-1) && emg(i,j) > emg(i,j+1)) || (emg(i,j) < emg(i,j-1) && ...
            %emg(i,j) < emg(i,j+1) && abs(emg(i,j)-emg(i,j+1)) >= thres) || ...
            %(abs(emg(i,j)-emg(i,j-1)) >= thres)
            %SSC(i)=SSC(i)+1; 
            %end
        %end
        for j=2:l
            WL(i)=WL(i)+abs(emg(i,j)-emg(i,j-1)); 
        end
        
       % Spectral 
        mfreq(i)= meanfreq(emg(i,:),fs);
        
       % DWT 
        [c1,l1] = wavedec(emg(i,:),4,'db7');
        [c1d1,c1d2,c1d3,c1d4]=detcoef(c1,l1,[1 2 3 4]);
        c1a4= appcoef(c1,l1,'db7');
        m1d1(i) = rms(c1d1);
        m1d2(i) = rms(c1d2);
        m1d3(i) = rms(c1d3);
        m1d4(i) = rms(c1d4);
        m1a4(i) = rms(c1a4);
        
        [c2,l2] = wavedec(emg(i,:),5,'bior2.2');
        [c2d1,c2d2,c2d3,c2d4,c2d5]=detcoef(c2,l2,[1 2 3 4 5]);
        c2a5= appcoef(c2,l2,'bior2.2');
        m2d1(i) = rms(c2d1);
        m2d2(i) = rms(c2d2);
        m2d3(i) = rms(c2d3);
        m2d4(i) = rms(c2d4);
        m2d5(i) = rms(c2d5);
        m2a5(i) = rms(c2a5);
        
        [c3,l3] = wavedec(emg(i,:),5,'sym4');
        [c3d1,c3d2,c3d3,c3d4,c3d5]=detcoef(c3,l3,[1 2 3 4 5]);
        c3a5= appcoef(c3,l3,'sym4');
        m3d1(i) = rms(c3d1);
        m3d2(i) = rms(c3d2);
        m3d3(i) = rms(c3d3);
        m3d4(i) = rms(c3d4);
        m3d5(i) = rms(c3d5);
        m3a5(i) = rms(c3a5);
    end
feat = [RMS MAV WL mfreq m1d1 m1d2 m1d3 m1d4 m1a4 m2d1 m2d2 m2d3 m2d4 m2d5 m2a5 m3d1 m3d2 m3d3 m3d4 m3d5 m3a5]; 
end