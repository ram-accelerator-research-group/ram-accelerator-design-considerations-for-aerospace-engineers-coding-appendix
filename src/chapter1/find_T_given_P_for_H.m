function [H_vec,P_vec,T_mat] ...
= find_T_given_P_for_H(H_min,H_max,num_H, ...
P_min,P_max,num_P)
%
% This function takes, as input, a series of enthalpies and pressures
% of dry air.
% It will then return, as output, the temperatures that
% correspond to each combination of enthalpy and pressure.
%
% The input terms are
% H_min = ; H_max = ; num_H = ;
% P_min = ; P_max = ; num_P = ;
% where
%
% H_min = the minimum enthalpy (in J/kg) that the dry air will
% experience;
%
% H_max = the maximum enthalpy (in J/kg) that the dry air will
% experience;
%
% num_H = the number of enthalpy values that will be examined for
% dry air, over the range from H_min to H_max;
%
% P_min = the minimum pressure (in kPa) that the dry air will
% experience;
%
% P_max = the maximum pressure (in kPa) that the dry air will
% experience;
%
% num_P = the number of pressure values that will be examined for
% dry air, over the range from P_min to P_max.
%
% The output terms are
% [H_vec,P_vec,T_mat]
% where
%
% H_vec = a column vector containing the specified enthalpy values;
%
% P_vec = a row vector containing the specified pressure values;
%
% T_mat = a matrix where each row represents an enthalpy value,
% each column represents a pressure value, and each
% (row,column) entry represents the corresponding
% absolute temperature of dry air in K.
%
% Usage:
%
% [H_vec,P_vec,T_mat] ...
% = find_T_given_P_for_H(H_min,H_max,num_H,...
% P_min,P_max,num_P);

H_vec = H_min:(H_max - H_min)/(num_H-1):H_max ;

H_vec = H_vec' ;

P_vec = P_min:(P_max - P_min)/(num_P-1):P_max ;

T_mat = zeros(num_H,num_P) ;

% For each enthalpy...
for H_itr = 1:1:num_H
% ...iterate across the range of pressures.
for P_itr = 1:1:num_P
% Find the temperature that corresponds to the current enthalpy at
% the current pressure. Enter that value into the temperature
% matrix.

T_mat(H_itr,P_itr) = T_mat(H_itr,P_itr) + refpropm( 'T','H',H_vec(H_itr,1), 'P',P_vec(1, P_itr),'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]) ;

end
end

end
