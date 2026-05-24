function [uppy_intersection_mat,downy_intersection_mat] = scan_meshgrids_for_intersection (obs_truth_mat, ...
dA1_center_vec,dA2_center_vec, ...
obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat)
%
%
% PROGRAMMING NOTES
%
% This routine makes use of the following non-MATLAB subroutines:
%
% line_intersects_plane
%
% Usage
%
% function [uppy_intersection_mat,downy_intersection_mat] = scan_meshgrids_for_intersection (obs_truth_mat,...
% dA1_center_vec,dA2_center_vec,...
% obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat)
%

uppy_intersection_mat = [] ;

downy_intersection_mat = [] ;

% Unite the two differential surface center points into a line matrix.

line_mat = vertcat(dA1_center_vec,dA2_center_vec) ;

% Make a note of which rows in the truth matrix are occupied by
% points that overlap between the surface and the ray's bounding box.

row_occupied_vec = sum(obs_truth_mat,2) ;

row_occupied_vec = find(row_occupied_vec>0) ;

row_occupied_vec = row_occupied_vec' ;

% For each one of these rows...

row_occupied_vec_row_num = max(size(row_occupied_vec)) ;

for row_itr = 1:1:row_occupied_vec_row_num - 1

% Extract the row indices to be scanned over.

%row_itr = row_itr

new_obs_mat_row = row_occupied_vec(1,row_itr) ;

% Make a note of which column locations are occupied.

occupied_columns_in_this_row_vec = find(obs_truth_mat(new_obs_mat_row,:)>0);

% Make a note of the occupied column locations in the next row down.

occupied_columns_in_next_row_vec = find(obs_truth_mat(new_obs_mat_row+1,:)>0);

% Iterate over the column locations of whichever row has fewer occupied
% columns.

if max(size(occupied_columns_in_this_row_vec)) <= max(size (occupied_columns_in_next_row_vec))
fewest_occupied_cols_num = max(size(occupied_columns_in_this_row_vec)) ;
occupied_columns_to_scan_over_vec = occupied_columns_in_this_row_vec ;
else
fewest_occupied_cols_num = max(size(occupied_columns_in_next_row_vec)) ;
occupied_columns_to_scan_over_vec = occupied_columns_in_next_row_vec ;
end

for col_itr = 1:1:fewest_occupied_cols_num - 1

% Extract the column indices to be scanned over.

new_obs_mat_col = occupied_columns_to_scan_over_vec(1,col_itr) ;

% The (row,column) indices describe a net of quadrilaterals. Since
% each quadrilateral can be thought of as consisting of two
% triangular halves, the scan will involve two parts: one
% for the "uppy" triangles, and one for the "downy" triangles.

% Extract the point for (row,col).

x_c = obs_surf_x_mat(new_obs_mat_row,new_obs_mat_col) ;

y_c = obs_surf_y_mat(new_obs_mat_row,new_obs_mat_col) ;

z_c = obs_surf_z_mat(new_obs_mat_row,new_obs_mat_col) ;

c_vec = [x_c,y_c,z_c] ;

% Extract the point for (row,col+1).

x_b = obs_surf_x_mat(new_obs_mat_row, new_obs_mat_col + 1 ) ;

y_b = obs_surf_y_mat(new_obs_mat_row, new_obs_mat_col + 1 ) ;

z_b = obs_surf_z_mat(new_obs_mat_row, new_obs_mat_col + 1 ) ;

b_vec = [x_b,y_b,z_b] ;

% Extract the point for (row+1,col).

x_d = obs_surf_x_mat(new_obs_mat_row + 1, new_obs_mat_col ) ;

y_d = obs_surf_y_mat(new_obs_mat_row + 1, new_obs_mat_col ) ;

z_d = obs_surf_z_mat(new_obs_mat_row + 1, new_obs_mat_col ) ;

d_vec = [x_d,y_d,z_d] ;

% Extract the point for (row+1,col+1).

x_a = obs_surf_x_mat(new_obs_mat_row + 1, new_obs_mat_col + 1 ) ;

y_a = obs_surf_y_mat(new_obs_mat_row + 1, new_obs_mat_col + 1 ) ;

z_a = obs_surf_z_mat(new_obs_mat_row + 1, new_obs_mat_col + 1 ) ;

a_vec = [x_a,y_a,z_a] ;

% Feed the uppy triangle points to the
% line_intersects_plane subroutine.

uppy_plane_mat = vertcat(c_vec,b_vec,d_vec) ;

[~, ...
~, ...
intersection_point_vec, ...
line_intersects_triangle] = ...
line_intersects_plane(line_mat,uppy_plane_mat);

% Store the results if an intersection between the ray and the uppy
% triangle is observed.

if line_intersects_triangle == 1
uppy_intersection_mat = vertcat(uppy_intersection_mat,intersection_point_vec) ;
else
end

% Feed the downy triangle points to the
% line_intersects_plane subroutine.

downy_plane_mat = vertcat(a_vec,b_vec,d_vec) ;

[~, ...
~, ...
intersection_point_vec, ...
line_intersects_triangle] = ...
line_intersects_plane(line_mat,downy_plane_mat);

% Store the results if an intersection between the ray and the
% downy triangle is observed.

if line_intersects_triangle == 1
downy_intersection_mat = vertcat(downy_intersection_mat,intersection_point_vec) ;
else
end

end

end

end
