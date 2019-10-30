for i=1:265
    plot (tim(i,:), emg(i,:))
    title(['Data number ',num2str(i)])
   % a=input('Keep or delete(0/1): ');
    %if a==0
     %   emg(i,:)=[];
      %  tim(i,:)=[];
    %end
    pause(1.6)
end