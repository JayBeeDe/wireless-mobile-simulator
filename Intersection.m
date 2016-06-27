%% ================================== INFOS ===============================%%
%Functions in this file only used if global Losses.enablePolyxPoly set to false

%% =============================== FUNCTIONS =============================%%

function ret = Intersection(x, y, oi, A)
global obs; global source; global Losses; ret = 0;
    for op=1:(size(obs(oi).x, 2)-1)  %Browse each segment of obstacle manually
        s1 = Coor(Coor(x, y), Coor(source.x, source.y), 'S');
        s2 = Coor(Coor(obs(oi).x(op), obs(oi).y(op)), Coor(obs(oi).x(op+1), obs(oi).y(op+1)), 'S');
        inter = checkSegmentsIntersect(s1, s2);
        LI = 1;
        if (inter >=1)
            pp = getProjected(s2);
            B = 90-abs(abs(Others.getAngle(pp.y, pp.x)) - abs(A));  %angle B in degree without offset (useless)
            LI = Losses.incidenceFormula(degtorad(B)); %0..1
            ret = ret+(inter*LI);
        end
    end
end

function ret = checkSegmentsIntersect(s1, s2)
ret = false;
if(checkBoundingIntersect(s1, s2))
    if(checkLineLineSegmentIntersect(s1, s2))
        if(checkLineLineSegmentIntersect(s2,s1))
            ret = true;
        end
    end
end
end

function ret = checkBoundingIntersect(s1, s2)
ret = false;
b1 = getBox(s1);
b2 = getBox(s2);
if(b1.min.x<=b2.max.x && b1.max.x>=b2.min.x) && (b1.min.y<=b2.max.y && b1.max.y>=b2.min.y)
    ret = true;
end
end

function s = getBox(s)
    s.min = Coor(min(s.first.x, s.second.x), min(s.first.y, s.second.y));
    s.max = Coor(max(s.first.x, s.second.x), max(s.first.y, s.second.y));
end

function ret = checkLineLineSegmentIntersect(l1, l2)
ret = false;
if(checkPointOnLine(l1,l2.first) || checkPointOnLine(l1,l2.second) || xor(checkPointRightOnLine(l1, l2.first), checkPointRightOnLine(l1, l2.second)))
    ret = true;
end
end

function ret = checkPointOnLine(l,p)
global Losses;
ret = false;
segmentTmp = Coor(Coor(0,0), Coor(l.second.x - l.first.x, l.second.y - l.first.y), 'S');
pointTmp = Coor(p.x - l.first.x, p.y - l.first.y);
r = crossProd(segmentTmp.second, pointTmp);
if(abs(r) < Losses.epsilon)
    ret = true;
end
end

function ret = checkPointRightOnLine(l, p)
ret = false;
segmentTmp = Coor(Coor(0,0), Coor(l.second.x - l.first.x, l.second.y - l.first.y), 'S');
pointTmp = Coor(p.x - l.first.x, p.y - l.first.y);
if (crossProd(segmentTmp.second, pointTmp)<0)
    ret = true;
end
end

function ret = crossProd(a, b)
ret = a.x*b.y-b.x*a.y;
end

function ret = getProjected(s)
global source; p = Coor(source.x, source.y);
if (s.second.x ~= s.first.x)    %not vertical obstacle
    a = (s.second.y-s.first.y)/(s.second.x-s.first.x);  %ok because not vertical case
    b = s.second.y-a*s.second.x;
    no.x = s.second.y-s.first.y;
    no.y = s.second.x-s.first.x;
    no.y = -no.y;
    n.x = no.x/gcd(no.x, no.y);
    n.y = no.y/gcd(no.x, no.y);
    k = (a*p.x+b-p.y)/(n.y-a*n.x);  %quotient nul impossible because vector's coef is never its normal vector's coef !
    ret.x = k*n.x+p.x;
    ret.y = k*n.y+p.y;
else    %vertical obstacle
    ret.x = s.second.x;
    ret.y = p.x;
end
end