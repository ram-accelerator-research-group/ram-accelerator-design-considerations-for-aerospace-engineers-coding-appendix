function [Cp_paraH2_vec,delta_H_paraH2_Pcrit_vec] = integrate_paraH2_Pcrit_Cp_3(T_higher_vec, T_offset)
%
% This routine is meant to answer the following question:
% 1 kilogram of parahydrogen is initially at its critical temperature and
% pressure. It is then warmed up to some higher temperature, while being
% maintained at its critical pressure. How much enthalpy does it absorb
% during this process?
%
% The input terms are
% T_higher_vec = ; T_offset = ;
%
% where
%
% T_higher_vec = the vector of "final" temperatures, in Kelvin,
% the critical parahydrogen will be warmed up to.
%
% The output terms are
%
% Cp_paraH2_vec = the vector of Cp values the
% critical parahydrogen takes, as it
% is warmed up from its initial
% (critical) temperature to its final
% temperature.
%
% delta_H_paraH2_Pcrit_vec = the vector of Cp values the
% critical parahydrogen takes, as it
% is warmed up from its initial
% (critical) temperature to its final
% temperature.
%
% Usage:
% [Cp_paraH2_vec,delta_H_paraH2_Pcrit_vec] = integrate_paraH2_Pcrit_Cp_3(T_higher_vec, T_offset) ;
%
% PROGRAMMING NOTES
%
% This routine makes calls to the following non-MATLAB routine:
% refpropm

% Make a note of the current directory, then move to the REFPROP directory
% for the following calculations.

WD = pwd ;

cd('C:\Program Files (x86)\REFPROP' ) ;

% Break the integration range for each run down into a constant number of
% temperature divisions.

num_divisions = 100 ;

% Retrieve the critical temperature and pressure for parahydrogen.

%T_offset = 0 ;

T_critical = refpropm( 'T','C',0,' ',0,'parahyd' ) + T_offset ;

P_critical = refpropm( 'P','C',0,' ',0,'parahyd' ) ;

% Perform data validation on the temperatures.

for T_itr = 1:1:max(size(T_higher_vec))
if T_higher_vec(1,T_itr) <= T_critical
cd(WD) ;
error( 'All input temperatures must be greater than T_critical for parahydrogen.' )
else
end
end

delta_H_paraH2_Pcrit_vec = zeros(1,max(size(T_higher_vec))) ;

%figure
%hold on
%grid
%xlabel('Integration Range Temperature (K)')
%ylabel('Cp (J/(kg K))')

% For each "higher" temperature being investigated...
for T_itr = 1:1:max(size(T_higher_vec))

% Generate a vector of temperatures from T_critical to T_higher.

%T_critical = T_critical + 1 ;

T_higher = T_higher_vec(1,T_itr) ;
T_integral_vec = T_critical: (T_higher - T_critical)/(num_divisions - 1) : T_higher ;

% For each one of these temperatures, return the Cp of parahydrogen.

Cp_paraH2_vec = zeros(1,num_divisions) ;

for Cp_itr = 1:1:num_divisions
Cp_paraH2_vec(1,Cp_itr) = Cp_paraH2_vec(1,Cp_itr) + refpropm( 'C','T',T_integral_vec (1,Cp_itr), 'P',P_critical, 'parahyd' );
end

%plot(T_integral_vec,Cp_paraH2_vec)

% Integrate the Cp values over the specified temperature range. This
% will yield the change in enthalpy.

delta_H_paraH2_Pcrit_vec(1,T_itr) = delta_H_paraH2_Pcrit_vec(1,T_itr) + trapz (T_integral_vec,Cp_paraH2_vec) ;

end

%hold off

% Return to the original directory.

cd(WD) ;

end
