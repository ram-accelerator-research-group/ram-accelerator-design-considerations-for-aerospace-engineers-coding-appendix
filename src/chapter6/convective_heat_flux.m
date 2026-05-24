function [heat_flux_at_wall] = ...
convective_heat_flux(velocity, ...
enthalpy_gas_static,density_gas,pressure_at_wall,gamma, ...
T_avg_freestream,T_wall)
%
% The purpose of this function is to implement D. W. Bogdanoff's
% convective-heat-transfer calculation formula from Appendix A of the
% paper
% "Strategies to protect ram accelerator projectiles from in-tube
% gasdynamic heating," J. Phys. IV France, v. 10 (2000), pp. 9-10.
%
% Usage:
%
% [heat_flux_at_wall] = ...
% convective_heat_flux(velocity,...
% enthalpy_gas_static,density_gas,pressure_at_wall,gamma,...
% T_avg_freestream,T_wall)

%length = sqrt( ((1/3)^2) + ((4/5)^2) )

length = 0.0620 ;

molar_mass_mixture = ( ((8*2.01588) + (1*31.9988)) / 9 ) * (1/1000) ;

R = 8.3145 ; % J mol^-1 K^-1

speed_of_sound = sqrt(R * T_avg_freestream * gamma / molar_mass_mixture ) ;

Mach_num = velocity / speed_of_sound ;

% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
%
% Calculate Viscosity
%
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

% golubev, viscosities of gases and gas mixtures, p. 62

% viscosity of H2 at 25 C: 890 (10^-7) g cm^-1 s^-1

% Viscosity of O2 at 25 C: 2052 (10^-7) g cm^-1 s^-1

viscosity_H2 = 890e-8 % kg m^-1 s^-1

viscosity_O2 = 2052e-8 % kg m^-1 s^-1

viscosity_mixture = ((8*viscosity_H2)+viscosity_O2) / 9 ;

% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
%
% Find Reference Properties
%
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

T_reference = ( 0.9 * T_avg_freestream ) + ( 0.03 * Mach_num ) + ( 0.1 * T_wall ) ;

% The calculation of viscosity comes from Lapin, p. 118, eq. 3.61

viscosity_reference = viscosity_mixture * (T_reference/T_avg_freestream)^0.76 ;

%density_reference = molar_mass_mixture * pressure_at_wall / (R * T_reference) ;

density_reference = density_gas * (T_avg_freestream/T_reference) ;

Reynolds_num_reference = density_reference * velocity * length / viscosity_reference ;

skin_friction_coefficient_reference = (2*log10(Reynolds_num_reference)) - 0.65 ;

density_point_2 = molar_mass_mixture * pressure_at_wall / ( R * T_wall )

%skin_friction_coefficient = skin_friction_coefficient_reference * (density_reference/density_gas) ; % NOTE: should divide by gas density at point 2

skin_friction_coefficient = skin_friction_coefficient_reference * (density_reference/density_point_2) ; % NOTE: should divide by gas density at point 2

% recovery factor from Shapiro vol. II, p.1123

recovery_factor = 0.89 ;

enthalpy_adiabatic_wall = enthalpy_gas_static * ( 1 + ( recovery_factor * ((gamma- 1)/2) .* (Mach_num.^2) ) ) ;

%term_1 = 0.5 * skin_friction_coefficient * density_gas .* velocity ; % NOTE: should use gas density at point 2

term_1 = 0.5 * skin_friction_coefficient * density_point_2 .* velocity ; % NOTE: should use gas density at point 2

term_2 = enthalpy_gas_static + ( recovery_factor .* ((velocity.^2)/2) ) - enthalpy_adiabatic_wall ;

heat_flux_at_wall = term_1 .* term_2 ;
end
