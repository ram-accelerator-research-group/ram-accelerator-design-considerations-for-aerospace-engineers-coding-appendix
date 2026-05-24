function [area] = Bretschneider(quadrilateral_mat)
%
% Input terms:
%
% Each area matrix has four (x,y,z) triples, describing four immediately
% adjacent points on a 3-dimesional surface in Cartesian coordinates.
%
% If we designate those points on each surface as being arranged in a
% counterclockwise manner...
%
%      b
% C-------B
% |        |
% c|       | a
% |        |
% D-------A
%      d
%
% it follows that
%
% quadrilateral_mat = [ (x1A, y1A, z1A)
% (x1B, y1B, z1B)
% (x1C, y1C, z1C)
% (x1D, y1D, z1D) ]

magnitude_a = magnitude(quadrilateral_mat(2,:)-quadrilateral_mat(1,:)) ;

magnitude_b = magnitude(quadrilateral_mat(3,:)-quadrilateral_mat(2,:)) ;

magnitude_c = magnitude(quadrilateral_mat(4,:)-quadrilateral_mat(3,:)) ;

magnitude_d = magnitude(quadrilateral_mat(1,:)-quadrilateral_mat(4,:)) ;

magnitude_e = magnitude(quadrilateral_mat(3,:)-quadrilateral_mat(1,:)) ;

magnitude_f = magnitude(quadrilateral_mat(4,:)-quadrilateral_mat(2,:)) ;

perimeter = magnitude_a + magnitude_b + magnitude_c + magnitude_d ;

semiperimeter = perimeter / 2 ;

first_radical_term = ( semiperimeter - magnitude_a ) * ( semiperimeter - magnitude_b ) * ( semiperimeter - magnitude_c ) * ( semiperimeter - magnitude_d ) ;

second_radical_term = -0.25 * ( (magnitude_a*magnitude_c) + (magnitude_b*magnitude_d) + (magnitude_e*magnitude_f) ) * ( (magnitude_a*magnitude_c) + (magnitude_b*magnitude_d) - (magnitude_e*magnitude_f) ) ;

area = sqrt( first_radical_term + second_radical_term ) ;

end
