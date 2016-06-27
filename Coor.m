classdef Coor
    properties
        x;%Case #1 : required // Case #2 : not required
        y;%Case #1 : required // Case #2 : not required
        first;%Case #1 : not required // Case #2 : required
        second;%Case #1 : not required // Case #2 : required
        type;%Case #1 : optional, %Case #2 : 'S' required
        min;%not required
        max;%not required
    end
    
    methods
        % Option #1 : Coor(x, y, <type>)
        % Option #2 : Coor(s1, s2, type)
        % for Option #2 with s1 = Coor(x1, y1, <type>) and s2 = Coor(x2, y2, <type>) and type = 'C'
        function obj = Coor(c1, c2, type)
            if (nargin <3)
                type = '-';
            end
            if (type==1 || type=='S' || type=='s' || strcmp(type, 'segment') || strcmp(type, 'Segment'))
                obj.first = Coor(c1.x, c1.y);
                obj.second = Coor(c2.x, c2.y);
            else
                obj.x = c1;
                obj.y = c2;
            end
        end
    end
end