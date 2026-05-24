function [dA1_center_vec,dA2_center_vec, ...
surf_1_x_mat,surf_1_y_mat,surf_1_z_mat, ...
surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, ...
obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat] = ...
validate_is_ray_obstructed_by_surface(dA1_center_vec,dA2_center_vec, ...
surf_1_x_mat,surf_1_y_mat,surf_1_z_mat, ...
surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, ...
obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat)
%
% The purpose of this function is to validate data input for the
% is_ray_obstructed_by_surface_4 routine.
%
% Usage:
%
% [dA1_center_vec,dA2_center_vec,...
% surf_1_x_mat,surf_1_y_mat,surf_1_z_mat,...
% surf_2_x_mat,surf_2_y_mat,surf_2_z_mat,...
% obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat] = ...
% validate_is_ray_obstructed_by_surface(dA1_center_vec,dA2_center_vec,...
% surf_1_x_mat,surf_1_y_mat,surf_1_z_mat,...
% surf_2_x_mat,surf_2_y_mat,surf_2_z_mat,...
% obs_surf_x_mat,obs_surf_y_mat,obs_surf_z_mat);

if isempty(dA1_center_vec)
disp( ' ')
error( 'The vector describing the first point on the line must contain numbers.' )
else
if max(size(dA1_center_vec)) < 3
disp( ' ')
error( 'The vector describing the first point on the line must contain 3 Cartesian coordinates.' )
else
end
end

if isempty(dA2_center_vec)
disp( ' ')
error( 'The vector describing the second point on the line must contain numbers.' )
else
if max(size(dA1_center_vec)) < 3
disp( ' ')
error( 'The vector describing the first point on the line must contain 3 Cartesian coordinates.' )
else
end
end

% Validate the meshgrid matrices for surface 1.

if isempty(surf_1_x_mat)
disp( ' ')
error( 'The meshgrid for the x coordinates of surface 1 must contain numbers.' )
else
if isreal(surf_1_x_mat) == 0
disp( ' ')
error( 'The meshgrid for the x coordinates of surface 1 must contain real numbers.' )
else
if min(size(surf_1_x_mat)) == 1
disp( ' ')
error( 'The x coordinates of surface 1 must be contained in a meshgrid.' )
else
end
end
end

if isempty(surf_1_y_mat)
disp( ' ')
error( 'The meshgrid for the y coordinates of surface 1 must contain numbers.' )
else
if isreal(surf_1_y_mat) == 0
disp( ' ')
error( 'The meshgrid for the y coordinates of surface 1 must contain real numbers.' )
else
if min(size(surf_1_y_mat)) == 1
disp( ' ')
error( 'The y coordinates of surface 1 must be contained in a meshgrid.' )
else
end
end
end

if isempty(surf_1_x_mat)
disp( ' ')
error( 'The meshgrid for the z coordinates of surface 1 must contain numbers.' )
else
if isreal(surf_1_z_mat) == 0
disp( ' ')
error( 'The meshgrid for the z coordinates of surface 1 must contain real numbers.' )
else
if min(size(surf_1_z_mat)) == 1
disp( ' ')
error( 'The z coordinates of surface 1 must be contained in a meshgrid.' )
else
end
end
end

if size(surf_1_x_mat) ~= size(surf_1_y_mat)
disp( ' ')
error( 'The x and y meshgrids for the first surface must both be the same size.' )
else
if size(surf_1_y_mat) ~= size(surf_1_z_mat)
disp( ' ')
error( 'The y and z meshgrids for the first surface must both be the same size.' )
else
end
end

% Validate the meshgrid matrices for surface 2.

if isempty(surf_2_x_mat)
disp( ' ')
error( 'The meshgrid for the x coordinates of surface 2 must contain numbers.' )
else
if isreal(surf_2_x_mat) == 0
disp( ' ')
error( 'The meshgrid for the x coordinates of surface 2 must contain real numbers.' )
else
if min(size(surf_2_x_mat)) == 1
disp( ' ')
error( 'The x coordinates of surface 2 must be contained in a meshgrid.' )
else
end
end
end

if isempty(surf_2_y_mat)
disp( ' ')
error( 'The meshgrid for the y coordinates of surface 2 must contain numbers.' )
else
if isreal(surf_2_y_mat) == 0
disp( ' ')
error( 'The meshgrid for the y coordinates of surface 2 must contain real numbers.' )
else
if min(size(surf_2_y_mat)) == 1
disp( ' ')
error( 'The y coordinates of surface 2 must be contained in a meshgrid.' )
else
end
end
end

if isempty(surf_2_z_mat)
disp( ' ')
error( 'The meshgrid for the z coordinates of surface 1 must contain numbers.' )
else
if isreal(surf_2_z_mat) == 0
disp( ' ')
error( 'The meshgrid for the z coordinates of surface 1 must contain real numbers.' )
else
if min(size(surf_2_z_mat)) == 1
disp( ' ')
error( 'The z coordinates of surface 1 must be contained in a meshgrid.' )
else
end
end
end

if size(surf_2_x_mat) ~= size(surf_2_y_mat)
disp( ' ')
error( 'The x and y meshgrids for the second surface must both be the same size.' )
else
if size(surf_2_y_mat) ~= size(surf_2_z_mat)
disp( ' ')
error( 'The y and z meshgrids for the second surface must both be the same size.' )
else
end
end

% Validate the meshgrid matrices for the obstructing surface.

if isempty(obs_surf_x_mat)
disp( ' ')
error( 'The meshgrid for the x coordinates of the obstructing surface must contain numbers.' )
else
if isreal(obs_surf_x_mat) == 0
disp( ' ')
error( 'The meshgrid for the x coordinates of the obstructing surface must contain real numbers.' )
else
end
end

if isempty(obs_surf_y_mat)
disp( ' ')
error( 'The meshgrid for the y coordinates of the obstructing surface must contain numbers.' )
else
if isreal(obs_surf_y_mat) == 0
disp( ' ')
error( 'The meshgrid for the y coordinates of the obstructing surface must contain real numbers.' )
else
end
end

if isempty(obs_surf_x_mat)
disp( ' ')
error( 'The meshgrid for the z coordinates of the obstructing surface must contain numbers.' )
else
if isreal(obs_surf_z_mat) == 0
disp( ' ')
error( 'The meshgrid for the z coordinates of the obstructing surface must contain real numbers.' )
else
end
end

if size(obs_surf_x_mat) ~= size(obs_surf_y_mat)
disp( ' ')
error( 'The x and y meshgrids for the obstructing surface must both be the same size.' )
else
if size(obs_surf_y_mat) ~= size(obs_surf_z_mat)
disp( ' ')
error( 'The y and z meshgrids for the obstructing surface must both be the same size.')
else
end
end

% Verify that the obstructing surface lies within the bounds of the two
% radiating surfaces. Left in from previous attempts.

x_min_surfaces_1_and_2 = min([min(surf_1_x_mat),min(surf_2_x_mat)]);

x_max_surfaces_1_and_2 = max([max(surf_1_x_mat),max(surf_2_x_mat)]);

y_min_surfaces_1_and_2 = min([min(surf_1_y_mat),min(surf_2_y_mat)]);

y_max_surfaces_1_and_2 = max([max(surf_1_y_mat),max(surf_2_y_mat)]);

z_min_surfaces_1_and_2 = min([min(surf_1_z_mat),min(surf_2_z_mat)]);

z_max_surfaces_1_and_2 = max([max(surf_1_z_mat),max(surf_2_z_mat)]);

end
