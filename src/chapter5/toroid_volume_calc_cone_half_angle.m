function [ toroid_volume ] = toroid_volume_calc_cone_half_angle(inlet_size,throat_size, theta_cone_half_angle)
%
% Usage:
%
% toroid_volume_calc_cone_half_angle(inlet_size,throat_size,theta_cone_half_angle)
%

y = (inlet_size/2) - (throat_size/2);
x = y/tan(deg2rad(theta_cone_half_angle));

H = 2 * x;
h= H/2;
R = inlet_size/2;
r = throat_size/2;

%find volume of a frustum
V_frustum = ((pi*h)/3)*(R^2 + (R*r) + r^2);

%find volume of cylinder
V_cylinder = pi*(R^2)*H;

toroid_volume = V_cylinder-(2*V_frustum);

end
