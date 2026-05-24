%adiabatic_flame_temperature_calc

% Step 1: Balance equation for products and reactants.

% Step 2: Hess's Law (rule of thumb)
% kJ/mol
deltaH_CO = -110.5233 ;
deltaH_CO2 = -393.509 ;
deltaH_H2O = -285.8 ;
deltaH_CH4 = -74.9 ;
deltaH_O2 = 0 ;
deltaH_H2 = 0 ;
deltaH_N2 = 0 ;

% Step 2: Apply Hess's Law.

deltaH_reaction_p = deltaH_CO2 + (2*deltaH_H2O)

deltaH_reaction_r = deltaH_CH4 + (2*deltaH_O2)

deltaH_reaction = deltaH_reaction_p - deltaH_reaction_r

% Step 3: Empirical constants for molar heat capacities of gases at constant pressure
% C_p = A + BT + CT^2 +DT^3 + ET^4, where T where T is in degrees Kelvin; kJ/(mole * K) (specify temp range)
% from Ludwig

% Heat of Vaporization of Water kJ/mole

Vape_H2O = 43.988 ;

% cal_to_kJ = (4.184/1000) ;
%
%
% a_CO = 6.350;
% b_CO = 1.811*(10^-3);
% c_CO = -0.2675*(10^-6);
%
% a_CO = a_CO * cal_to_kJ ;
% b_CO = b_CO * cal_to_kJ ;
% c_CO = c_CO * cal_to_kJ ;
%
%
%
% a_CO2 = 6.339;
% b_CO2 = 10.14*(10^-3);
% c_CO2 = -3.415*(10^-6);
%
% a_CO2 = a_CO2 * cal_to_kJ ;
% b_CO2 = b_CO2 * cal_to_kJ ;
% c_CO2 = c_CO2 * cal_to_kJ ;

% a_H2O = 7.136;
% b_H2O = 2.640*(10^-3);
% c_H2O = 0.0459*(10^-6);
%
% a_H2O = a_H2O * cal_to_kJ ;
% b_H2O = b_H2O * cal_to_kJ ;
% c_H2O = c_H2O * cal_to_kJ ;

% a_CH4 = 3.204;
% b_CH4 = 18.41*(10^-3);
% c_CH4 = -4.48*(10^-6);
%
% a_CH4 = a_CH4 * cal_to_kJ ;
% b_CH4 = b_CH4 * cal_to_kJ ;
% c_CH4 = c_CH4 * cal_to_kJ ;

a_CH4 = 34.942e-3 ;
b_CH4 = -3.9957e-5 ;
c_CH4 = 1.9184e-7 ;
d_CH4 = -1.5303e-10 ;
e_CH4 = 3.9321e-14 ;

a_CO2 = 27.437e-3 ;
b_CO2 = 4.2315e-5 ;
c_CO2 = -1.9555e-8 ;
d_CO2 = 3.9968e-12 ;
e_CO2 = -2.9872e-16 ;

a_H2O = 33.933e-3 ;
b_H2O = -8.4186e-6 ;
c_H2O = 2.9906e-8 ;
d_H2O = -1.7825e-11 ;
e_H2O = 3.6934e-15 ;

% a_O2 = 6.117;
% b_O2 = 3.167*(10^-3) ;
% c_O2 = -1.005*(10^-6) ;
%
% a_O2 = a_O2 * cal_to_kJ ;
% b_O2 = b_O2 * cal_to_kJ ;
% c_O2 = c_O2 * cal_to_kJ ;

% a_H2 = 6.946;
% b_H2 = -0.196*(10^-3);
% c_H2 = 0.4757*(10^-6);
%
% a_H2 = a_H2 * cal_to_kJ ;
% b_H2 = b_H2 * cal_to_kJ ;
% c_H2 = c_H2 * cal_to_kJ ;

n_CO2 = 1 ;
n_H2O = 2 ;
n_CH4 = 0.4 ;

T0 = 298 ;
n_moles = n_CO2 + n_H2O + n_CH4 ;

a = ((n_CO2/n_moles)*a_CO2) + ((n_H2O/n_moles)*a_H2O) + ((n_CH4/n_moles)*a_CH4) ;
b = ((n_CO2/n_moles)*b_CO2) + ((n_H2O/n_moles)*b_H2O) + ((n_CH4/n_moles)*b_CH4) ;
c = ((n_CO2/n_moles)*c_CO2) + ((n_H2O/n_moles)*c_H2O) + ((n_CH4/n_moles)*c_CH4) ;
d = ((n_CO2/n_moles)*d_CO2) + ((n_H2O/n_moles)*d_H2O) + ((n_CH4/n_moles)*d_CH4) ;
e = ((n_CO2/n_moles)*e_CO2) + ((n_H2O/n_moles)*e_H2O) + ((n_CH4/n_moles)*e_CH4) ;

Ta = 1000:10:5000;

size_Ta = size(Ta)

aterm = a.*(Ta - T0);
bterm = (b/2).*((Ta.^2) - (T0^2));
cterm = (c/3).*((Ta.^3) - (T0^3));
dterm = (d/4).*((Ta.^4) - (T0^4));
eterm = (e/5).*((Ta.^5) - (T0^5));

% negative_deltaH_reaction = -deltaH_reaction

H2O_term = (n_H2O*Vape_H2O)

A_term = -abs( deltaH_reaction + (n_H2O*Vape_H2O) )

%size_f_Ta = size(f_Ta)

f_Ta = -abs( deltaH_reaction + (n_H2O*Vape_H2O) ) + (n_moles.*(aterm + bterm + cterm + dterm + eterm)) ;

% fun_MAT(:,1) = Ta';
% fun_MAT(:,2) = f_Ta';

% fun_MAT = horzcat(Ta',f_Ta')

%figure
hold on
grid

ax = gca ;

ax.XLabel.String = 'Temperature (K)'

ax.YLabel.String = 'f_{Ta} (kJ)'

plot(Ta, f_Ta, '-ob')
