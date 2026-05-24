function [ a_cross_b_vec ] = cross_product( a_vec,b_vec )
%
% Usage:
%
% [ a_cross_b_vec ] = cross_product( a_vec,b_vec )
% The purpose of this function is to take the cross product of two
% vectors in Cartesian coordinates.

a_cross_b_delta_x = ( a_vec(1,2) * b_vec(1,3) ) - ( a_vec(1,3) * b_vec(1,2) ) ;

a_cross_b_delta_y = ( a_vec(1,3) * b_vec(1,1) ) - ( a_vec(1,1) * b_vec(1,3) ) ;

a_cross_b_delta_z = ( a_vec(1,1) * b_vec(1,2) ) - ( a_vec(1,2) * b_vec(1,1) ) ;

a_cross_b_vec = [a_cross_b_delta_x,a_cross_b_delta_y,a_cross_b_delta_z];

end
