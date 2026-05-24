function [intersection_mat, ...
ray_obstructed] = ...
is_ray_obstructed_by_surface_4(dA1_center_vec,dA2_center_vec, ...
surf_1_x_mat,surf_1_y_mat,surf_1_z_mat, ...
surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, ...
obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat)
%
% This function takes, as input, the coordinates of two points that
% define a line segment (i.e. ray), along with three meshgrids that
% define a surface. It then returns, as output, the truth value of
% whether or not the ray intersects--that is, is obstructed by--the
% surface. In addition, it returns the location of the point where the
% line intersects the obstructing surface.
%
% Usage:
%
% [intersection_mat,...
% ray_obstructed] =...
% is_ray_obstructed_by_surface_4(dA1_center_vec,dA2_center_vec,...
% surf_1_x_mat,surf_1_y_mat,surf_1_z_mat,...
% surf_2_x_mat,surf_2_y_mat,surf_2_z_mat,...
% obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat);

% PROGRAMMING NOTES
%
% This routine makes use of the following non-MATLAB subroutines:
%
% validate_is_ray_obstructed_by_surface
% make_and_expand_truth_matrix
% scan_meshgrids_for_intersection

% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
%
% Validation
%
% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

% Validate the input data being used by this routine.

[dA1_center_vec,dA2_center_vec, ...
~,~,~, ...
~,~,~, ...
obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat] = ...
validate_is_ray_obstructed_by_surface(dA1_center_vec,dA2_center_vec, ...
surf_1_x_mat,surf_1_y_mat,surf_1_z_mat, ...
surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, ...
obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat);

% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
%
% Coordinate Bounds
%
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB

% Construct the Cartesian coordinates bounding box that
% encompasses the entire extent of the associated ray.

dA1_dA2_mat = vertcat(dA1_center_vec,dA2_center_vec) ;

ray_bounding_box_x_min = min(dA1_dA2_mat(:,1),[],1) ;

ray_bounding_box_x_max = max(dA1_dA2_mat(:,1),[],1) ;

ray_bounding_box_y_min = min(dA1_dA2_mat(:,2),[],1) ;

ray_bounding_box_y_max = max(dA1_dA2_mat(:,2),[],1) ;

ray_bounding_box_z_min = min(dA1_dA2_mat(:,3),[],1) ;

ray_bounding_box_z_max = max(dA1_dA2_mat(:,3),[],1) ;

% Construct the Cartesian coordinates bounding box that encompasses the
% entire extent of the obstructing surface.

obs_surf_bounding_box_x_min = min(min(obs_surf_x_mat)) ;

obs_surf_bounding_box_x_max = max(max(obs_surf_x_mat)) ;

obs_surf_bounding_box_y_min = min(min(obs_surf_y_mat)) ;

obs_surf_bounding_box_y_max = max(max(obs_surf_y_mat)) ;

obs_surf_bounding_box_z_min = min(min(obs_surf_z_mat)) ;

obs_surf_bounding_box_z_max = max(max(obs_surf_z_mat)) ;

% Make notes of how far apart these bounding box limits originally are.

old_x_min_diff = abs( ray_bounding_box_x_min - obs_surf_bounding_box_x_min) ;

old_x_max_diff = abs( ray_bounding_box_x_max - obs_surf_bounding_box_x_max) ;

old_y_min_diff = abs( ray_bounding_box_y_min - obs_surf_bounding_box_y_min) ;

old_y_max_diff = abs( ray_bounding_box_y_max - obs_surf_bounding_box_y_max) ;

old_z_min_diff = abs( ray_bounding_box_z_min - obs_surf_bounding_box_z_min) ;

old_z_max_diff = abs( ray_bounding_box_z_max - obs_surf_bounding_box_z_max) ;

% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%
% Preliminary, Coarse Intersection Check
%
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

tol = 1e-14 ;

% Check to see whether or not the ray crosses near or through the
% obstructing volume at any region within the latter's entire 3D coordinate
% range.

% If there is such an overlap--that is...

% ...if the x coordinates overlap...

if and(ray_bounding_box_x_max>=obs_surf_bounding_box_x_min, ...
ray_bounding_box_x_min<=obs_surf_bounding_box_x_max)

% ... and the y coordinates overlap...

if and(ray_bounding_box_y_max>=obs_surf_bounding_box_y_min, ...
ray_bounding_box_y_min<=obs_surf_bounding_box_y_max)

% ....and the z coordinates overlap...

if and(ray_bounding_box_z_max>=obs_surf_bounding_box_z_min, ...
ray_bounding_box_z_min<=obs_surf_bounding_box_z_max)

% ...the ray may be obstructed by the surface, and more checks need to be
% done to determine if this occurs.

%disp(' ')
%disp('Ray may be obstructed.')
%disp('Doing further tests to check...')

% MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%
% Main, Fine Intersection Check
%
% MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

% There are some general possibilities that need to be checked
% here, which are as follows.
%
% INTERSECTION OF LINE WITH SURFACE
%
% 1) There are points on the obstructing surface that are
% contained within the bounding box of the ray, such that
% the ray goes through the surface.
%
% 2) The bounding box of the ray is contained within /
% surrounded by points on the obstructing surface;
% however, there are no points on the surface that lie
% within the ray's bounding box itself.
%
% NON-INTERSECTION OF LINE AND SURFACE
%
% 3) There are points on the obstructing surface that are
% contained within the bounding box of the ray, but the
% ray does not travel through the surface.
%
% 4) There are no surface points within the bounding box of
% the ray, because the ray does not intersect the surface
% anywhere.

% These cases can be reduced to cases 1) and 3) by simply
% expanding the ray's bounding box every time no surface points
% are found within it. This box will then expand until either:
%
% a) it begins to contain some points from the surface: or
%
% b) it expands to fill the entire (x,y,z) domain available,
% without encompassing any points from the surface.

% spwrbbspwrbbspwrbbspwrbbspwrbbspwrbbspwrbbspwrbbspwrbbspwrbb
%
% --surface points within ray bounding box--
%
% spwrbbspwrbbspwrbbspwrbbspwrbbspwrbbspwrbbspwrbbspwrbbspwrbb

% Determine what, if any, meshgrid indices are contained within
% the bounding box coordinates of the ray.

solution_found = 0 ;

%pass_number = 1 ;

while solution_found == 0

% First, check for overlap in the x coordinates.

[x_overlap_row_ind,x_overlap_col_ind] = find(and (obs_surf_x_mat<=ray_bounding_box_x_max,obs_surf_x_mat>=ray_bounding_box_x_min)) ;

% If there is overlap in the x coordinates...

if isempty(x_overlap_row_ind) == 0

%disp('x coordinates overlap')

x_overlap_ind_mat = horzcat(x_overlap_row_ind,x_overlap_col_ind) ;

% ...check for overlap in the y coordinates.

[y_overlap_row_ind,y_overlap_col_ind] = find(and (obs_surf_y_mat<=ray_bounding_box_y_max,obs_surf_y_mat>=ray_bounding_box_y_min)) ;

% If there is overlap in the y coordinates...

if isempty(y_overlap_row_ind) == 0

%disp('y coordinates overlap')

y_overlap_ind_mat = horzcat(y_overlap_row_ind,y_overlap_col_ind) ;

% ...check for overlap in the z coordinates.

[z_overlap_row_ind,z_overlap_col_ind] = find(and (obs_surf_z_mat<=ray_bounding_box_z_max,obs_surf_z_mat>=ray_bounding_box_z_min)) ;

% If there is overlap in the z coordinates...

if isempty(z_overlap_row_ind) == 0

%disp('z coordinates overlap')

z_overlap_ind_mat = horzcat(z_overlap_row_ind,z_overlap_col_ind);

% ...then there must be points from the surface
% that reside within the bounding box of the
% ray. As such, this ray will either intersect
% the surface (case 1) or barely miss the
% surface (case 3).

% Scan across these points on the meshgrid
% surface to check if and where an intersection
% occurs.

% Find the indices in the meshgrids where
% overlap occurs.

xy_overlap_ind_mat = intersect(x_overlap_ind_mat, y_overlap_ind_mat, 'rows');

xyz_overlap_ind_mat = intersect(xy_overlap_ind_mat, z_overlap_ind_mat, 'rows');

% At this point, the routine may or may not
% find that there are values on the surface
% that are overlapped by the ray's bounding
% box.
%
% If there are such points, a truth matrix
% should be made, and the corresponding
% meshgrid values should be inspected for
% intersections. The location of any such
% intersections--or, conversely, establishing
% that such intersections are absent-- means
% the search has ended.
%
% If there are points on the obstructing
% surface that are partially, but not totally,
% overlapped by the bounding box, then the ray
% must be skew to the obstructing surface.

if min(size(xyz_overlap_ind_mat)) > 1

% Make and expand a truth matrix corresponding
% to these (row,column) locations in the
% meshgrids.

[obs_truth_mat] = make_and_expand_truth_matrix (xyz_overlap_ind_mat,obs_surf_x_mat) ;

% Scan over the corresponding locations in the
% meshgrids to locate any intersections that
% occur between the obstructing surface and the
% ray.

[uppy_intersection_mat,downy_intersection_mat] = scan_meshgrids_for_intersection(obs_truth_mat, ...
dA1_center_vec,dA2_center_vec, ...
obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat);

uppy_downy_mat = vertcat(uppy_intersection_mat, downy_intersection_mat) ;

intersection_mat = uniquetol(uppy_downy_mat,1e-14, 'ByRows', true) ;

if ~isempty(intersection_mat)
ray_obstructed = 1 ;
else
ray_obstructed = 0 ;
end

solution_found = 1 ;

else

solution_found = 1 ;
ray_obstructed = 0 ;

intersection_mat = [] ;
end

% Otherwise...
else
% ...the bounding box of the ray does not cover
% multiple z locations on the surface.

z_min_diff = abs( ray_bounding_box_z_min - obs_surf_bounding_box_z_min ) ;

z_max_diff = abs( ray_bounding_box_z_max - obs_surf_bounding_box_z_max ) ;

% If the z-domain of the bounding box can be
% expanded...

if or( z_min_diff>tol, z_max_diff>tol )
% ...expand it, and allow the execution of
% the loop to continue.

% More specifically, if it is at all
% possible to expand the minimum z-value of
% the ray bounding box...

if z_min_diff>tol
% ...expand this minimum limit toward
% the boundaries of the obstructing
% surface's minimum z extent.

ray_bounding_box_z_min = ray_bounding_box_z_min - (0.1 *old_z_min_diff) ;

% Otherwise...
else
% ...leave this minimum z limit of the ray's
% bounding box unchanged.
end

% Likewise, if it is at all
% possible to expand the maximum z-value of
% the ray bounding box...

if z_max_diff>tol
% ...expand this maximum limit toward
% the boundaries of the obstructing
% surface's maximum z extent.

ray_bounding_box_z_max = ray_bounding_box_z_max + (0.1 *old_z_max_diff) ;

% Otherwise...
else
% ...leave this maximum z limit of the ray's
% bounding box unchanged.
end

else
% Otherwise, make a note that the maximum
% extent of the z-domain has been reached.
% No intersections of the ray with the obstucting
% surface are possible at this point, so
% terminate the loop's execution.

disp( ' ')
disp( 'Maximum z-extent of the ray bounding box has been reached.' )

solution_found = 1 ;

ray_obstructed = 0 ;

intersection_mat = [] ;

end

end
% Otherwise...
else
% ...the bounding box of the ray does not cover
% multiple y locations on the surface.

y_min_diff = abs( ray_bounding_box_y_min - obs_surf_bounding_box_y_min ) ;

y_max_diff = abs( ray_bounding_box_y_max - obs_surf_bounding_box_y_max ) ;

% If the y-domain of the bounding box can be
% expanded...

if or( y_min_diff>tol, y_max_diff>tol )
% ...expand it, and allow the execution of
% the loop to continue.

% More specifically, if it is at all
% possible to expand the minimum y-value of
% the ray bounding box...

if y_min_diff>tol
% ...expand this minimum limit toward
% the boundaries of the obstructing
% surface's minimum y extent.

ray_bounding_box_y_min = ray_bounding_box_y_min - (0.1 *old_y_min_diff) ;

% Otherwise...
else
% ...leave this minimum y limit of the ray's
% bounding box unchanged.
end

% Likewise, if it is at all
% possible to expand the maximum y-value of
% the ray bounding box...

if y_max_diff>tol
% ...expand this maximum limit toward
% the boundaries of the obstructing
% surface's maximum y extent.

ray_bounding_box_y_max = ray_bounding_box_y_max + (0.1 *old_y_max_diff) ;

% Otherwise...
else
% ...leave this maximum y limit of the ray's
% bounding box unchanged.
end
else

% Otherwise, make a note that the maximum
% extent of the y-domain has been reached.
% No intersections of the ray with the obstucting
% surface are possible at this point, so
% terminate the loop's execution.

disp( ' ')
disp( 'Maximum y-extent of the ray bounding box has been reached.' )

solution_found = 1 ;

ray_obstructed = 0 ;

intersection_mat = [] ;

end

end

% Otherwise...
else
% The bounding box of the ray does not cover multiple x
% locations on the surface.

x_min_diff = abs( ray_bounding_box_x_min - obs_surf_bounding_box_x_min ) ;

x_max_diff = abs( ray_bounding_box_x_max - obs_surf_bounding_box_x_max ) ;

% If the x-domain of the bounding box can be
% expanded...

if or( x_min_diff>tol, x_max_diff>tol )
% ...expand it, and allow the execution of
% the loop to continue.

% More specifically, if it is at all
% possible to expand the minimum x-value of
% the ray bounding box...

if x_min_diff>tol
% ...expand this minimum limit toward
% the boundaries of the obstructing
% surface's minimum x extent.

ray_bounding_box_x_min = ray_bounding_box_x_min - (0.1 *old_x_min_diff) ;

% Otherwise...
else
% ...leave this minimum x limit of the ray's
% bounding box unchanged.
end

% Likewise, if it is at all
% possible to expand the maximum x-value of
% the ray bounding box...

if x_max_diff>tol
% ...expand this maximum limit toward
% the boundaries of the obstructing
% surface's maximum x extent.

ray_bounding_box_x_max = ray_bounding_box_x_max + (0.1 *old_x_max_diff) ;

% Otherwise...
else
% ...leave this maximum x limit of the ray's
% bounding box unchanged.
end

else

% Otherwise, make a note that the maximum
% extent of the x-domain has been reached.
% No intersections of the ray with the obstucting
% surface are possible at this point, so
% terminate the loop's execution.

disp( ' ')
disp( 'Maximum x-extent of the ray bounding box has been reached.' )

solution_found = 1 ;

ray_obstructed = 0 ;

intersection_mat = [] ;

end
end

end

else
% ...there is no z overlap. The ray categorically cannot
% overlap the obstructing volume, and no further checks need to
% be done.

ray_obstructed = 0 ;

intersection_mat = [] ;

end

else
% ...there is no y overlap. The ray categorically cannot overlap
% the obstructing volume, and no further checks need to be done.

ray_obstructed = 0 ;

intersection_mat = [] ;

end

else
% ...there is no x overlap. the ray categorically cannot overlap the
% obstructing volume, and no further checks need to be done.

ray_obstructed = 0 ;

intersection_mat = [] ;

end

end
