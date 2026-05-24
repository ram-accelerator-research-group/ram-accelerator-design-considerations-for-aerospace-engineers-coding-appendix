function [prob_vx_vec] = Maxwell_Boltzmann_1D_molar_mass_abs_temp_vx_vec(molar_mass,abs_temp, vx_vec)
%
% The purpose of this function is to calculate, for a gas with a given
% molar mass and Kelvin temperature, the probability distribution of a
% given range of x-direction-velocities of its particles. Note that the
% gas_constant is at like 33.
%
% Input terms:
%
% molar_mass,abs_temp,vx_vec
%
% where
%
% molar_mass = the average molar mass of the gas, in kg/mol ;
%
% abs_temp = the absolute temperature of the gas, in Kelvin ;
%
% and
%
% vx_vec = the vector of velocities of the gas particles, in
% m/s.
%
% Usage:
%
% [prob_vx_vec] = Maxwell_Boltzmann_1D_corr(molar_mass,abs_temp,vx_vec) ;

% PROGRAMMING NOTES
%
% Changing the inputs of this function to match the fuel-oxidizer-diluent
% mixtures in different sections of a ram accelerator will demonstrate how
% the projectile velocity will increase as it moves down the bore.

gas_constant = 8.31447 ; % m^3 Pa mol^-1 K^-1

factor = ( molar_mass / (2*pi*gas_constant*abs_temp) )^(3/2) ;

exp_power_vec = -( molar_mass .* (vx_vec.^2) ) / ( 2* gas_constant * abs_temp ) ;

prob_vx_vec = 4 * pi * factor .* (vx_vec.^2) .* exp(exp_power_vec) ;

end
