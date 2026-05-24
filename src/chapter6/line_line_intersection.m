function [x,y] = line_line_intersection(x1,y1,x2,y2,x3,y3,x4,y4)
%
% This function implements the line-line intersection equations given in
% Weisstein, Eric W. "Line-Line Intersection."
% From MathWorld--A Wolfram Web Resource.
% https://mathworld.wolfram.com/Line-LineIntersection.html
%
% More specifically, this function deals with two coplanar lines I and
% II. It takes, as input, the coordinates of two points
% 1 and 2 that lie on line I, and two points 3 and 4 that lie on line
% II. It then returns the (x,y) coordinates of the point where lines I
% and II cross one another.
%
% Usage:
%
% [x,y] = line_line_intersection(x1,y1,x2,y2,x3,y3,x4,y4)

x = det([det([x1 y1;x2 y2]), (x1-x2);det([x3 y3;x4 y4]), (x3-x4) ])./det([(x1- x2),(y1-y2) ; (x3-x4),(y3-y4)]);
y = det([det([x1 y1;x2 y2]), (y1-y2);det([x3 y3;x4 y4]), (y3-y4) ])./det([(x1- x2),(y1-y2) ; (x3-x4),(y3-y4)]);

end
