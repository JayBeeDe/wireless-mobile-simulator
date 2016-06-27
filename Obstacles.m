classdef Obstacles
    properties
        x;%required
        y;%required
        type;%optional
        losses;%not required
        form;%optional
    end
    
    methods
        % Obstacles(xvect, yvect, <type>, <form>)
        % with xvect=[x1, x2, ..., xn] and yvect=[y1, y2, ..., yn]
        function obj = Obstacles(xvect, yvect, type, form)
            global Losses;
            if(nargin<4)
                if(nargin<3)
                    type='-';
                end
                form='-';
            end
            switch form
                case 'point'
                    obj.x = xvect(1);
                    obj.y = yvect(1);
                case 'doubleWall'
                    obj.x = [xvect fliplr(xvect)];
                    obj.y = [yvect fliplr(yvect)];
                case 'rectangleAlign'
                    obj.x = [xvect fliplr(xvect)];
                    obj.y = [yvect(1) yvect(1) yvect(2) yvect(2)];
                otherwise
                    form = 'polygon';
                    obj.x = xvect;
                    obj.y = yvect;
            end
            obj.form = form;
            switch type
                case 'beton'
                    obj.losses = 50;
                case 'wood'
                    obj.losses = 4;
                otherwise
                    obj.losses = Losses.l;
                    type = 'default';
            end
            obj.type = type;
        end
    end
end