function Lang(lg)
global l;
switch lg
    case 'DE'
        %write here
    otherwise
        l.titleWindow='Region of Interest';
        l.error.monitor='Secondary Monitor has been selected but this computer is not in dual screen extended mode.\nThe figure will be displayed on the main monitor !';
        l.error.resolution1='Resolution must be a positive non decimal number !';
        l.error.resolution2='x resolution must be greater or equal than y resolution !';
        l.error.objectOutOfBound1='obstacle is';
        l.error.objectOutOfBound2='obstacles are';
        l.error.objectOutOfBound='out from the area...';
        l.wait='Please Wait...';
        l.finish='Finished';
end
end