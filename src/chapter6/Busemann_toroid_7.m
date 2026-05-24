function [diagonal_length_of_leading_cone,diagonal_length_of_frustum,cone_full_angle, ...
emissivity_inlet,x_inlet_mat,y_inlet_mat,z_inlet_mat, ...
emissivity_nozzle,x_nozzle_mat,y_nozzle_mat,z_nozzle_mat, ...
emissivity_cylinder,x_cylinder_mat,y_cylinder_mat,z_cylinder_mat, ...
phi_cylinder_mat] = ...
Busemann_toroid_7(r_inlet,r_throat,l_Busemann_toroid, ...
num_r_inlet_cone,phi_num_inlet, ...
phi_num_cylinder,h_num_cylinder, ...
emissivity_inlet,emissivity_nozzle,emissivity_cylinder, ...
plot_Busemann_toroid)
%
% The purpose of this function is to construct the three major surfaces
% that constitute a Busemann toroid: its inlet region, its nozzle region,
% and its cylinder region. It will return the coordinates of these three
% surfaces as meshgrid matrices in Cartesian coordinates.
%
% Input terms:
%
% r_inlet = ; r_throat = ; l_Busemann_toroid = ;
% num_r_inlet_cone = ; phi_num_inlet = ;
% phi_num_cylinder = ; h_num_cylinder = ;
% emissivity_inlet = ; emissivity_nozzle = ; emissivity_cylinder = ;
% plot_Busemann_toroid = ;
%
% where
%
% r_inlet = the radius of the outermost periphery
% of the toroid ;
%
% r_throat = the radius of the innermost periphery
% of the toroid ;
%
% l_Busemann_toroid = the overall length of the toroid as
% measured from its inlet lip to its
% nozzle lip;
%
% num_r_inlet_cone = the number of radial values that will
% be assessed for the conical frustom of
% the inlet (and, by association, the
% nozzle) ;
%
% phi_num_inlet = the number of angular values that will
% be assessed for the conical frustum of
% the inlet (and, by association, the
% nozzle) ;
%
% phi_num_cylinder = the number of angular values that will
% be assessed for the outer cylindrical
% surface of the Busemann toroid ;
%
% h_num_cylinder = the number of height (z-axis) values
% that will be assessed for the outer
% cylindrical surface of the Busemann
% toroid ;
%
% emissivity_inlet
% = the scaling factor that represents the extent to
% which the inlet resembles a true blackbody (in the
% range from 0 to 1) ;
%
% emissivity_nozzle
% = the scaling factor that represents the extent to
% which the nozzle resembles a true blackbody (in the
% range from 0 to 1) ;
%
% emissivity_cylinder
% = the scaling factor that represents the extent to
% which the cylinder resembles a true blackbody (in
% the range from 0 to 1) ;
%
% and
%
% plot_Busemann_toroid = the truth value of whether or not this
% routine should plot the Busemann
% toroid's surfaces (1 = yes, 0 = no).
%
% Usage:
%
% [diagonal_length_of_leading_cone,diagonal_length_of_frustum,cone_full_angle,...
% emissivity_inlet,x_inlet_mat,y_inlet_mat,z_inlet_mat,...
% emissivity_nozzle,x_nozzle_mat,y_nozzle_mat,z_nozzle_mat,...
% emissivity_cylinder,x_cylinder_mat,y_cylinder_mat,z_cylinder_mat,...
% phi_cylinder_mat] =...
% Busemann_toroid_7(r_inlet,r_throat,l_Busemann_toroid,...
% num_r_inlet_cone,phi_num_inlet,...
% phi_num_cylinder,h_num_cylinder,...
% emissivity_inlet,emissivity_nozzle,emissivity_cylinder,...
% plot_Busemann_toroid) ;

% PROGRAMMING NOTES
%
% Emissivity terms for the three surfaces have been explicitly
% added as input. They are directly returned with the
% meshgrids for the corresponding surfaces. This is being done to
% facilitate integration of the routine's data with the Daun algorithm
% code.

% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
%
% Construct Inlet Frustum
%
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

% Construct the inlet frustum in spherical coordinates.
% Since the frustum is a segment of a conical surface, and physics
% conventions are used to describe this system:
% a) the r value will be stepped through a series of values:
% b) the theta value (angle from the z-axis) is defined by the cone's
% angle, and is thus constant; and
% c) the phi value (rotation in the xy-plane) ranges from 0 to 2*pi.

theta = atan( (r_inlet-r_throat) / (l_Busemann_toroid/2) ) ;

% Calculate and return the parameters required by C111a.

cone_full_angle = 2 * theta ;

diagonal_length_of_frustum = sec(theta) * (l_Busemann_toroid/2) ;

full_diagonal_length_of_cone = csc(theta) * r_inlet ;

diagonal_length_of_leading_cone = full_diagonal_length_of_cone - diagonal_length_of_frustum ;

theta_el = pi/2 - theta ;

r_inlet_cone_min = r_throat * (1/sin(theta)) ;

r_inlet_cone_max = r_inlet * (1/sin(theta)) ;

r_inlet_cone_vec = r_inlet_cone_min : (r_inlet_cone_max-r_inlet_cone_min) / (num_r_inlet_cone-1) : r_inlet_cone_max ;


phi_inlet_vec = 0: (2*pi) / (phi_num_inlet-1) : 2*pi ;

[r_inlet_cone_mat,phi_mat] = meshgrid(r_inlet_cone_vec,phi_inlet_vec) ;

theta_el_mat = theta_el .* ones(size(r_inlet_cone_mat)) ;

% Transform the inlet frustum coordinates into Cartesian coordinates.

[x_inlet_mat,y_inlet_mat,z_inlet_mat] = sph2cart(phi_mat,theta_el_mat,r_inlet_cone_mat) ;

% Translate the inlet frustum, collinear with the z-axis, so that the plane
% of the throat intersects the origin.

z_inlet_mat = z_inlet_mat - (r_throat/tan(theta)) ;

% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
%
% Construct Nozzle Frustum
%
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

% Generate the nozzle coordinates by reflecting the inlet frustum through
% the xy-plane.

x_nozzle_mat = x_inlet_mat ;
y_nozzle_mat = y_inlet_mat ;
z_nozzle_mat = -z_inlet_mat ;

% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%
% Construct Cylinder
%
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

% Construct the outer radiative surface in cylindrical coordinates.

phi_cylinder_vec = 0: (2*pi) / (phi_num_cylinder-1) : 2*pi ;

h_cylinder_vec = -l_Busemann_toroid/2: l_Busemann_toroid / (h_num_cylinder - 1): l_Busemann_toroid/2 ;

[phi_cylinder_mat,h_mat] = meshgrid(phi_cylinder_vec,h_cylinder_vec) ;

r_cylinder_mat = r_inlet * ones(size(phi_cylinder_mat)) ;

% Transform the outer surface's coordinates into Cartesian coordinates.

[x_cylinder_mat,y_cylinder_mat,z_cylinder_mat] = pol2cart(phi_cylinder_mat,r_cylinder_mat, h_mat) ;

% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
%
% Plot Surfaces If Asked
%
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

if plot_Busemann_toroid == 1

figure

surf(x_inlet_mat,y_inlet_mat,z_inlet_mat, 'EdgeColor' ,'flat')

hold on

axis equal

surf(x_nozzle_mat,y_nozzle_mat,z_nozzle_mat, 'EdgeColor' ,'flat')

surf(x_cylinder_mat,y_cylinder_mat,z_cylinder_mat, 'EdgeColor' ,'flat')

cva = camva ;

camva(0.8*cva) ;

camva( 'manual')

xlabel( 'x axis')
ylabel( 'y axis')
zlabel( 'z axis')

else
end

end
