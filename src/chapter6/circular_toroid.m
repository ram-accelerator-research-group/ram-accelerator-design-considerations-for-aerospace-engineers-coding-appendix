function [x_circular_toroid_mat,y_circular_toroid_mat,z_circular_toroid_mat] = ...
circular_toroid(major_radius,minor_radius, ...
num_x_points,phi_num_circular_toroid, ...
plot_circular_toroid,plot_circular_toroid_as_new_figure)
%
% The purpose of this function is to generate the Cartesian meshgrids
% that describe a standard circular toroid, which is totally symmetric
% around the z axis.
%
% Usage:
%
% [x_circular_toroid_mat,y_circular_toroid_mat,z_circular_toroid_mat] = ...
% circular_toroid(major_radius,minor_radius, ...
% num_x_points,phi_num_circular_toroid,...
% plot_circular_toroid,plot_circular_toroid_as_new_figure) ;

x_circle_vec = major_radius - minor_radius: (2*minor_radius)/(num_x_points-1) : major_radius + minor_radius ;

upper_y_circle_vec = +sqrt( (minor_radius^2) - ((x_circle_vec - major_radius).^2) ) ;

lower_y_circle_vec = -sqrt( (minor_radius^2) - ((x_circle_vec - major_radius).^2) ) ;

total_x_circle_vec = horzcat(fliplr(x_circle_vec),x_circle_vec) ;

total_y_circle_vec = horzcat(fliplr(upper_y_circle_vec),lower_y_circle_vec) ;

r_vec = total_x_circle_vec ;

h_vec = total_y_circle_vec ;

phi_vec = 0 : (2*pi)/(phi_num_circular_toroid-1) : 2*pi ;

% Generate the outer segment of the lower half.

[phi_mat,r_mat] = meshgrid(phi_vec,r_vec) ;

h_vec = h_vec .* (r_vec./r_vec) ;

h_mat = h_vec' .* ones(max(size(r_vec)),max(size(phi_vec))) ;

[x_circular_toroid_mat,y_circular_toroid_mat,z_circular_toroid_mat] = pol2cart(phi_mat,r_mat, h_mat) ;

z_circular_toroid_mat = real(z_circular_toroid_mat) ;

isreal_x_circular_toroid_mat = isreal(x_circular_toroid_mat)

isreal_y_circular_toroid_mat = isreal(y_circular_toroid_mat)

isreal_z_circular_toroid_mat = isreal(z_circular_toroid_mat)

if plot_circular_toroid == 1

if plot_circular_toroid_as_new_figure == 1

figure

%surf(x_lh_inner_outer_mat,y_lh_inner_outer_mat,z_lh_inner_outer_mat)
surf(x_circular_toroid_mat,y_circular_toroid_mat, z_circular_toroid_mat, 'EdgeColor' ,'none')

hold on
axis equal

xlabel( 'X axis (m)' )
ylabel( 'Y axis (m)' )
zlabel( 'Z axis (m)' )

else

hold on
axis equal

%surf(x_lh_inner_outer_mat,y_lh_inner_outer_mat,z_lh_inner_outer_mat)
surf(x_circular_toroid_mat,y_circular_toroid_mat, z_circular_toroid_mat, 'EdgeColor' ,'k')

end

%surf(x_uh_inner_outer_mat,y_uh_inner_outer_mat,z_uh_inner_outer_mat)


if plot_circular_toroid_as_new_figure == 1

cva = camva ;

camva(0.8*cva);

camva( 'manual')

else
end

else
end

end
