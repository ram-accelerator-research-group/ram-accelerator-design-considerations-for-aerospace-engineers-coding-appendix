function [ toroid_volume ] = toroid_volume_calc(inlet_size,throat_size,l_toroid)
%
% Usage:
% [ toroid_volume ] = toroid_volume_calc(inlet_size,throat_size,l_toroid)
%
%

H = l_toroid;
h= l_toroid/2;
R = inlet_size/2;
r = throat_size/2;

%find volume of a frustum
V_frustum = ((pi*h)/3)*(R^2 + (R*r) + r^2);

%find volume of cylinder
V_cylinder = pi*(R^2)*H;

toroid_volume = V_cylinder-(2*V_frustum);

end
