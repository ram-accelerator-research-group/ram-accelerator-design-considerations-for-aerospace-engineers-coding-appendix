function [h_cone,integrated_torque_vec] = ...
integrated_torque_on_frustum_as_fxn_of_z_offset(z_offset_vec, ...
r_inlet,r_throat,l_inlet, ...
dynamic_pressure)
%
% Usage: Note that in this function, n_theta must be set manually inside
% the function itself.
%
% [h_cone,integrated_torque_vec] = ...
% integrated_torque_on_frustum_as_fxn_of_z_offset(z_offset_vec,...
% r_inlet,r_throat,l_inlet,...
% dynamic_pressure) ;

theta_cone_half_angle = atan( (r_inlet-r_throat) / l_inlet ) ;

h_cone = r_inlet * cot(theta_cone_half_angle) ;

theta_min_vec = atan(r_throat./(l_inlet+z_offset_vec)) ;

theta_max_vec = atan(r_inlet./(z_offset_vec)) ;

integral_1_vec = zeros(1,max(size(z_offset_vec))) ;

integral_2_vec = zeros(1,max(size(z_offset_vec))) ;

n_theta = 100 ;

for integral_itr = 1:1:max(size(z_offset_vec))

theta_vec = theta_min_vec(1,integral_itr) : ((theta_max_vec(1,integral_itr))- theta_min_vec (1,integral_itr))/(n_theta - 1) : theta_max_vec(1,integral_itr) ;


pre_integral_1_vec = ((sin(theta_vec).*cos(theta_vec))./((sin (theta_vec+theta_cone_half_angle)).^3)) ;

integral_1_vec(1,integral_itr) = trapz(theta_vec,pre_integral_1_vec) ;


pre_integral_2_vec = ((sin(theta_vec).*sin(theta_vec))./((sin (theta_vec+theta_cone_half_angle)).^3)) ;

integral_2_vec(1,integral_itr) = trapz(theta_vec,pre_integral_2_vec) ;

end

integral_term_1_vec = cos(theta_cone_half_angle) .* integral_1_vec ;

integral_term_2_vec = -sin(theta_cone_half_angle) .* integral_2_vec ;

integrated_torque_vec = ( 4 * pi * dynamic_pressure * ((sin(theta_cone_half_angle))^5) ) * ( (z_offset_vec+h_cone) .^3 ) .* ( integral_term_1_vec + integral_term_2_vec ) ;

end
