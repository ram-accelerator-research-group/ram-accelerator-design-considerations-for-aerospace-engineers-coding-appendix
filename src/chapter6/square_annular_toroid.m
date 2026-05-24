function [x_square_annular_toroid_mat,y_square_annular_toroid_mat, z_square_annular_toroid_mat] = ...
square_annular_toroid(radial_location_of_square_center,length_of_square_side, ...
num_x_points,num_half_y_points,phi_num_square_annular_toroid, ...
plot_square_annular_toroid,plot_square_annular_toroid_as_new_figure)
%
% The purpose of this function is to generate the Cartesian meshgrids
% that describe a square annular toroid, which is totally symmetric
% around the z axis.
%
% Usage:
%
% [x_square_annular_toroid_mat,y_square_annular_toroid_mat,z_square_annular_toroid_m at] = ...
% square_annular_toroid(radial_location_of_square_center,length_of_square_side, ...
% num_x_points,num_half_y_points,phi_num_square_annular_toroid,...
% plot_square_annular_toroid,plot_square_annular_toroid_as_new_figure) ;

half_length_of_square_side = length_of_square_side/2 ;

inner_x = radial_location_of_square_center - half_length_of_square_side ;

outer_x = radial_location_of_square_center + half_length_of_square_side ;

x_upper_side_vec = inner_x: (2*half_length_of_square_side)/(num_x_points-1) : outer_x ;

x_upper_side_vec = fliplr(x_upper_side_vec) ;

x_lower_side_vec = inner_x: (2*half_length_of_square_side)/(num_x_points-1) : outer_x ;

x_inner_half_side_vec = inner_x .* ones(1,num_half_y_points) ;

x_outer_half_side_vec = outer_x .* ones(1,num_half_y_points) ;

y_upper_half_vec = 0:(half_length_of_square_side)/(num_half_y_points-1): +half_length_of_square_side ;

y_lower_half_vec = 0:(-half_length_of_square_side)/(num_half_y_points-1):- half_length_of_square_side ;

y_upper_side_vec = +half_length_of_square_side .* ones(1,num_x_points) ;

y_lower_side_vec = -half_length_of_square_side .* ones(1,num_x_points) ;

total_x_square_vec = [x_outer_half_side_vec,x_upper_side_vec,x_inner_half_side_vec, x_inner_half_side_vec,x_lower_side_vec,x_outer_half_side_vec ] ;

total_y_square_vec = [y_upper_half_vec, y_upper_side_vec,fliplr(y_upper_half_vec), y_lower_half_vec, y_lower_side_vec,fliplr(y_lower_half_vec)] ;

r_vec = total_x_square_vec ;

h_vec = total_y_square_vec ;

phi_vec = 0 : (2*pi)/(phi_num_square_annular_toroid-1) : 2*pi ;

% Generate the outer segment of the lower half.

[phi_mat,r_mat] = meshgrid(phi_vec,r_vec) ;

h_vec = h_vec .* (r_vec./r_vec) ;

h_mat = h_vec' .* ones(max(size(r_vec)),max(size(phi_vec))) ;

[x_square_annular_toroid_mat,y_square_annular_toroid_mat,z_square_annular_toroid_m at] = pol2cart(phi_mat,r_mat,h_mat) ;

if plot_square_annular_toroid == 1

if plot_square_annular_toroid_as_new_figure == 1

figure

%surf(x_lh_inner_outer_mat,y_lh_inner_outer_mat,z_lh_inner_outer_mat)
surf(x_square_annular_toroid_mat,y_square_annular_toroid_mat, z_square_annular_toroid_mat, 'EdgeColor' ,'none')

hold on
axis equal

xlabel( 'X axis (m)' )
ylabel( 'Y axis (m)' )
zlabel( 'Z axis (m)' )

else

hold on
axis equal

%surf(x_lh_inner_outer_mat,y_lh_inner_outer_mat,z_lh_inner_outer_mat)
surf(x_square_annular_toroid_mat,y_square_annular_toroid_mat, z_square_annular_toroid_mat, 'EdgeColor' ,'k')

end

%surf(x_uh_inner_outer_mat,y_uh_inner_outer_mat,z_uh_inner_outer_mat)

if plot_square_annular_toroid_as_new_figure == 1

cva = camva ;

camva(0.8*cva);

camva( 'manual')

else
end

else
end

end
