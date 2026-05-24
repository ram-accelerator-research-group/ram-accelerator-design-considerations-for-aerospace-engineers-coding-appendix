function [intersection_mat, ...
ray_obstructed] = ...
double_check_if_ray_obstructed(dA1_center_vec,dA2_center_vec, ...
surf_1_x_mat,surf_1_y_mat,surf_1_z_mat, ...
surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, ...
obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat)
%
% Usage
%
% [intersection_mat,...
% ray_obstructed] =...
% double_check_if_ray_obstructed(dA1_center_vec,dA2_center_vec,...
% surf_1_x_mat,surf_1_y_mat,surf_1_z_mat,...
% surf_2_x_mat,surf_2_y_mat,surf_2_z_mat,...
% obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat)
%
% PROGRAMMING NOTES
%
% This routine makes use of the following non-MATLAB subroutines:
%
% is_ray_obstructed_by_surface_4

% Do an initial check on whether or not a specified ray is obstructed, when
% it moves between two surfaces that have an interspersed obstructing
% object.

[initial_intersection_mat, ...
initial_ray_obstructed] = ...
is_ray_obstructed_by_surface_4(dA1_center_vec,dA2_center_vec, ...
surf_1_x_mat,surf_1_y_mat,surf_1_z_mat, ...
surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, ...
obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat) ;

% Rotate the ray through an angle of pi/4 in the xy-plane of the current
% Cartesian coordinate system, while leaving everything else in the same
% positions as before.

theta_pivot = pi/4 ;

rotation_mat = [cos(theta_pivot), -sin(theta_pivot), 0; ...
sin(theta_pivot), cos(theta_pivot), 0; ...
0, 0, 1 ] ;

final_dA1_center_vec = rotation_mat * dA1_center_vec' ;

final_dA1_center_vec = final_dA1_center_vec' ;

final_dA2_center_vec = rotation_mat * dA2_center_vec' ;

final_dA2_center_vec = final_dA2_center_vec' ;

% Do an second check on whether or not this new, "final ray" is obstructed,
% when it moves between the same two surfaces that have the same
% interspersed obstructing object.

[final_intersection_mat, ...
final_ray_obstructed] = ...
is_ray_obstructed_by_surface_4(final_dA1_center_vec,final_dA2_center_vec, ...
surf_1_x_mat,surf_1_y_mat,surf_1_z_mat, ...
surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, ...
obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat) ;

un_rotation_mat = [ cos(-theta_pivot), -sin(-theta_pivot), 0; ...
sin(-theta_pivot), cos(-theta_pivot), 0; ...
0, 0, 1 ] ;

% Compare the results from these two runs.

%size_initial_intersection_mat = size(initial_intersection_mat)

% If the "initial ray" is obstructed...
if initial_ray_obstructed == 1
% ...check on the status of the "final ray."

% If both the initial and final ray are obstructed...
if and(initial_ray_obstructed==1,final_ray_obstructed==1)
% ...it follows that the ray is categorically obstructed, and
% should thus be reported as an obstructed ray.

% Compare the intersection points: keep the one that is closest to
% the emitting surface (i.e. surface 1).

initial_dist = sqrt(sum((initial_intersection_mat-dA1_center_vec).^2)) ;

final_dist = sqrt(sum((final_intersection_mat-final_dA1_center_vec).^2)) ;


if initial_dist < final_dist
intersection_mat = initial_intersection_mat ;
else
intersection_mat = un_rotation_mat*final_intersection_mat' ;

intersection_mat = intersection_mat' ;

end

%intersection_mat = initial_intersection_mat ;

ray_obstructed = 1 ;

% Otherwise...
else
% ...if the initial ray is obstructed, but the final ray is NOT
% obstructed, it follows that the original assignment was correct,
% and the ray should be reported as an obstructed ray.

intersection_mat = initial_intersection_mat ;

ray_obstructed = 1 ;

end

% Otherwise, if the "initial ray" is NOT obstructed...
else
% ...check on the status of the "final ray."


% If both the initial and final ray are NOT obstructed...
if and(initial_ray_obstructed==0,final_ray_obstructed==0)
% ...it follows that the ray is categorically NOT obstructed, and
% should thus be reported as a NOT-obstructed ray.

intersection_mat = initial_intersection_mat ;

ray_obstructed = 0 ;

% Otherwise...
else
% ...if the initial ray is NOT obstructed, but the final ray is
% obstructed, it follows that the final assignment was correct,
% and the ray should be reported as an obstructed ray.

intersection_mat = un_rotation_mat*final_intersection_mat' ;

intersection_mat = intersection_mat' ;

ray_obstructed = 1 ;

end

end

end
