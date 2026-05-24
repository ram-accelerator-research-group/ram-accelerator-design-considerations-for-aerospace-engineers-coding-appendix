function [length_of_barrel] = ...
PPIG_gun_barrel_length(projectile_mass,projectile_velocity,projectile_area, ...
pressure,speed_of_sound,gamma)
%
% This routine solves the preburned-propellant-ideal-gas-gun barrel
% length equation (12-1) in Arnold E. Seigel, _The Theory of High-Speed
% Guns_: AGARD / NATO, May 1965, p. 21. This is how we calculate the
% length of the prelauncher in ram accelerator.
%
% Usage:
%
% [length_of_barrel] = ...
% PPIG_gun_barrel_length(projectile_mass,projectile_velocity,projectile_area,...
% pressure,speed_of_sound, gamma)

pressure = pressure

speed_of_sound = speed_of_sound

gamma = gamma

term_1 = ( projectile_mass * (speed_of_sound^2) ) / ( pressure * projectile_area ) ;

term_2 = 2 / (gamma + 1) ;

term_3_num = (2 / (gamma - 1) ) - (((gamma+1)/(gamma-1))*( 1 - ((projectile_velocity* (gamma-1))/(2*speed_of_sound)) ) ) ;

term_3_den = ( 1 - ((projectile_velocity*(gamma-1))/(2*speed_of_sound)) ) ^ ( (gamma+1) / (gamma-1) ) ;

term_3 = ( term_3_num / term_3_den ) + 1 ;

length_of_barrel = term_1 * term_2 * term_3;

end
