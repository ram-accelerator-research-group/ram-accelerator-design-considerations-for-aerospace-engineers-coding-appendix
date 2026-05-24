function [dF12_vec, ...
is_ray_obstructed_3mat,obstruction_point_3mat, ...
dA1_center_3mat,dA2_center_3mat, ...
n_dA1_normal_3mat,n_dA2_normal_3mat, ...
mag_root_12_valid_3mat, ...
Sobol_select_itr,point_pair_itr,valid_point_pairs_num] = ...
probabilistic_n_point_pairs_select_w_obstruction_3(n_point_pairs, ...
aug_Sobol_mat, ...
surf_1_x_mat,surf_1_y_mat,surf_1_z_mat, ...
surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, ...
movement_of_ray_relative_to_center_of_surface_1, ...
movement_of_ray_relative_to_center_of_surface_2, ...
surf_1_center_vec,surf_2_center_vec, ...
obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat, ...
simulation_itr, ...
Sobol_matrix_row_num, ...
Sobol_select_itr,point_pair_itr,valid_point_pairs_num, ...
dF12_vec, ...
is_ray_obstructed_3mat,obstruction_point_3mat, ...
dA1_center_3mat,dA2_center_3mat, ...
n_dA1_normal_3mat,n_dA2_normal_3mat)
%
% The purpose of this function is to select a requested number of point
% pairs for a Monte Carlo view factor calculation routine, by using
% probabilistic codes. These probabilistic codes are based on two things:
%
% 1) The augmented Sobol matrix. This matrix consists of rows that
% contain both the 4-dimensional Sobol set vectors, and the probability
% that each row will be selected. These probabilities are chosen on the
% basis of how close these point pairs are, in the current Monte Carlo
% view factor problem, to other point pairs that are physically valid or
% physically invalid.
%
% 2) The libraries of r12 values. Reasonable F12 values (i.e. F12 <=1 )
% are associated with point-pair sets that give one distinct distribution
% of r12 values. Bogus F12 values (i.e. F12 > 1), in turn, are associated
% with point-pair sets that give a second, different distribution of r12
% values. New choices of points, then, can be accepted or rejected on the
% basis of how these "library" r12 distributions compare to one another.
%
% Input terms:
%
% n_point_pairs = the number of pairs of points that are to be
% chosen on surface 1 and surface 2, within each
% Monte Carlo run;
%
% aug_Sobol_mat = a matrix where each row is a vector that
% represents a point in the 4-dimensional Sobol
% set, along with a 5th point that specifies the
% probability of that point being selected by
% this routine;
%
% surf_1_x_mat = ; surf_1_y_mat = ; surf_1_z_mat = ;
%
% where these are meshgrids representing surface 1 in Cartesian
% coordinates.
%
% surf_2_x_mat = ; surf_2_y_mat = ; surf_2_z_mat = ;
%
% where these are meshgrids representing surface 2 in Cartesian
% coordinates.
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
%
%
% Usage:
%
% [dF12_vec,...
% is_ray_obstructed_3mat,obstruction_point_3mat,...
% dA1_center_3mat,dA2_center_3mat,...
% n_dA1_normal_3mat,n_dA2_normal_3mat,...
% mag_root_12_valid_3mat,...
% Sobol_select_itr,point_pair_itr,valid_point_pairs_num] =...
% probabilistic_n_point_pairs_select_w_obstruction_3(n_point_pairs,...
% aug_Sobol_mat,...
% surf_1_x_mat,surf_1_y_mat,surf_1_z_mat,...
% surf_2_x_mat,surf_2_y_mat,surf_2_z_mat,...
% movement_of_ray_relative_to_center_of_surface_1,...
% movement_of_ray_relative_to_center_of_surface_2,...
% surf_1_center_vec,surf_2_center_vec,...
% Sobol_matrix_row_num,...
% Sobol_select_itr,point_pair_itr,valid_point_pairs_num,...
% dF12_vec,...
% is_ray_obstructed_3mat,obstruction_point_3mat,...
% dA1_center_3mat,dA2_center_3mat,...
% n_dA1_normal_3mat,n_dA2_normal_3mat)

% PROGRAMMING NOTES
%
% This routine makes direct use of the following non-MATLAB subroutines:
%
% quadrilateral_pairs_select
% diff_view_factor_8
% Sobol_learning_system_3
% is_ray_obstructed_by_surface_4

% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
%
% Initialization
%
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

% Determine the size of the surface 1 x matrix.

[rows_surf_1_x_mat_num,cols_surf_1_x_mat_num] = size(surf_1_x_mat) ;

% Determine the size of the surface 2 x matrix.

[rows_surf_2_x_mat_num,cols_surf_2_x_mat_num] = size(surf_2_x_mat) ;

%dF12_vec = zeros(n_point_pairs,1) ;

% Select the requested number of point pairs.

%Sobol_select_itr = 0 ;

%Sobol_select_itr_before_reset = 0 ;

number_of_passes_through_Sobol_matrix = 0 ;

%sum_of_diff_view_factors = 0 ;

%valid_point_pairs_num = 0 ;

%point_pair_itr = 1 ;

tic

%valid_point_pairs_num = valid_point_pairs_num

%n_point_pairs = n_point_pairs

while valid_point_pairs_num < n_point_pairs

% Find a point pair, subject to a series of conditions.

% NOTE: The point pair that is ultimately selected by this part
% of the code will be referred to as the "honest-to-God point
% pair" (htg).

htg_point_pair_selected = 0 ;

while htg_point_pair_selected == 0

candidate_point_pair_selected = 0 ;

point_pair_search_itr = 0 ;

while candidate_point_pair_selected == 0

% Reset the Sobol iteration number to 1 if the end
% of the Sobol matrix has been reached.

if Sobol_select_itr == Sobol_matrix_row_num
%Sobol_select_itr_before_reset = Sobol_select_itr_before_reset + Sobol_select_itr ;
Sobol_select_itr = 1 ;
number_of_passes_through_Sobol_matrix = number_of_passes_through_Sobol_matrix + 1
else
Sobol_select_itr = Sobol_select_itr + 1;
end

% Choose a point pair probabilistically.

rand_num_1 = rand() ;

if aug_Sobol_mat(Sobol_select_itr,5) >= rand_num_1
candidate_point_pair_selected = 1 ;
else

point_pair_search_itr = point_pair_search_itr + 1 ;

% Halt iteration, and force selection of the current
% point pair, if 100 cycles have elapsed without a
% point-pair selection.

if point_pair_search_itr >= 100
disp( ' ')
disp( 'Point pair search halted after 100 cycles.' )
candidate_point_pair_selected = 1 ;
else
% Reset the Sobol iteration number to 1 if the end
% of the Sobol matrix has been reached.

if Sobol_select_itr == Sobol_matrix_row_num
%Sobol_select_itr_before_reset = Sobol_select_itr_before_reset + Sobol_select_itr ;
Sobol_select_itr = 1 ;
number_of_passes_through_Sobol_matrix = number_of_passes_through_Sobol_matrix + 1
else
Sobol_select_itr = Sobol_select_itr + 1;
end

end

end

end

% Check the candidate point pair, to see if it is physically valid.

% EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
%
% Extract Indices
%
% EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

% Extract the indices for the candidate point pair, which
% correspond to the selected row of the Sobol matrix.

surf_1_row_Sobol = aug_Sobol_mat(Sobol_select_itr,1) ;

surf_1_row_ind = ceil(surf_1_row_Sobol * (rows_surf_1_x_mat_num - 1) ) ;

surf_1_row_ind = int32(surf_1_row_ind) ;

surf_1_col_Sobol = aug_Sobol_mat(Sobol_select_itr,2) ;

surf_1_col_ind = ceil(surf_1_col_Sobol * (cols_surf_1_x_mat_num - 1) ) ;

surf_1_col_ind = int32(surf_1_col_ind) ;

surf_2_row_Sobol = aug_Sobol_mat(Sobol_select_itr,3) ;

surf_2_row_ind = ceil(surf_2_row_Sobol * (rows_surf_2_x_mat_num - 1) ) ;

surf_2_row_ind = int32(surf_2_row_ind) ;

surf_2_col_Sobol = aug_Sobol_mat(Sobol_select_itr,4) ;

surf_2_col_ind = ceil(surf_2_col_Sobol * (cols_surf_2_x_mat_num - 1) ) ;

surf_2_col_ind = int32(surf_2_col_ind) ;

% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
%
% Generate Quadrilaterals
%
% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ

% Call a subroutine to obtain the pair of quadrilaterals
% that corresponds to the preceding indices for the
% candidate point pair.

[surf_1_a_vec,surf_1_b_vec,surf_1_c_vec,surf_1_d_vec, ...
surf_2_a_vec,surf_2_b_vec,surf_2_c_vec,surf_2_d_vec] = ...
quadrilateral_pairs_select(surf_1_x_mat,surf_1_y_mat,surf_1_z_mat, ...
surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, ...
[surf_1_row_ind,surf_1_col_ind,surf_2_row_ind,surf_2_col_ind]) ;

% Prepare and feed inputs to the differential view factor subroutine.

dA1_mat = vertcat(surf_1_a_vec,surf_1_b_vec,surf_1_c_vec,surf_1_d_vec) ;

dA2_mat = vertcat(surf_2_a_vec,surf_2_b_vec,surf_2_c_vec,surf_2_d_vec) ;

dA1_center_vec = mean(dA1_mat,1) ;

dA2_center_vec = mean(dA2_mat,1) ;

[is_point_valid, ...
diff_view_factor_val, ...
n_dA1_normal_vec,n_dA2_normal_vec, ...
mag_root_12] = ...
diff_view_factor_8(dA1_mat,dA2_mat, ...
surf_1_center_vec, ...
movement_of_ray_relative_to_center_of_surface_1, ...
surf_2_center_vec, ...
movement_of_ray_relative_to_center_of_surface_2) ;

% If the candidate point pair is physically valid...

if is_point_valid == 1

% Check to see if the corresponding ray intersects the
% obstructing surface.

% ...pass this information along to the Sobol learning
% system subroutine, so that the probabilities of the
% adjacent points can be adjusted accordingly.

[aug_Sobol_mat] = Sobol_learning_system_3(aug_Sobol_mat,Sobol_select_itr, is_point_valid) ;


if or(abs(dA2_center_vec(1,1)-dA1_center_vec(1,1))<0.1, ...
abs(dA2_center_vec(1,2)-dA1_center_vec(1,2))<0.1)

[intersection_mat, ...
ray_obstructed] = ...
double_check_if_ray_obstructed(dA1_center_vec,dA2_center_vec, ...
surf_1_x_mat,surf_1_y_mat,surf_1_z_mat, ...
surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, ...
obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat) ;

else

[intersection_mat, ...
ray_obstructed] = ...
is_ray_obstructed_by_surface_4(dA1_center_vec,dA2_center_vec, ...
surf_1_x_mat,surf_1_y_mat,surf_1_z_mat, ...
surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, ...
obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat) ;

end

if ray_obstructed == 1


diff_view_factor_val = 0;
% Find the point of obstruction that is closest to the
% emitting surface, surface 1.

[rows_intersection_mat,~]=size(intersection_mat) ;

% If there is only one row in the intersection point
% matrix...

if rows_intersection_mat == 1
%...make that row the intersection point vector.
obstruction_point_vec = intersection_mat(1,:) ;
% Otherwise...
else
% ...find the intersection point that is closest to
% surface 1, and keep that as the intersection point
% vector.

dist_betw_dA1_and_intersection_mat = sqrt(sum((intersection_mat - dA1_center_vec).^2,2)) ;

min_dist_betw_dA1_and_intersection = min (dist_betw_dA1_and_intersection_mat) ;

row_of_min_dist = find (dist_betw_dA1_and_intersection_mat==min_dist_betw_dA1_and_intersection) ;

if max(size(row_of_min_dist)) > 1
row_of_min_dist = row_of_min_dist(1,1) ;
else
end

obstruction_point_vec = intersection_mat(row_of_min_dist,:) ;
end

valid_point_pairs_num = valid_point_pairs_num + is_point_valid ;

is_ray_obstructed_3mat(point_pair_itr,:,simulation_itr) = ray_obstructed ;

obstruction_point_3mat(point_pair_itr,:,simulation_itr) = obstruction_point_vec ;

dA1_center_3mat(point_pair_itr,:,simulation_itr) = dA1_center_vec ;

dA2_center_3mat(point_pair_itr,:,simulation_itr) = dA2_center_vec ;

is_point_valid_3mat(point_pair_itr,:,simulation_itr) = is_point_valid ;

n_dA1_normal_3mat(point_pair_itr,:,simulation_itr) = n_dA1_normal_vec ;

n_dA2_normal_3mat(point_pair_itr,:,simulation_itr) = n_dA2_normal_vec ;

mag_root_12_valid_3mat(point_pair_itr,1,simulation_itr) = mag_root_12 ;

% Add the resulting output to the growing list of
% differential view factor contributions.

%sum_of_diff_view_factors = sum_of_diff_view_factors + diff_view_factor_val ;

dF12_vec(point_pair_itr,1) = diff_view_factor_val ;

point_pair_itr = point_pair_itr + 1 ;

htg_point_pair_selected = 1 ;

% Otherwise, if the ray is NOT obstructed...
else
obstruction_point_vec = zeros(1,3);

% Complete the current choice of point pairs without using
% library values to weight its choice.

aug_Sobol_mat(Sobol_select_itr,5) = -aug_Sobol_mat(Sobol_select_itr,5) ;

%[aug_Sobol_mat] = Sobol_learning_system_3(aug_Sobol_mat,Sobol_select_itr, is_point_valid) ;

% Store the information about the center points of each
% differential surface, and their corresponding normals.

% Store the information about the center points of each
% differential surface, and their corresponding normals.
%
% NOTE: a combination of two differential surfaces that is
% "valid," by virtue of having a physically reasonable
% direction of ray propagation, may still be obstructed if
% said ray is directed into the blocking surface.

valid_point_pairs_num = valid_point_pairs_num + is_point_valid ;

is_ray_obstructed_3mat(point_pair_itr,:,simulation_itr) = 0 ;

obstruction_point_3mat(point_pair_itr,:,simulation_itr) = obstruction_point_vec ;

dA1_center_3mat(point_pair_itr,:,simulation_itr) = dA1_center_vec ;

dA2_center_3mat(point_pair_itr,:,simulation_itr) = dA2_center_vec ;

is_point_valid_3mat(point_pair_itr,:,simulation_itr) = is_point_valid ;

n_dA1_normal_3mat(point_pair_itr,:,simulation_itr) = n_dA1_normal_vec ;

n_dA2_normal_3mat(point_pair_itr,:,simulation_itr) = n_dA2_normal_vec ;

mag_root_12_valid_3mat(point_pair_itr,1,simulation_itr) = mag_root_12 ;

% Add the resulting output to the growing list of
% differential view factor contributions.

%sum_of_diff_view_factors = sum_of_diff_view_factors + diff_view_factor_val ;

dF12_vec(point_pair_itr,1) = diff_view_factor_val ;

point_pair_itr = point_pair_itr + 1 ;

htg_point_pair_selected = 1 ;

end

else
% ...reject the (physically invalid) candidate point
% pair, and move on to the next point pair.

% First, reset this point pair's probability to
% zero, so it cannot be selected again by the
% routine.

aug_Sobol_mat(Sobol_select_itr,5) = 0 ;

% Second, pass this information about the candidate
% point pair's bogus-ness along to the Sobol learning
% system subroutine, so that the probabilities of the
% adjacent points can be adjusted accordingly.

[aug_Sobol_mat] = Sobol_learning_system_3(aug_Sobol_mat,Sobol_select_itr, is_point_valid) ;


end

end

end

is_ray_obstructed_3mat = logical(is_ray_obstructed_3mat) ;

%Sobol_select_itr = Sobol_select_itr + Sobol_select_itr_before_reset ;

time_finding_n_point_pairs = toc
disp( ' ')
end
