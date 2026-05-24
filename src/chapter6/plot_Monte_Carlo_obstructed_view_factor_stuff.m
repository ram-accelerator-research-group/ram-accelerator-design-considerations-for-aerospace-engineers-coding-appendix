function [num_run_to_plot] = ...
plot_Monte_Carlo_obstructed_view_factor_stuff(surf_1_x_mat,surf_1_y_mat,surf_1_z_m at, ...
surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, ...
surf_obs_x_mat,surf_obs_y_mat,surf_obs_z_mat, ...
is_ray_obstructed_3mat,obstruction_point_3mat, ...
dA1_center_3mat,dA2_center_3mat, ...
n_dA1_normal_3mat,n_dA2_normal_3mat, ...
num_run_to_plot)
%
% Input Terms:
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
% dA1_center_3mat = a three-dimensional matrix where each "page"
% represents an individual Monte Carlo run.
% Within each page, each row represents the
% center of a quadrilateral (differential area)
% that was chosen on surface 1: the three columns
% of that page represent the x, y, and z
% coordinates of that center point.
%
% dA2_center_3mat = a three-dimensional matrix where each "page"
% represents an individual Monte Carlo run.
% Within each page, each row represents the
% center of a quadrilateral (differential area)
% that was chosen on surface 1: the three columns
% of that page represent the x, y, and z
% coordinates of that center point.
%
% n_dA1_normal_3mat = a three-dimensional matrix where each "page"
% represents an individual Monte Carlo run.
% Within each page, each row represents the
% normal vector that corresponds to the center
% point on the same page and row in
% dA1_center_3mat; the three columns
% of that page represent the x, y, and z
% extent of that normal.
%
%
% n_dA2_normal_3mat = a three-dimensional matrix where each "page"
% represents an individual Monte Carlo run.
% Within each page, each row represents the
% normal vector that corresponds to the center
% point on the same page and row in
% dA2_center_3mat; the three columns
% of that page represent the x, y, and z
% extent of that normal.
%
% Usage:
%
% [num_run_to_plot] = ...
% plot_Monte_Carlo_obstructed_view_factor_stuff(surf_1_x_mat,surf_1_y_mat,surf_1_z_m at,...
% surf_2_x_mat,surf_2_y_mat,surf_2_z_mat,...
% surf_obs_x_mat,surf_obs_y_mat,surf_obs_z_mat,...
% is_ray_obstructed_3mat,obstruction_point_3mat,...
% dA1_center_3mat,dA2_center_3mat,...
% n_dA1_normal_3mat,n_dA2_normal_3mat,...
% num_run_to_plot)

% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
%
% Validation
%
% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

if size(dA1_center_3mat) ~= size(dA2_center_3mat)
error( 'The two "center point" matrices must be the same size.' )
else
end

if size(n_dA1_normal_3mat) ~= size(n_dA2_normal_3mat)
error( 'The two matrices of normal vectors must be the same size.' )
else
end

% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
%
% Set Up Plot
%
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

% Plot the three surfaces, and configure the graph so it will display
% consistent dimensions during 3D rotation.

figure

%CO_1(:,:,1) = ones(size(surf_1_x_mat)).*linspace(0.5,0.6,max(size(surf_1_x_mat))); % red
%CO_1(:,:,2) = zeros(size(surf_1_x_mat)); % green
%CO_1(:,:,3) = ones(size(surf_1_x_mat)).*linspace(0,1,max(size(surf_1_x_mat))); % blue

%surf(surf_1_x_mat,surf_1_y_mat,surf_1_z_mat,CO_1,'EdgeColor','none')

surf(surf_1_x_mat,surf_1_y_mat,surf_1_z_mat, 'EdgeColor' ,'none')

hold on

axis equal

grid on
title([ "View Factors Inside Buseman Toroid" ,"With Hyperbolic Toroid Cargo Volume"],'FontSize' , 27)
xlabel( 'x-axis (m)' , 'FontSize' , 23)
ylabel( 'y-axis (m)' , 'FontSize' , 23)
zlabel( 'z-axis (m)' , 'FontSize' , 23)

%CO_2(:,:,1) = zeros(size(surf_2_x_mat)); % red
%CO_2(:,:,2) = ones(size(surf_2_x_mat)).*linspace(0.5,0.6,max(size(surf_2_x_mat))); % green
%CO_2(:,:,3) = ones(size(surf_2_x_mat)).*linspace(0,1,max(size(surf_2_x_mat))); % blue

%surf(surf_2_x_mat,surf_2_y_mat,surf_2_z_mat,CO_2,'EdgeColor','none')

surf(surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, 'EdgeColor' ,'none')

% CO_3(:,:,1) = ones(size(surf_obs_x_mat)).*linspace(0,0.5,min(size(surf_obs_x_mat))); % red
% CO_3(:,:,2) = ones(size(surf_obs_x_mat)).*linspace(0,0.5,min(size(surf_obs_x_mat))); % green
% CO_3(:,:,3) = ones(size(surf_obs_x_mat)).*linspace(0,0.5,min(size(surf_obs_x_mat))); % blue

%surf(surf_obs_x_mat,surf_obs_y_mat,surf_obs_z_mat,CO_3,'EdgeColor','none')

surf(surf_obs_x_mat,surf_obs_y_mat,surf_obs_z_mat, 'EdgeColor' ,'k')

cva = camva ;

camva(0.8*cva) ;

camva( 'manual')

v = axis ;
v(1,6) = 0 ;
axis(v) ;

rotate3d on

[num_points,~,~] = size(dA1_center_3mat) ;

for point_itr = 1:1:num_points

% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
% 111111111111111111111111111111111111111111111111111111111111111111111
% 222222222222222222222222222222222222222222222222222222222222222222222
%
% Plot Center Points and "r_12"s
%
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
% 111111111111111111111111111111111111111111111111111111111111111111111
% 222222222222222222222222222222222222222222222222222222222222222222222

% Plot the center points of the two differential surfaces,
% along with the r12 line joining these two points.

plot3(dA1_center_3mat(point_itr,1,num_run_to_plot),dA1_center_3mat(point_itr,2, num_run_to_plot),dA1_center_3mat(point_itr,3,num_run_to_plot), 'mo')
plot3(dA2_center_3mat(point_itr,1,num_run_to_plot),dA2_center_3mat(point_itr,2, num_run_to_plot),dA2_center_3mat(point_itr,3,num_run_to_plot), 'co')

if is_ray_obstructed_3mat(point_itr,1,num_run_to_plot) == 0
r12_x_vec = [dA1_center_3mat(point_itr,1,num_run_to_plot),dA2_center_3mat(point_itr, 1,num_run_to_plot)];
r12_y_vec = [dA1_center_3mat(point_itr,2,num_run_to_plot),dA2_center_3mat(point_itr, 2,num_run_to_plot)];
r12_z_vec = [dA1_center_3mat(point_itr,3,num_run_to_plot),dA2_center_3mat(point_itr, 3,num_run_to_plot)];

plot3(r12_x_vec,r12_y_vec,r12_z_vec, 'r-','LineWidth' ,1)
else
dA1_to_obs_x_vec = [dA1_center_3mat(point_itr,1,num_run_to_plot), obstruction_point_3mat(point_itr,1,num_run_to_plot)];
dA1_to_obs_y_vec = [dA1_center_3mat(point_itr,2,num_run_to_plot), obstruction_point_3mat(point_itr,2,num_run_to_plot)];
dA1_to_obs_z_vec = [dA1_center_3mat(point_itr,3,num_run_to_plot), obstruction_point_3mat(point_itr,3,num_run_to_plot)];

plot3(obstruction_point_3mat(point_itr,1,num_run_to_plot),obstruction_point_3mat (point_itr,2,num_run_to_plot),obstruction_point_3mat(point_itr,3,num_run_to_plot), 'c*')

plot3(dA1_to_obs_x_vec,dA1_to_obs_y_vec,dA1_to_obs_z_vec, 'k-')
end

% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
%
% Plot Normals
%
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN

% Plot the normals at both of the
% differential surfaces being assessed.

quiver3(dA1_center_3mat(point_itr,1,num_run_to_plot),dA1_center_3mat(point_itr,2, num_run_to_plot),dA1_center_3mat(point_itr,3,num_run_to_plot), ...
n_dA1_normal_3mat(point_itr,1,num_run_to_plot),n_dA1_normal_3mat(point_itr,2, num_run_to_plot),n_dA1_normal_3mat(point_itr,3,num_run_to_plot), ...
0.1, 'g-')

quiver3(dA2_center_3mat(point_itr,1,num_run_to_plot),dA2_center_3mat(point_itr,2, num_run_to_plot),dA2_center_3mat(point_itr,3,num_run_to_plot), ...
n_dA2_normal_3mat(point_itr,1,num_run_to_plot),n_dA2_normal_3mat(point_itr,2, num_run_to_plot),n_dA2_normal_3mat(point_itr,3,num_run_to_plot), ...
0.1, 'g-')

end

view(2)

end
