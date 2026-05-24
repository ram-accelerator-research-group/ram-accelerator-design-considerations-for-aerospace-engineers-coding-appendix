function [T_inf_vec,P_inf_vec,v_vehicle_vec] = const_mass_flux_flight_profile_2(alt_vec, intake_area,air_mass_flux)
%
% The purpose of this function is to calculate an air-breathing vehicle's
% speeds as a function of altitude, as the vehicle climbs hhigher and
% higher.
%
% Consider the case of an air-breathing vehicle ascending through Earth's
% atmosphere. The vehicle is adjusting its speed, as it ascends, so that
% the inlets of the vehicle's jet engines--which are assumed to have a
% constant, unvarying area--will ingest an unchanging mass of air each
% second.
%
% In other words, as the vehicle reaches higher altitudes, where the air
% density becomes lower, the vehicle will have to fly at a higher
% absolute speed to endure that the mass flux of air at the inlet remains
% constant.
%
% The input terms are
% alt_vec = ; intake_area = ; air_mass_flux = ;
%
% where
%
% alt_vec = the vector of altitudes, in m, that the flight
% vehicle is to traverse:
%
% intake_area = the fixed intake area, in m^2, that the flight
% vehicle has overall;
%
% and
%
% air_mass_flux = the fixed rate of air intake, in kg / s, that
% the flight vehicle is to sustain.
%
% Usage:
%
% [T_inf_vec,P_inf_vec,v_vehicle_vec] = ...
% const_mass_flux_flight_profile_2(alt_vec,intake_area,air_mass_flux) ;


% PROGRAMMING NOTES
%
% This function calls the non-MATLAB subroutines
% TempAltCS6
% BarForm2

% Generate the vector of temperature values for freestream air, at all the
% altitudes being traversed by the flight vehicle.

T_inf_vec = TempAltCS6( alt_vec );

% Generate the vector of pressure values for freestream air, at all the
% altitudes being traversed by the flight vehicle.

P_inf_vec = BarForm2( alt_vec );

% Using these values, generate the freestream air densities at all of the
% altitudes the vehicle flies at. This will be done using an ideal gas
% approximation.

mM_air = 0.0289644 ;
R = 8.314472 ; % units of ( m^3 * Pa ) / ( K * mol )

rho_inf_vec = (mM_air.*P_inf_vec)./(R.*T_inf_vec) ;

% Using these densities as a function of altitude, calculate the
% corresponding vehicle speeds.

v_vehicle_vec = air_mass_flux ./ (rho_inf_vec * intake_area) ;

end
