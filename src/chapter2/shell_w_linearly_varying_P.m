function [u_proj_vec] = shell_w_linearly_varying_P(pressure_1,velocity_1, ...
pressure_2,velocity_2, ...
shell_mass,shell_area, ...
t_vec)
% Usage:
%
% [u_proj_vec] = shell_w_linearly_varying_P(pressure_1,velocity_1,...
% pressure_2,velocity_2,...
% shell_mass,shell_area,...
% t_vec)
%
% This is how we calculate the section lengths of the barrels
% of a ram accelerator in thermally choked mode and
% oblique detonation mode.
%

m_slope = (pressure_2-pressure_1) / (velocity_2-velocity_1) ;

b = pressure_1 - ( m_slope * velocity_1 ) ;

constant = velocity_1 + ( b / m_slope ) ;

area_over_mass = shell_area / shell_mass ;

u_proj_vec = -( b / m_slope ) + ( constant .* exp(area_over_mass*m_slope.*t_vec) ) ;

end
