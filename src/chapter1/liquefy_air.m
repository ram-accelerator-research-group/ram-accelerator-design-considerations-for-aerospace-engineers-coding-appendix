function [delta_H_air_total_vec] = liquefy_air(T_air_init_vec,P_air_init_vec)
% The purpose of this routine is to answer the following question:
%
% Consider gaseous, dry air at some initial temperature and pressure.
% This air is then cooled, with its pressure held constant, until it
% liquefies completely. What enthalpy change must occur to make this
% happen?
%
% Usage:
% [delta_H_air_total_vec] = liquefy_air(T_air_init_vec,P_air_init_vec);

% PROGRAMMING NOTES
%
% This routine makes calls to the following non-MATLAB routine:
% refpropm
% Make sure to set your REFPROP directory at line 30.

% Validate the input before proceeding further.

if max(size(T_air_init_vec))~=max(size(P_air_init_vec))
error( 'The air temperature and air pressure vectors must have the same length.' )
else
end

% Make a note of the current directory, then move to the REFPROP directory
% for the following calculations.

WD = pwd ;

cd('C:\Program Files (x86)\REFPROP' ) ;

delta_H_air_total_vec = zeros(1,max(size(T_air_init_vec))) ;

for air_itr = 1:1:max(size(T_air_init_vec))

% Calculate the enthalpy change involved in going from the initial
% temperature of the gaseous air to its saturated vapor temperature.
% NOTES;
% 1) Enthalpy is given in units of J/kg.
% 2) Temperature is given in units of K.

H_air_init = refpropm( 'H','T',T_air_init_vec(1,air_itr), 'P',P_air_init_vec(1, air_itr), 'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]) ;

T_air_vapor_sat = refpropm( 'T','P',P_air_init_vec(1,air_itr), 'Q', 1,'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]) ;

H_air_vapor_sat = refpropm( 'H','T',T_air_vapor_sat, 'P',P_air_init_vec(1, air_itr), 'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]) ;

delta_H_cool_to_T_cond = H_air_vapor_sat - H_air_init ;

% Calculate the enthalpy change involved in going from air as saturated
% vapor to air that is 100% liquid.

H_air_liquid = refpropm( 'H','P',P_air_init_vec(1,air_itr), 'Q', 0,'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]) ;

delta_H_liquefaction = H_air_liquid - H_air_vapor_sat ;

% Using these figures, calculate the overall enthalpy change.

delta_H_air_total_vec(1,air_itr) = delta_H_air_total_vec(1,air_itr) + ( delta_H_cool_to_T_cond + delta_H_liquefaction ) ;

end

% Return to the original directory.

cd(WD) ;

end
