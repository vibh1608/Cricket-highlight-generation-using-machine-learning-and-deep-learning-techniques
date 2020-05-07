load('replay_train.mat')		%Model trained for detecting replay
load('bowlact_trained1.mat');	%Model trained for detecting bowler action 
%for over 20
for p=20:20
    smt=1;
    smt1=1;
    replaydet=0;
    l1=length(over{1,p}.wicket1);
    %obj=VideoReader(over{1,p}.name);
    %vidFrames=read(obj);
    %[r,c,t,n]=size(obj);    
    ind=1;
    for a=1:l1-3
        replaydet=0;        
        if(over{1,p}.run1(a)-over{1,p}.run1(a-1)>=4||over{1,p}.run1(a)-over{1,p}.run1(a-1)==6||over{1,p}.wicket1(a)-over{1,p}.wicket1(a-1)==1)            
            start=a-3;
            last=a+2;
            if(over{1,p}.run1(a)-over{1,p}.run1(a-1)==6||over{1,p}.wicket1(a)-over{1,p}.wicket1(a-1)==1)
                start=a-5;
                last=a+2;
            end
            if(start<=0)
                start=1;
            end
			%To find the starting frame (When bowler action appears)
            for b=start:last
                k=vidFrames(:,:,:,over{1,p}.frameCount(b));
                if(ReplayFunction(k,classifier, testing_features)==1)
                    continue;
                else
                     display('Replay')
                end
                if(BowlerFunction(k,sup,testingfeatures)==1)
                    start=b;
                    break;
                end
            end
			%To find the ending frame
            for b=start:last
                k=vidFrames(:,:,:,over{1,p}.frameCount(b));
                if(ReplayFunction(k,classifier, testing_features)==1)
                    replaydet=replaydet+1;
                end
                if(replaydet>=1 && ReplayFunction(k,classifier, testing_features)==0)
                   if(BowlerFunction(k,sup,testingfeatures)==1)
                        last=b-1;
                        break;
                    end 
                end                
            end  
			%To store highlights frames to be displayed 
            for b=start:last
                display('hello');
                over{1,p}.autohighshot2(ind)=b;
                ind=ind+1;
            end            
            %st=over{1,p}.frameCount(start);
            %ed=over{1,p}.frameCount(last);
            %for b=st:ed-10
             %   imshow(vidFrames(:,:,:,b));
            %end
           % if(over{1,p}.run(a)-over{1,p}.run(a-1)==4)
            %     for b=start:last
             %            over{1,p}.autofour(smt)=b;
              %           smt=smt+1;               
               %  end
                % replaydet=0;
            %end
            %if(over{1,p}.run(a)-over{1,p}.run(a-1)==6)
             %    for b=start:last
              %       over{1,p}.autosix(smt1)=b;
               %      smt1=smt1+1; 
            %end
            %replaydet=0;
            %end
        end
end
end