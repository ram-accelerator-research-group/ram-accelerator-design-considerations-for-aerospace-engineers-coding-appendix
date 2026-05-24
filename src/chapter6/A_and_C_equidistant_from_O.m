function [f_eq] = A_and_C_equidistant_from_O(l_minor,l_major)
%
% Consider a right triangle, with its major leg coincident with the x
% axis, its minor leg displaced in the +x direction, and its most-acute
% angle at the origin.
%
% Next, suppose that there are two "complementary" points A and C on
% this right triangle. Point A is constrained to lie on the major leg,
% and point C is constrained to lie on the hypotenuse. Both of these
% points, furthermore, are displaced by some common factor along the
% major leg and hypotenuse, albeit in opposite directions.
%
% Example:
% If point A is 10% of the way from the origin to the major leg's
% "x-most" vertex,
% it follows that
% point C is 10% of the way from the hypotenuse's "x-most" vertex to the
% origin.
%
% Now, consider a factor that places both point A and C at identical
% distances from the origin. What is this factor?
% This routine is meant to answer this question.
%
% Usage:
% [f_eq] = A_and_C_equidistant_from_O(l_minor,l_major)

l_hypotenuse = sqrt((l_minor^2)+(l_major^2)) ;

major_hyp_ratio = l_major / l_hypotenuse ;

f_eq = 1 / ( major_hyp_ratio + 1 ) ;

end
