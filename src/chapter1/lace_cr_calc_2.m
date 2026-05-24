function [v_vehicle_vec,Mach_num_vec, ...
P_stag_vec,T_stag_vec, ...
condensation_ratio_vec] = lace_cr_calc_2(alt_vec,intake_area,air_mass_flux)
%
% This function is meant to calculate the performance of an air
% collection and enrichment (ACES) system, within a flight vehicle, over
% a series of altitudes and speeds.
%
% An ACES system functions in the following manner:
% 1) Intake air flows through a first heat exchanger, where it is
% precooled by nitrogen gas.
% 2) This precooled air flows into a second heat exchanger, where it
% is further cooled and liquefied by parahydrogen.
% 3) The liquefied air is separated into its nitrogen and oxygen
% components.
% 4) The oxygen component of the air, along with the parahydrogen
% from step 2), is sent to a rocket engine and burned.
% 5) The nitrogen component of the air is sent through the first
% heat exchanger, then dumped overboard.
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
% The output terms are
%
% v_vehicle_vec = the vector of absolute vehicle speeds,
% in meters per second, required to
% maintain a constant mass flux of intake
% air across the specified altitudes;
%
% Mach_num_vec = the vector of corresponding Mach
% numbers experienced by the vehicle;
%
% P_stag_vec = the vector of stagnation pressures, in
% Pa, experienced by the vehicle during
% its flight;
%
% T_stag_vec = the vector of stagnation temperatures,
% in Kelvin, experienced by the vehicle
% during its flight;
%
% T_intermediate_vec = the vector of "intermediate"
% temperatures, in Kelvin, the intake air
% will have after being passed through
% the first, air-to-nitrogen counterflow
% heat exchanger;
%
% and
%
% condensation_ratio_vec = the vector of condensation ratios
% for each set of flight conditions.
% NOTE: condensation ratio is defined as
% the kilograms of air liquefied, over
% the kilograms of parahydrogen used to
% liquefy that air,
%
%
% Usage:
%
% [v_vehicle_vec,Mach_num_vec,...
% P_stag_vec,T_stag_vec,...
% condensation_ratio_vec] = lace_cr_calc_2(alt_vec,intake_area,air_mass_flux)

% PROGRAMMING NOTES
%
% This routine calls the following non-MATLAB subroutines directly:
% const_mass_flux_flight_profile_2
% MachCalc3
% StagTemp
% StagPress
% liquefy_air
% integrate_paraH2_Pcrit_Cp_2
%
% In addition, the subroutine refpropm is called indirectly, as the above
% subroutines make calls to REFPROP.

% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
%
% Calculate Properties of Intake Air
%
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

% Start by entering phyical properties for air.
% Note: for dry air...
% Mass Fractions
% nitrogen = 0.7557
% argon = 0.012700
% oxygen = 0.2316
%
% Mole Fractions
% nitrogen = 0.7812
% argon = 0.0092065
% oxygen = 0.2096

gamma = 1.4 ; %air

% For each altitude the vehicle is to fly within, calculate the absolute
% velocity needed to ensure the correct mass flux, along with the
% freestream air opressures and temperatures that correspond to these
% altitudes.

[T_inf_vec,P_inf_vec,v_vehicle_vec] = const_mass_flux_flight_profile_2(alt_vec,intake_area, air_mass_flux) ;

disp( ' ')
disp( 'Flight profile calculations done' )

% Calculate the corresponding Mach numbers.

[ Mach_num_vec ] = MachCalc3( v_vehicle_vec,alt_vec ) ;

disp( ' ')
disp( 'Mach Number calculations done' )

% Calculate the corresponding stagnation temperatures and pressures.

[ T_stag_vec ] = StagTemp( T_inf_vec,gamma,Mach_num_vec ) ;

T_air_init_vec = T_stag_vec ;

[ P_stag_vec ] = StagPress( P_inf_vec,gamma,Mach_num_vec) ;

disp( ' ')
disp( 'Stagnation calculations done' )

% Since the pressures from the previous routines are returned in terms of
% Pa, they need to be converted to kPa to work in the following routines
% (since they will call REFPROP via refpropm, which needs pressures to be
% in units of kPa).

P_air_init_vec = P_stag_vec / 1000 ;

% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
%
% Precool and Liquefy Air
%
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

% For 1 kg of air at stagnation pressure and temperature, calculate how
% much enthalpy change will be required to further cool that air to its
% saturated vapor temperature, then liquefy it.

[delta_H_to_liquefy_intake_air_vec] = liquefy_air(T_air_init_vec,P_air_init_vec) ;

disp( ' ')
disp( 'Air liquefaction calculations done' )

% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
% 2222222222222222222222222222222222222222222222222222222222222222222222222
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
%
% Calculate Para-H2 Requirements
%
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
% 2222222222222222222222222222222222222222222222222222222222222222222222222
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR

% Calculate how many kilograms of parahydrogen, at its critical pressure,
% would be required to absorb that change in enthalpy.
% NOTE: since the Cp of parahydrogen varies widely over its temperature
% range, a numerical integration is required to get this number.

% First, calculate the change in the enthalpy of 1 kg of parahydrogen at
% its critical pressure, as the parahydrogen is warmed from its critical
% temperature to the temperature of the stagnated intake air.

T_offset = 1 ;

[delta_H_paraH2_Pcrit_vec] = integrate_paraH2_Pcrit_Cp_2(T_air_init_vec,T_offset) ;

disp( ' ')
disp( 'Integration of para-H2 Cp over air T range done' )

% To find how many kilograms of parahydrogen will actually be needed, take
% the absolute value of the enthalpy change 1 kg of precooled air has to
% undergo to get liquefied in the air heat exchanger, then divide that by
% the absolute value of the enthalpy change 1 kg of the parahydrogen will
% experience over the temperature range of the heat exchanger.
%
% EXAMPLE: if 1 kg of air needs to lose 40,000 J of enthalpy to get
% liquefied within the air-parahydrogen heat exchanger, and 1 kg of para-
% hydrogen will absorb 200,000 J of enthalpy over the temperature range of
% that same heat exchanger, it follows that
%
% 40,000 / 200,000 = 0.20000
%
% kg of parahydrogen would be needed to accomplish this process.

mass_paraH2_vec = abs(delta_H_to_liquefy_intake_air_vec) ./ abs(delta_H_paraH2_Pcrit_vec) ;

% Calculate the corresponding condensation ratio.

condensation_ratio_vec = 1./mass_paraH2_vec ;

end
