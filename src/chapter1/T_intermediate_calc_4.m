function [H_air_init_vec, ...
H_N2_init_vec,T_N2_init_vec, ...
T_intermediate_vec,delta_H_air_precooled_vec] = ...
T_intermediate_calc_4(T_air_init_vec,P_air_init_vec)
%
% This function is meant to answer the following question, which is a key
% to the understanding of air-collection and enrichment (ACES) propulsion
% systems in flight vehicles:
%
% Suppose I have 1 kilogram of gaseous air at some combination of
% pressure and temperature. I then transfer enthalpy from it to 0.7557 kg
% of nitrogen at that same pressure, using a counterflow heat exchanger.
% (NOTE: 1 kilogram of air contains 0.7557 kg of N2, which is the origin
% of this number.)
%
% The nitrogen starts out at its vapor saturation temperature, and ends
% up at the air's initial temperature (again, all without the pressure
% changing).
%
% Under these circumstances, what is the final temperature of the 1 kg of
% air?
%
% The input terms are
% T_air_init_vec = ; P_air_init_vec = ;
%
% where
%
% T_air_init_vec = the vector of initial temperatures, in Kelvin,
% for the 1 kilogram of air as it enters the
% counterflow heat exchanger;
%
% and
%
% P_air_init_vec = the vector of initial pressures, in kPa,
% for the 1 kilogram of air as it enters the
% counterflow heat exchanger.
%
% The output terms are
% delta_H_air_precooled_vec,T_intermediate_vec
%
% where
%
% delta_H_air_precooled_vec = the vector of the enthalpy changes,
% in J, experienced by 1 kilogram of
% air as it is sent through the
% counterflow heat exchanger;
%
% and
%
% T_intermediate_vec = the vector of final temperatures,
% in Kelvin, 1 kilogram of air will
% have after being passed through the
% counterflow heat exchanger.
%
% Usage:
%
% [H_air_init_vec,...
% H_N2_init_vec,T_N2_init_vec,...
% T_intermediate_vec,delta_H_air_precooled_vec] = ...
% T_intermediate_calc_4(T_air_init_vec,P_air_init_vec) ;

% PROGRAMMING NOTES
%
% ------------------------Development History------------------------------
% This code is designed to remove subcooled (negative enthalpy) values for
% gaseous nitrogen, but ONLY at subcritical pressures. For pressures at or
% above critical, negative enthalpy values for supercritical fluid nitrogen
% are considered valid, and are retained.
%
% -------------------------Subroutines Called------------------------------
% This function calls the following non-MATLAB subroutine:
% refpropm
% Make sure to set your REFPROP directory at line 97.

% Validate the input vector sizes before proceeding further.

if max(size(T_air_init_vec))~=max(size(P_air_init_vec))
error( 'The air temperature and air pressure vectors must have the same length.' )
else
end

T_N2_init_vec = zeros(1,max(size(T_air_init_vec))) ;

H_N2_init_vec = zeros(1,max(size(T_air_init_vec))) ;

T_intermediate_vec = zeros(1,max(size(T_air_init_vec))) ;

H_air_init_vec = zeros(1,max(size(T_air_init_vec))) ;

delta_H_air_precooled_vec = zeros(1,max(size(T_air_init_vec))) ;

% Make a note of the current directory, then move to the REFPROP directory
% for the following calculations.

WD = pwd ;

cd('C:\Program Files (x86)\REFPROP' ) ;

is_pressure_subcritical = zeros(1,max(size(T_air_init_vec))) ;

% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
%
% Get Initial Enthalpies
%
% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

% For each (T_air_init,P_air_init) combination...

for air_itr = 1:1:max(size(T_air_init_vec))

%air_itr = air_itr

% Determine the inital enthalpic content of the 1 kg of air.

H_air_init = refpropm( 'H','T',T_air_init_vec(1,air_itr), 'P',P_air_init_vec(1, air_itr), 'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]) ;

H_air_init_vec(1,air_itr) = H_air_init_vec(1,air_itr) + H_air_init ;
% Checks out to this point

% Determine the enthalpic content of 1 kg of N2 at P_air_init, whether
% it is subcritical gas or a supercritical fluid.

P_critical_N2 = refpropm( 'P','C',0,' ',0,'nitrogen' );

% If the pressure is below the critical pressure of nitrogen...

if P_air_init_vec(1,air_itr) < P_critical_N2

is_pressure_subcritical(1,air_itr) = is_pressure_subcritical(1,air_itr) + 1 ;

% ...use a quality = 1 call to REFPROP to determine the temperature of
% the saturated nitrogen vapor.
T_N2_fluid = refpropm( 'T','P',P_air_init_vec(1,air_itr), 'Q',1,'nitrogen' ) ;
% Otherwise...
else
% ...make a C = 0 call to REFPROP to determine the temperature of the
% supercritical fluid nitrogen.
% NOTE: we assume that this temperature is the critical-point
% temperature of nitrogen; this is the lowest temperature that will
% still prevent liquid formation at pressures above Pcritical.

%T_N2_fluid = refpropm('T','P',P_air_init_vec(1,air_itr),'nitrogen') ;
T_N2_fluid = refpropm( 'T','C',0,'P',P_air_init_vec(1,air_itr), 'nitrogen' ) ;

end

T_N2_init_vec(1,air_itr) = T_N2_init_vec(1,air_itr) + T_N2_fluid ;
% Checks out to this point

% Perform data validation on the temperature before proceeding.

if T_air_init_vec(1,air_itr) <= T_N2_fluid
cd(WD) ;
error( 'All air temperatures must be greater than the saturated vapor temperature for nitrogen.' )
else
end

H_N2_init = refpropm( 'H','T',T_N2_fluid, 'P',P_air_init_vec(1,air_itr), 'nitrogen' ) ;

H_N2_init_vec(1,air_itr) = H_N2_init_vec(1,air_itr) + H_N2_init ;

end

% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
%
% Reject Subcooled Enthalpies
%
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

% Remove subcooled enthalpy values for nitrogen gas entering the
% precooler, if--and only if--its pressure is subcritical.

% First, extract all the indices for the subcritical nitrogen values...

subcritical_ind_vec = find( is_pressure_subcritical > 0 ) ;

% ...then, extract all the indices for the supercritical nitrogen values.

supercritical_ind_vec = find( is_pressure_subcritical < 1 ) ;

% Process the subcritical nitrogen values to retain only the superheated
% enthalpy values.

H_N2_init_subcritical_vec = H_N2_init_vec(subcritical_ind_vec) ;

[~,pos_ind_vec] = find(H_N2_init_subcritical_vec > 0) ;

H_N2_init_superheated_subcritical_vec = H_N2_init_subcritical_vec(1,pos_ind_vec) ;

% Perform a pchip spline on these subcritical nitrogen values, to fill in
% the gaps that have been created by throwing out the subcooled nitrogen
% enthalpies.

H_N2_init_subcritical_vec = pchip(pos_ind_vec,H_N2_init_superheated_subcritical_vec, subcritical_ind_vec) ;

% Extract all supercritical nitrogen enthalpies.

H_N2_init_supercritical_vec = H_N2_init_vec(supercritical_ind_vec) ;

% Merge the subcritical and supercritical enthalpies to make the corrected
% vector of initial enthalpies for the nitrogen entering the precooler.

H_N2_init_vec = horzcat(H_N2_init_subcritical_vec,H_N2_init_supercritical_vec) ;

% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
%
% Find Enthalpy Changes And Final Air Temperature
%
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

for air_itr = 1:1:max(size(T_air_init_vec))

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Nitrogen Enthalpy Changes
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Determine the enthalpic content of 1 kg of N2 at
% (T_air_init,P_air_init).

H_N2_final = refpropm( 'H','T',T_air_init_vec(1,air_itr), 'P',P_air_init_vec(1, air_itr), 'nitrogen' ) ;

% Find the difference between these two enthalpic contents of 1 kg of
% N2...

H_N2_init = H_N2_init_vec(1,air_itr) ;

delta_H_per_kg_N2 = H_N2_final - H_N2_init ;

% ...then rescale this by a factor of 0.7557 to get the enthalpic
% change of the amount of nitrogen that was actually used.

delta_H_for_N2_in_air = delta_H_per_kg_N2 * 0.7557 ;

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Air Enthalpy Change and Overall Enthalpies
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% This last enthalpic change for nitrogen must be equal in size, but
% opposite in sign, to the change in enthalpy of the 1 kg of air, given
% a completely efficient heat exchanger.

delta_H_for_air = delta_H_air_precooled_vec(1,air_itr) - delta_H_for_N2_in_air ;

delta_H_air_precooled_vec(1,air_itr) = delta_H_air_precooled_vec(1,air_itr) + delta_H_for_air ;

% Calculate the final enthalpy of the 1 kg of air...

H_air_init = H_air_init_vec(1,air_itr) ;

H_air_final = H_air_init + delta_H_for_air ;

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Final Air Temperature
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% ...and use this to calculate the corresponding T_intermediate of the air.

T_intermediate_vec(1,air_itr) = T_intermediate_vec(1,air_itr) + refpropm( 'T','H', H_air_final, 'P',P_air_init_vec(1,air_itr), 'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]) ;

end

% Return to the original directory.

cd(WD) ;

end
