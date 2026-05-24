function [is_point_valid, ...
diff_view_factor_val, ...
n_dA1_normal_vec,n_dA2_normal_vec, ...
mag_root_12] = ...
diff_view_factor_8(dA1_mat,dA2_mat, ...
surf_1_center_vec, ...
movement_of_ray_relative_to_center_of_surface_1, ...
surf_2_center_vec, ...
movement_of_ray_relative_to_center_of_surface_2)
%
% Consider two opaque surfaces,1 and 2, that have a fully unobstructed
% view of one another. There are no shadowing elements between these
% surfaces. Also, there are no convolutions on either surface that shade
% parts of that same surface.
% Radiant energy is transferred from surface 1 to 2. A view factor, F_12,
% must then be constructed to describe the proportion of energy radiated
% from surface 1 that reaches surface 2. Computing this view factor will
% require summing up all the contributions of differential areas dA1 and
% dA2 on these two surfaces.
%
% The purpose of this function, then, is to calculate the contribution
% made by one pair of these areas to the overall view factor.
%
%
% Input terms:
%
% Each differential surface element is described by a matrix of four
% (x,y,z) triples, describing four immediately adjacent points on the
% surface.
%
% If we designate those points on each surface as being arranged in a
% counterclockwise manner...
%
% c------b
% |      |
% |      |
% d------a
%
% it follows that
%
% dA1_mat = [ (x1a, y1a, z1a)
% (x1b, y1b, z1b)
% (x1c, y1c, z1c)
% (x1d, y1d, z1d) ]
%
% and
%
% dA2_mat = [ (x2a, y2a, z2a)
% (x2b, y2b, z2b)
% (x2c, y2c, z2c)
% (x2d, y2d, z2d) ]
%
%
% surf_1_center_vec = the 3D location of the center of surface 1.
%
% movement_of_ray_relative_to_center_of_surface_1
%
% = one of three possible values...
%
% +1 iff rays are emitted out and away from
% the center of surface 1 (as in the case
% of rays streaming away from the outer
% surface of a hot sphere);
%
% -1 iff rays are moving into and toward the
% center of surface 1 (as in the case
% of rays streaming in toward the center
% of a hot spherical cavity);
%
% 0 iff the "sense" of the emitted
% radiation coming from surface 1 is
% deemed unimportant, by the user, to the
% geometry being considered (as in the
% case of an LED panel emitting light in
% all directions forward of its front
% face).
%
% surf_2_center_vec = the 3D location of the center of surface 2.
%
% movement_of_ray_relative_to_center_of_surface_2
%
% = one of three possible values...
%
% +1 iff incoming rays must move out and
% away from the center of surface 2 (as
% in the case of rays streaming toward
% the inner surface of an integrating sphere);
%
% -1 iff rays are moving into and toward the
% center of surface 2 (as in the case
% of rays streaming toward the center
% of a hemispherical insolation sensor);
%
% 0 iff the "sense" of the emitted
% radiation coming toward surface 2 is
% deemed unimportant, by the user, to the
% geometry being considered (as in the
% case of a flat solar cell receiving
% radiated energy from all directions in
% front of its receiving face).
% Usage:
%
% [is_point_valid,...
% diff_view_factor_val,...
% n_dA1_normal_vec,n_dA2_normal_vec,...
% mag_root_12] = ...
% diff_view_factor_8(dA1_mat,dA2_mat,...
% surf_1_center_vec,...
% movement_of_ray_relative_to_center_of_surface_1,...
% surf_2_center_vec,...
% movement_of_ray_relative_to_center_of_surface_2)

% PROGRAMMING NOTES
%
% This routine uses a third round of normal
% orientation checks is being implemented, to
% enforce correct orientation of the normals in cases where convex surfaces
% are being used. Finally, the "sanity check" step
% is being used, to assess whether or not a proposed combination of dA1
% and dA2 will yield physically realistic results, i.e. a ray propagating
% out of surface 1 as it goes toward surface 2.

% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
%
% Validation
%
% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

if movement_of_ray_relative_to_center_of_surface_1 ~= -1
if movement_of_ray_relative_to_center_of_surface_1 ~= 0
if movement_of_ray_relative_to_center_of_surface_1 ~= +1
disp( ' ')
error( 'The value for movement_of_ray_relative_to_center_of_surface_1 must be -1, 0 or +1.' )
else
end
else
end
else
end

if movement_of_ray_relative_to_center_of_surface_2 ~= -1
if movement_of_ray_relative_to_center_of_surface_2 ~= 0
if movement_of_ray_relative_to_center_of_surface_2 ~= +1
disp( ' ')
error( 'The value for movement_of_ray_relative_to_center_of_surface_2 must be -1, 0 or +1.' )
else
end
else
end
else
end

% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
% OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
%
% Generate Normals of Differential Areas
%
% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
% OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

% Calculate the surface normal to both of these surface elements. This is
% done in two steps:
% 1) Find the cross product of the two diagonals in each surface
% element.
% 2) Find the orientation of these two normals that makes them point
% both in opposite senses, and "toward" one another.

% dA1 Diagonal 1 is defined as the (a,c) vector of dA1.

dA1_diag_1_vec = [ (dA1_mat(3,1)-dA1_mat(1,1)), (dA1_mat(3,2)-dA1_mat(1,2)), (dA1_mat(3,3)- dA1_mat(1,3)) ] ;

% dA1 Diagonal 2 is defined as the (b,d) vector of dA1.

dA1_diag_2_vec = [ (dA1_mat(4,1)-dA1_mat(2,1)), (dA1_mat(4,2)-dA1_mat(2,2)), (dA1_mat(4,3)- dA1_mat(2,3)) ] ;

% Using these two vectors, construct the normal to area 1, n_1.

dA1_normal_vec = cross_product( dA1_diag_1_vec,dA1_diag_2_vec );

n_dA1_normal_vec = dA1_normal_vec / magnitude(dA1_normal_vec) ;

% dA2 Diagonal 1 is defined as the (a,c) vector of dA2.

dA2_diag_1_vec = [ (dA2_mat(3,1)-dA2_mat(1,1)), (dA2_mat(3,2)-dA2_mat(1,2)), (dA2_mat(3,3)- dA2_mat(1,3)) ] ;

% dA2 Diagonal 2 is defined as the (b,d) vector of dA2.

dA2_diag_2_vec = [ (dA2_mat(4,1)-dA2_mat(2,1)), (dA2_mat(4,2)-dA2_mat(2,2)), (dA2_mat(4,3)- dA2_mat(2,3)) ] ;

% Using these two vectors, construct the normal to area 2, n_2.

dA2_normal_vec = cross_product( dA2_diag_1_vec,dA2_diag_2_vec );

n_dA2_normal_vec = dA2_normal_vec / magnitude(dA2_normal_vec) ;

% OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
%
% Orientation of Normals
%
% OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN

% Step 2 is accomplished in the following manner:
% a) Construct the line r_12 that connects the roots of n_1 and n_2.
% Call the normalized vector that describes this line's direction
% n_12.
% b) Project n_1 and n_2 onto n_12.
% c) If the projection of n_1 has the same sign as the projection of
% n_2, reverse the orientation of n_2.
% d) Add n_12 to the projection of n_2. If the result is larger than
% n_12, leave the normals as they are. Otherwise, reverse the
% orientations of both normals.

% r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12
% Construct line r_12
% r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12r12

% Determine the coordinates of the "roots" of each surface.

dA1_root_vec = mean(dA1_mat,1) ;

dA2_root_vec = mean(dA2_mat,1) ;

% Calculate the line segment r_12 joining these elements.

root_12_vec = dA2_root_vec - dA1_root_vec ;

% Determine the magnitude of r_12.

mag_root_12 = magnitude(root_12_vec) ;

% Determine the direction of r_12.

n_root_12_vec = root_12_vec ./ mag_root_12 ;

% DNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNOD
% Determine Normals' Orientation
% DNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNODNOD

% Find the dot product of n_1 and n_2.

dp_of_n1_and_n2 = dot_product(n_dA1_normal_vec,n_dA2_normal_vec) ;

theta_dp_of_n1_and_n2 = acos( dp_of_n1_and_n2 /(magnitude(n_dA1_normal_vec)*magnitude (n_dA2_normal_vec)) ) ;

% If the resulting angle is greater than or equal to pi/2...

if theta_dp_of_n1_and_n2 >= pi/2
%disp('n_1 and n_2 are pointing the opposite way')
% ...keep the normals as they are.
% Otherwise...
else
%disp('n_1 and n_2 are pointing the same way')
% ...reverse the orientation of n_2.
n_dA2_normal_vec = -n_dA2_normal_vec ;
end

% At this point, it is guaranteed that n_1 and n_2 will both be
% antiparallel to one another. This means that they must either be:
% a) pointing toward one another (the correct orientation); or
% b) pointing away from one another (the incorrect orientation).

% Find the projection of n1 on r12.

n1_proj_on_r12 = dot_product(n_dA1_normal_vec,root_12_vec) ;

% Find the projection of n2 on r12.

n2_proj_on_r12 = dot_product(n_dA2_normal_vec,root_12_vec) ;

% Vectorize the two projections using the normalized r12, then adjust
% their magnitudes so that they are at most ||r12||/2.

n1_proj_on_r12_vec = n1_proj_on_r12 * n_root_12_vec ;

n2_proj_on_r12_vec = n2_proj_on_r12 * n_root_12_vec ;

rescaled_n1_proj_on_r12_vec = n1_proj_on_r12_vec * (1/magnitude(n1_proj_on_r12_vec)) * (mag_root_12/2) ;

rescaled_n2_proj_on_r12_vec = n2_proj_on_r12_vec * (1/magnitude(n2_proj_on_r12_vec)) * (mag_root_12/2) ;

% Flip the first vector, then add these two vectors to r12.

sum_of_three_vec = -rescaled_n1_proj_on_r12_vec + root_12_vec + rescaled_n2_proj_on_r12_vec ;

% If the resulting vector is longer than r_12...
if magnitude(sum_of_three_vec) > mag_root_12
% ...it follows that n_1 and n_2 are pointing away from each other.
% Reverse the orientation of both normals.
n_dA1_normal_vec = -n_dA1_normal_vec ;
n_dA2_normal_vec = -n_dA2_normal_vec ;
% Otherwise....
else
% ...leave the normals as they are.
end

% This series of steps is guaranteed to provide the correct orientation of
% normals for surfaces that are at angles less than pi/2 to one another.
% "Open-book cases," where the surfaces are at greater angles than this,
% will need to have a second round of adjustments performed in the next
% step.

%n_dA1_normal_vec = n_dA1_normal_vec

%n_dA2_normal_vec = n_dA2_normal_vec

% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
%
% Calculation of Differential View Factor
%
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

% Find the angles between the surface normals and n_12.

beta_1 = acos(dot_product(n_dA1_normal_vec,n_root_12_vec)) ;

%cos_beta_1 = cos(beta_1)

% CNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNO
% --Confirm Normals' Orientation--
% CNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNOCNO

% As was noted above, the above normals-orientation scheme can yield
% incorrect (beta > pi/2) results in the open-book normals case. Reversing
% the orientation of associated normals will fix this problem, in cases
% where it does arise. It will do so, furthermore, without interfering with
% the "canonical" cases of normals sprouting from directly-opposing
% surfaces.

if beta_1 > pi/2
%beta_1 = beta_1
%disp(' ')
%disp('revise beta 1')
n_dA1_normal_vec = -n_dA1_normal_vec ;
%n_root_12_vec = n_root_12_vec
beta_1 = acos(dot_product(n_dA1_normal_vec,n_root_12_vec)) ;
else
end

%size(beta_1)

beta_2 = acos(dot_product(-n_root_12_vec,n_dA2_normal_vec)) ;

%cos_beta_2 = cos(beta_2)

if beta_2 > pi/2
%beta_2 = beta_2
%disp(' ')
%disp('revise beta 2')
%negative_n_root_12_vec = -n_root_12_vec
%beta_2 = acos(dot_product(-n_root_12_vec,n_dA2_normal_vec))
beta_2 = pi - beta_2 ;
n_dA2_normal_vec = -n_dA2_normal_vec;
else
end

% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%
% Concave Surfaces Check
%
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

% A third level of normal orientation checks has to be performed in cases
% where concave surfaces are involved (e.g. capped frustums, cylinders
% sleeved around internal radiating surfaces). In such cases, the user
% needs to explicitly specify whether a surface is radiating away from its
% center, or toward its center. If this step is not performed, bogus
% results, such as rays originating from both the outer and inner aspects
% of a surface, can occur.

% If the user has specified that the radiating direction is important for
% surface 1....

is_point_valid = 1 ;

if abs(movement_of_ray_relative_to_center_of_surface_1) > 0
...check that the corresponding conditions are satisfied.

dist_from_surf_1_center_to_dA1_center = sqrt( ((dA1_root_vec(1,1)- surf_1_center_vec(1,1)) ^2) + ((dA1_root_vec(1,2)-surf_1_center_vec(1,2))^2) + ((dA1_root_vec(1,3)- surf_1_center_vec (1,3))^2) ) ;

s1_to_n1_delta_x = (0.1*dist_from_surf_1_center_to_dA1_center.*n_dA1_normal_vec(1,1)) + dA1_root_vec(1,1) - surf_1_center_vec(1,1) ;

s1_to_n1_delta_y = (0.1*dist_from_surf_1_center_to_dA1_center.*n_dA1_normal_vec(1,2)) + dA1_root_vec(1,2) - surf_1_center_vec(1,2) ;

s1_to_n1_delta_z = (0.1*dist_from_surf_1_center_to_dA1_center.*n_dA1_normal_vec(1,3)) + dA1_root_vec(1,3) - surf_1_center_vec(1,3) ;

dist_from_surf_1_center_to_n1 = sqrt( (s1_to_n1_delta_x^2) + (s1_to_n1_delta_y^2) + (s1_to_n1_delta_z^2) ) ;

% If the user has specified that rays must be moving away from
% the center of surface 1...

if movement_of_ray_relative_to_center_of_surface_1 > 0
% ...confirm that the normal at dA1 is oriented outward from the
% center of surface 1.

% If n1 is not oriented outward...

if dist_from_surf_1_center_to_n1 < dist_from_surf_1_center_to_dA1_center
% ...this specific combination of dA1 and dA2 yields bogus results, and
% there is no point in calculating the differential view factor.

%disp(' ')
%disp('point pair rejected at n1 outward check')
is_point_valid = 0 ;

else

% If the user has specified that the radiating direction is important for
% surface 2....

if abs(movement_of_ray_relative_to_center_of_surface_2) > 0

% If the user has specified that rays must be moving away from
% the center of surface 2...

dist_from_surf_2_center_to_dA2_center = sqrt( ((dA2_root_vec(1,1)- surf_2_center_vec(1,1))^2) + ((dA2_root_vec(1,2)-surf_2_center_vec(1,2))^2) + ((dA2_root_vec(1,3) -surf_2_center_vec(1,3))^2) ) ;

%dist_from_surf_2_center_to_dA2_center = dist_from_surf_2_center_to_dA2_center

%n_dA2_normal_vec = n_dA2_normal_vec

%dA2_root_vec = dA2_root_vec

%surf_2_center_vec = surf_2_center_vec

s2_to_n2_delta_x = (0.1*dist_from_surf_2_center_to_dA2_center.*n_dA2_normal_vec (1,1)) + dA2_root_vec(1,1) - surf_2_center_vec(1,1) ;

s2_to_n2_delta_y = (0.1*dist_from_surf_2_center_to_dA2_center.*n_dA2_normal_vec (1,2)) + dA2_root_vec(1,2) - surf_2_center_vec(1,2) ;

s2_to_n2_delta_z = (0.1*dist_from_surf_2_center_to_dA2_center.*n_dA2_normal_vec (1,3)) + dA2_root_vec(1,3) - surf_2_center_vec(1,3) ;

dist_from_surf_2_center_to_n2 = sqrt( (s2_to_n2_delta_x^2) + (s2_to_n2_delta_y^2) + (s2_to_n2_delta_z^2) ) ;

if movement_of_ray_relative_to_center_of_surface_2 > 0
% ...confirm that the normal at dA2 is oriented inward, toward the
% center of surface 2.

% If n2 is not oriented inward...

if dist_from_surf_2_center_to_n2 > dist_from_surf_2_center_to_dA2_center
% ...this specific combination of dA1 and dA2 yields bogus results, and
% there is no point in calculating the differential view factor.

%disp(' ')
%disp('point pair rejected at n2 inward check')

is_point_valid = 0 ;

else
end

% Otherwise, if the user has specified that rays must be moving
% toward the center of surface 2...
else
% ...confirm that the normal at dA2 is oriented outward, toward
% these incoming rays.

% If n2 is not oriented outward...

if dist_from_surf_2_center_to_n2 < dist_from_surf_2_center_to_dA2_center
% ...this specific combination of dA1 and dA2 yields bogus results, and
% there is no point in calculating the differential view factor.

%disp(' ')
%disp('point pair rejected at n2 outward check')

is_point_valid = 0 ;

else
end

end

else
end

end

% Otherwise, if the user has specified that rays must be moving toward
% the center of surface 1...

else
% ...confirm that the normal at dA1 is oriented inward, toward the
% center of surface 1.

% If n1 is not oriented inward...

if dist_from_surf_1_center_to_n1 > dist_from_surf_1_center_to_dA1_center
% ...this specific combination of dA1 and dA2 yields bogus results, and
% there is no point in calculating the differential view factor.

%disp(' ')
%disp('point pair rejected at n1 inward check')

is_point_valid = 0 ;

else

% If the user has specified that the radiating direction is important for
% surface 2....

if abs(movement_of_ray_relative_to_center_of_surface_2) > 0

% If the user has specified that rays must be moving away from
% the center of surface 2...


dist_from_surf_2_center_to_dA2_center = sqrt( ((dA2_root_vec(1,1)- surf_2_center_vec(1,1))^2) + ((dA2_root_vec(1,2)-surf_2_center_vec(1,2))^2) + ((dA2_root_vec(1,3) -surf_2_center_vec(1,3))^2) ) ;

%dist_from_surf_2_center_to_dA2_center = dist_from_surf_2_center_to_dA2_center

%n_dA2_normal_vec = n_dA2_normal_vec

%dA2_root_vec = dA2_root_vec

%surf_2_center_vec = surf_2_center_vec

s2_to_n2_delta_x = (0.1*dist_from_surf_2_center_to_dA2_center.*n_dA2_normal_vec (1,1)) + dA2_root_vec(1,1) - surf_2_center_vec(1,1) ;

s2_to_n2_delta_y = (0.1*dist_from_surf_2_center_to_dA2_center.*n_dA2_normal_vec (1,2)) + dA2_root_vec(1,2) - surf_2_center_vec(1,2) ;

s2_to_n2_delta_z = (0.1*dist_from_surf_2_center_to_dA2_center.*n_dA2_normal_vec (1,3)) + dA2_root_vec(1,3) - surf_2_center_vec(1,3) ;

dist_from_surf_2_center_to_n2 = sqrt( (s2_to_n2_delta_x^2) + (s2_to_n2_delta_y^2) + (s2_to_n2_delta_z^2) ) ;

if movement_of_ray_relative_to_center_of_surface_2 > 0
% ...confirm that the normal at dA2 is oriented inward, toward the
% center of surface 2.

% If n2 is not oriented inward...

if dist_from_surf_2_center_to_n2 > dist_from_surf_2_center_to_dA2_center
% ...this specific combination of dA1 and dA2 yields bogus results, and
% there is no point in calculating the differential view factor.
is_point_valid = 0 ;

else
end

% Otherwise, if the user has specified that rays must be moving
% toward the center of surface 2...
else
% ...confirm that the normal at dA2 is oriented outward, toward
% these incoming rays.

% If n2 is not oriented outward...

if dist_from_surf_2_center_to_n2 < dist_from_surf_2_center_to_dA2_center
% ...this specific combination of dA1 and dA2 yields bogus results, and
% there is no point in calculating the differential view factor.
is_point_valid = 0 ;

else
end

end

else
end

end

end

else
end

% SCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSC
% Sanity Check
% SCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSCSC
%
% Check the orientation of the r12 direction vector, relative to the normal
% at dA1. If the angle between these two vectors is greater than pi/2, this
% corresponds to a situation where the ray is going backwards into surface
% 1, which is unphysical.

dot_prod_n_r12_and_n1 = dot_product(n_root_12_vec,n_dA1_normal_vec) ;

if is_point_valid==0

diff_view_factor_val = [] ;

n_dA1_normal_vec = [] ;

n_dA2_normal_vec = [] ;

mag_root_12 = [] ;

else

if acos(dot_prod_n_r12_and_n1) >= pi/2
%...this specific combination of dA1 and dA2 yields bogus results, and
% there is no point in calculating the differential view factor.

is_point_valid = 0 ;

diff_view_factor_val = [] ;

n_dA1_normal_vec = [] ;

n_dA2_normal_vec = [] ;

mag_root_12 = [] ;

else

% This specific combination of dA1 and dA2 will yield legitimate
% results, and the calculation of the differential view factor should
% proceed.

is_point_valid = 1 ;

% Compute the value of the differential view factor for these
% two differential areas.

if beta_1 > pi/2
beta_1 = beta_1
else
end

if beta_2 > pi/2
beta_2 = beta_2
else
end

diff_view_factor_val = (cos(beta_1)*cos(beta_2)) / (pi * (mag_root_12^2)) ;

end

end

end
