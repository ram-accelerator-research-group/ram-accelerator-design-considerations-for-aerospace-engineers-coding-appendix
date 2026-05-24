function [does_line_intersect_plane, ...
does_line_coincide_with_plane, ...
intersection_point_vec, ...
line_intersects_triangle] = ...
line_intersects_plane(line_mat,plane_mat)
%
% Consider a line specified by two points, and a plane specified by 3
% points. Given this information, determine how and where the line
% intersects the plane.
%
% Input terms:
%
% line_mat = a 2-row by 3-column vector, where each row represents one
% of the two points that define the line in 3D Cartesian
% coordinates, and gives them in (x,y,z) format.
%
%
% plane_mat = a 3-row by 3-column vector, where each row represents one
% of the three points that define the plane in 3D Cartesian
% coordinates, and gives them in (x,y,z) format.
%
% Usage:
%
% [does_line_intersect_plane,...
% does_line_coincide_with_plane,...
% intersection_point_vec,...
% line_intersects_triangle] =...
% line_intersects_plane(line_mat,plane_mat);

% Find the normal to the surface of the plane.

plane_21_vec = diff(flipud(plane_mat(1:2,:)),1,1) ;

plane_23_vec = diff(plane_mat(2:3,:),1,1) ;

cross_21_to_23_vec = cross_product(plane_21_vec,plane_23_vec) ;

norm_21_to_23_vec = cross_21_to_23_vec / magnitude(cross_21_to_23_vec) ;

% Find the angle between the normal and the line.

line_dir_vec = diff(line_mat,1,1) ;

norm_line_dir_vec = line_dir_vec / magnitude(line_dir_vec) ;

theta_from_normal_to_line_dir = acos(dot_product(norm_21_to_23_vec,norm_line_dir_vec)) ;

tol = 1e-14 ;

% If this angle is pi/2....
%if theta_from_normal_to_line_dir == pi/2
if abs( theta_from_normal_to_line_dir - (pi/2) ) < tol
% ...the line is parallel to the plane, and must either lie entirely within
% the plane, or intersect it nowhere.

% disp(' ')
% disp('The line is parallel to the plane.')
% disp('Now determining if the line is coincident with the plane....')

% Find the vector difference between one point in the plane, and one
% point on the line.

p0_minus_l0_vec = plane_mat(1,:) - line_mat(1,:) ;

% Find the dot product of this vector and the normal vector.

dot_of_diff_and_normal = dot_product(p0_minus_l0_vec,norm_21_to_23_vec) ;

%if abs(dot_of_diff_and_normal) <= 1e-10
if dot_of_diff_and_normal == 0
%disp(' ')
%disp('The line is completely within the plane.')

does_line_intersect_plane = 1 ;
does_line_coincide_with_plane = 1 ;
intersection_point_vec = [] ;
line_intersects_triangle = 1 ;

else
% disp(' ')
% disp('The line is completely outside the plane.')

does_line_intersect_plane = 0 ;
does_line_coincide_with_plane = 0 ;
intersection_point_vec = [] ;
line_intersects_triangle = 0 ;

end

% Otherwise...
else

% ...the line must intersect the plane at exactly one point. The problem
% then becomes one of determining if the line intersects the plane...
%
% a) within the triangle specified by the three points given;
%
% or
%
% b) outside the triangle specified by those points.

%disp(' ')
%disp('The line intersects the plane at exactly one point.')
%disp('Now checking if that point lies within the triangle defining the plane....')

does_line_intersect_plane = 1 ;
does_line_coincide_with_plane = 0 ;

line_T_mat = line_mat.';

plane_T_mat = plane_mat.';

t_num_pre_mat = horzcat(plane_T_mat,line_T_mat(:,1)) ;

t_num_mat = vertcat(ones(1,4),t_num_pre_mat) ;

t_den_pre_mat = horzcat(plane_T_mat,diff(line_T_mat,1,2));

t_den_mat = vertcat([1,1,1,0],t_den_pre_mat);

t = -det(t_num_mat)/det(t_den_mat) ;

x_intersect = line_mat(1,1) + ( (line_mat(2,1)-line_mat(1,1)) * t ) ;
y_intersect = line_mat(1,2) + ( (line_mat(2,2)-line_mat(1,2)) * t ) ;
z_intersect = line_mat(1,3) + ( (line_mat(2,3)-line_mat(1,3)) * t ) ;

%line_mat = line_mat

%plane_mat = plane_mat

intersection_point_vec = [x_intersect,y_intersect,z_intersect] ;

triangle_x_range_vec = [min(plane_mat(:,1)),max(plane_mat(:,1))] ;

triangle_y_range_vec = [min(plane_mat(:,2)),max(plane_mat(:,2))] ;

triangle_z_range_vec = [min(plane_mat(:,3)),max(plane_mat(:,3))] ;

x_intersect_in_triangle_x_range = and( x_intersect >= triangle_x_range_vec(1,1), x_intersect <= triangle_x_range_vec(1,2) ) ;

y_intersect_in_triangle_y_range = and( y_intersect >= triangle_y_range_vec(1,1), y_intersect <= triangle_y_range_vec(1,2) ) ;

z_intersect_in_triangle_z_range = and( z_intersect >= triangle_z_range_vec(1,1), z_intersect <= triangle_z_range_vec(1,2) ) ;

line_intersects_triangle = all([x_intersect_in_triangle_x_range, y_intersect_in_triangle_y_range,z_intersect_in_triangle_z_range]) ;

end

end
