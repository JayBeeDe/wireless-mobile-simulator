function Propagation()

%% ================================= GLOBAL ==============================%%
tic; close all; clc; format long; %clear all; 
global display; global II; global Ptrans; global Losses; global l; global source; global warning;

%% ============================= DISPLAY SETTINGS =========================%%
display.resolution.x = 100; %(>0, non decimal, resolution.x>=resolution.y)
display.resolution.y = 100; %(>0, non decimal)
display.monitor.select = 'S';   %(P/S) <in extended desktop mode only> Select the monitor to display figure (secondary : S // primary : P)
display.taskbar.thin = 30;  %<if displayed in primary monitor> Size of the os taskbar
display.taskbar.position = 'H'; %(H/V)<if displayed in primary monitor> Os taskbar position (bottom or top : H // left or right : V)
display.color.map = 'Autumn';   %Load colormap from matlab templates
l.defaultLang = 'EN';   %Display language

%% ======================= SOURCE DEFAULT SETTINGS =======================%%
Ptrans.offset = -90; %(-180...180) Offset in degree of the source from the right horizontal axis (counterclockwise)
Ptrans.powerMax = 15;   %Power max of the source
Ptrans.formula =  @(x, d) 0.5*(1+cos(2*x*pi/d)).*(abs(x)<d/2+0.05);    %Formula depending on the angle centered on the offset axis
Ptrans.directivity = 0;    %(0/1..360) <if not precised for a non referenced/precised type of source> Openness of the source in degree. Disable if set to 0 (equivalent to source set to 'omnidirectional')

%% ======================= LOSSES DEFAULT SETTINGS =======================%%
Losses.l = 23;  %<if not precised for a non referenced/precised type of obstacle> Losses
Losses.distanceAlpha = 4;   %(>0, non decimal) 1/d^Alpha -> Alpha attenuation
Losses.incidenceFormula = @(x)cos(x);   %Formula for refraction depending on angle of refraction
Losses.enable = true;   %Enable Obstcles
Losses.enablePolyxPoly = false; %faster if enable but no indices for refraction
Losses.epsilon = 0.01;  %<only if enablePolyxPoly set to false> Threshold to detect or not interception

%% =========================== IMPORTANT SETTINGS =========================%%
source = Source(Coor(60, 75)); %Declare Source(coor, type, <powerMax>, <offset>, <directivity>)
object(1) = Obstacles([5 75], [60 55], '', ''); % Declare Obstacles(xvect, yvect, <type>, <form>)
object(2) = Obstacles([23 4], [43 4], 'beton', 'doubleWall');   %.../...    xvect = [x1, x2, ..., xn] // yvect = [y1, y2, ..., yn]

%% ============================== MAIN FUNCTION ============================%%
warning.retGr = Graphic();  %catch graphics warnings and set graphic settings
II = zeros(display.resolution.y, display.resolution.x); %initilize big matrix
warning.retCO = Others.loadObstacles(object);  %catch obstacles warning and set obstacles only if Losses are set to true
Others.setDisplayStatus(); %initialise status percentage display

for i = 1:display.resolution.y  %browse each line
    Others.displayStatus(i);
    for j = 1:display.resolution.x   %browse each column
        if (i == source.y && j == source.x)
            pix = source.powerMax;
        else
            d = sqrt((source.x-j)^2+(source.y-i)^2);
            A = Others.getAngle(i, j);    %angle A in deg without offset
            if(source.directivity ~= 0)
                S = source.formula(deg2rad(offset(A, source.offset)), deg2rad(source.directivity)); %0..1 -> W coef
            else
                S = 1;
            end
            L = calculateLosses(j, i, A);   %dB
            pix = 10*(log10(S*source.powerMax/d^Losses.distanceAlpha))-L;
        end
        II(i, j) = pix;
    end
end
Others.drawFigure();
Others.displayWarnings();
toc;
end


%% ============================ OTHER FUNCTIONS ============================%%

function L = calculateLosses(x, y, A)
global obs; global source; global Losses; L = 0;
if(Losses.enable == true)
    if(Losses.enablePolyxPoly == true)    %with polyxpoly method
        for oi=1:size(obs, 2)   % Browse each obstacles
            [xtmp ytmp] = polyxpoly([x source.x], [y source.y], obs(oi).x, obs(oi).y);
            if(not(isempty(xtmp)))
                L = L + size(xtmp, 1)*obs(oi).losses;
            end
        end
    else    %without polyxpoly method
        for oi=1:size(obs, 2)   % Browse each obstacles
                q = Intersection(x, y, oi, A);
                L = L + q*obs(oi).losses;
        end
    end
end
end

function nAngle = offset(angle, offset)
nAngle = angle;
if (offset ~= 0)
    if (offset > 0)
        if (angle>=offset-180 && angle<=180)
            nAngle = angle - offset;
        elseif (angle>=-180 && angle<offset-180)
            nAngle = angle + 360 - offset;
        end
    else
        if(angle>=-180 && angle<=180+offset)
            nAngle = angle - offset;
        elseif(angle>180+offset && angle<=180)
            nAngle = angle - 360 - offset;
        end
    end
end
end
