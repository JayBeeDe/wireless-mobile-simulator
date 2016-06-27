classdef Others < handle
    methods(Static)
        
        function ret = loadObstacles(object)
            global obs; global display; global Losses;
            if(Losses.enable == true)   %load and check global obstacles if outside resolution box  just warning
                obs = object;
                ret = 0;
                for i=1:size(obs, 2)
                    for j=1:size(obs(i).x, 2)
                        if (obs(i).x(j) < 0 || obs(i).y(j) < 0 || obs(i).x(j)>display.resolution.x || obs(i).y(j)>display.resolution.y)
                            ret = ret+1;
                        end
                    end
                end
            end
        end
        
        function setDisplayStatus() %Set the threshold to refresh status percentage during processing
            global display;
            display.status.oldnbre = 0;
            display.status.scale = floor(log10(display.resolution.x*display.resolution.y))-2;
            if display.status.scale<2
                display.status.scale = 2;
            end
            display.status.step = 100/(10^display.status.scale)-100/(10^(display.status.scale+1));
            display.status.spr = ['%0.' num2str(display.status.scale-2) 'f'];
        end
        
        function displayStatus(i)   %Refresh status percentage depending on threshold
            global display;
            nbre =  i/(display.resolution.y+1)*100;
            if (nbre-display.status.oldnbre >= display.status.step)
                display.status.oldnbre = nbre;
                clc;
                disp([num2str(sprintf(display.status.spr, nbre)) ' %']);
            end
        end
        
        function A = getAngle(i, j)
            global source;
            A = rad2deg(asin((i-source.y)/sqrt((j-source.x)^2+(i-source.y)^2)));
            if(j<source.x)
                if(i<source.y)
                    A = -180-A;
                else
                    A = 180-A;
                end
            end
        end
        
        function drawFigure()
            global II; global l; global display; clc;
            disp(l.wait);
            f = figure('Name',l.titleWindow,'NumberTitle','off', 'units','pixel','OuterPosition',[display.window.offset.x display.window.offset.y display.window.x display.window.y],'resize','on');
            %movegui(f,'north');
            hold on;
            imagesc(0.5,0.5,II);
            if isfield(display, 'color')
                colormap(display.color.map);
            end
            axis equal; axis([0 display.resolution.x 0 display.resolution.y]); xlabel('x'); ylabel('y'); legend('hide'); title(l.titleWindow);
            hold off;
        end
        
        function displayWarnings()  %display warning if any at the end of the process
            global warning; global l; global Losses; clc;
            disp(l.finish);
            if(warning.retGr==1)
                disp(l.error.monitor);
            end
            if(Losses.enable == true)
                if(warning.retCO>0)
                    if(warning.retCO>1)
                        disp([warning.retCO l.error.objectOutOfBound2 l.error.objectOutOfBound]);
                    else
                        disp([warning.retCO l.error.objectOutOfBound1 l.error.objectOutOfBound]);
                    end
                end
            end
        end
    end
end