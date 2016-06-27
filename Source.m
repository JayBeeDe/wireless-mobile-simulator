classdef Source  < handle
    properties
        x;%required by src.x
        y;%required by src.y
        type;%optional
        powerMax;%optional
        formula;%not required
        offset;%optional
        directivity;%optional
    end
    
    methods
        % Source(src, <type>, <powerMax>, <offset>, <directivity>)
        % with src =Coor(x, y)
        function obj = Source(src, type, powerMax, offset, directivity)
            global Ptrans;
            customtype = 'custom';
            if (nargin < 5)
                if (nargin < 4)
                    if (nargin < 3)
                        if (nargin < 2)
                            type=customtype;
                        end
                        powerMax = Ptrans.powerMax;
                    end
                    offset = Ptrans.offset;
                end
                directivity = Ptrans.directivity;
            end
            obj.modulow(offset);
            obj.directivity=directivity;
            obj.formula = Ptrans.formula;
            obj.x = src.x;
            obj.y = src.y;
            obj.type = type;
            obj.powerMax = powerMax;
            obj.setType(customtype);
        end
        
        function obj = setType(obj, customtype)
            switch obj.type
                case 'omnidirectional'
                    obj.directivity = 0;
                case 'yagi'
                    obj.directivity = 45;
                case 'directional'
                    obj.directivity = 10;
                otherwise %%custom
                    obj.type = customtype;
            end
        end
        
        function obj = modulow(obj, angle)
            nAngle = mod(angle, 360);
            if(mod(floor(angle/180), 2)~=0 && nAngle~=180)
                nAngle = nAngle-360;
            end
            obj.offset = nAngle;
        end
    end
end

