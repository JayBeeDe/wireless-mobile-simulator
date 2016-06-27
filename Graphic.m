function ret = Graphic()
global display; global l; ret = 0;

if not(strcmp(l.defaultLang, 'EN'))
    Lang('EN');
end
Lang(l.defaultLang);

checkResolution();

mon = get(0, 'monitorPositions');
display.monitor.num = 1;
if (strcmp(display.monitor.select, 'Secondary') || strcmp(display.monitor.select, 'secondary') || strcmp(display.monitor.select, 'S') || strcmp(display.monitor.select, 's'))
    if (size(mon, 1) == 2)   
        display.monitor.num = 2;
    else
        ret = 1;
    end
end

display.taskbar.width = 0;
display.taskbar.height = 0;
if (display.monitor.num == 1)
    if (display.taskbar.position == 'H' || 'h')
        display.taskbar.height = display.taskbar.thin;
    elseif (display.taskbar.position == 'V' || 'v')
        display.taskbar.width = display.taskbar.thin;
    end
end
display.window.x = display.resolution.x/display.resolution.y*(mon(display.monitor.num, 4)-display.taskbar.height )/(mon(display.monitor.num, 3)-display.taskbar.width)*(mon(display.monitor.num, 3)-display.taskbar.width);
display.window.y = mon(display.monitor.num, 4)-display.taskbar.height;

display.window.offset.x = mon(display.monitor.num, 1) - 1 + 1/2*(mon(display.monitor.num, 3) - display.window.x);
display.window.offset.y = mon(display.monitor.num, 2);
end

function checkResolution()
global display; global l;
if(checkIfNum(display.resolution.x) && checkIfNum(display.resolution.y))
    if (display.resolution.y > display.resolution.x)
        error(l.error.resolution2);
    end
else
   error(l.error.resolution1);
end
end

function ret = checkIfNum(num)
ret = false;
if isa(num, 'double')
    if abs(floor(num)) == num
        ret = true;
    end
end
end