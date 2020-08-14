function sequence(handles)
    global xpiezo ypiezo s b vid
  
        n=0;
        rangeV = 120;
        numDiv = 12;
        matrixUnitLength = 120/numDiv;
        stepVolt = matrixUnitLength/2;
        sT = 6;      % 8 secs
        sS = 100;
        nS = rangeV*sS;
        
    if s==1                
        for y=1:numDiv            
            ypiezo.SetVoltOutput(0,(y*matrixUnitLength-stepVolt));
            if n==0                
                for x=0:nS
                    if b==0
                        break;
                    end
%                     xpiezo.SetVoltOutput(0,(x*matrixUnitLength-stepVolt));
                    xpiezo.SetVoltOutput(0,x/sS);
                    pause(sT/nS);
                    n=1;
                end
            elseif n==1
                for x=0:nS
                    if b==0
                        break;
                    end
%                     xpiezo.SetVoltOutput(0,(120-(x*matrixUnitLength-stepVolt)));
                    xpiezo.SetVoltOutput(0,(nS-x)/sS);
                    pause(sT/nS);
                    n=0;
                end
            end
            if b==0
                break;
            end
        end
    end
end