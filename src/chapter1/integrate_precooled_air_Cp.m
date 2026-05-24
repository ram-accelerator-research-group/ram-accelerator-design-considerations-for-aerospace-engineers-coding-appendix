function [T_air_sat_vapor_vec,delta_H_air_vec,Cp_air_mat] = integrate_precooled_air_Cp (T_air_init_vec,P_air_init_vec,T_offset)
% This function is meant to answer the following question:
%
% Consider 1 kilogram of precooled air entering a cryogenic heat
% exchanger at some pressure. It is then cooled down to the vapor
% saturation temperature of air, while being held at that initial
% pressure. What enthalpy change is needed to make this happen?
%
% Usage:
%
% [T_air_sat_vapor_vec,delta_H_air_vec,Cp_air_mat]...
% = integrate_precooled_air_Cp(T_air_init_vec,P_air_init_vec,T_offset) ;

% Perform an inital validation check of the input vectors.

if max(size(T_air_init_vec))~=max(size(P_air_init_vec))
error( 'The air temperature and air pressure vectors must have the same length.' )
else
end

% Make a note of the current directory, then move to the REFPROP directory
% for the following calculations.

WD = pwd ;

cd('C:\Program Files (x86)\REFPROP' ) ;

% Perform an initial validation check of the pressure vector.

P_critical_air = refpropm( 'P','C',0,' ',0,'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]) ;

if max(P_air_init_vec) >= P_critical_air
error( 'The maximum pressure of the air must be below its critical pressure.' )
else
end

% Initialize the data output vectors.

T_air_sat_vapor_vec = zeros(1,max(size(P_air_init_vec))) ;

delta_H_air_vec = zeros(1,max(size(P_air_init_vec))) ;

% Break the integration range for each run down into a constant number of
% temperature divisions.

num_divisions = 100 ;

Cp_air_mat = zeros(max(size(P_air_init_vec)),num_divisions) ;

start_inspection_at_num = 1857 ;

% Initialize the figure that will be used to provide graphical output of
% the Cp values for air.

figure
hold on
grid
xlabel( 'Integration Range Temperature (K)' )
ylabel( 'Cp (J/(kg K))' )

% For each air pressure...
for P_air_itr = 1:1:max(size(P_air_init_vec))

if mod(P_air_itr,100)==0
formatSpec = 'iteration number %0.0f' ;
disp( ' ')
disp( ' ')
fprintf(formatSpec,P_air_itr) ;
else
end

% ...Determine what the corresponding saturated air vapor temperature
% would be.

T_air_sat_vapor = refpropm( 'T','P',P_air_init_vec(1,P_air_itr), 'Q', 1,'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]) ;

T_air_sat_vapor_vec(1,P_air_itr) = T_air_sat_vapor_vec(1,P_air_itr) + T_air_sat_vapor ;

% Use the initial air temperature, and the saturated vapor temperature, to
% construct the vector of air temperature values that the Cp of air needs
% to be integrated over.

%T_offset = 1 ;

T_air_final = T_air_sat_vapor + T_offset ;

T_air_init = T_air_init_vec(1,P_air_itr) ;

T_air_integral_vec = T_air_init : ( T_air_final - T_air_init ) / ( num_divisions - 1 ) : T_air_final ;

% For each one of these temperatures, return the Cp of air.

Cp_air_vec = zeros(1,num_divisions) ;

for Cp_itr = 1:1:num_divisions

Q_current = refpropm( 'Q','T',T_air_integral_vec(1,Cp_itr), 'P',P_air_init_vec(1, P_air_itr), 'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]) ;

% The next if-else-end statement is to return internal results for
% validation. Comment this section out if it is not needed.

if P_air_itr>=start_inspection_at_num
%formatSpec1 = 'Pressure iteration number %0.0f' ;
%disp(' ')
%fprintf(formatSpec1,P_air_itr) ;

%formatSpec2 = 'Cp iteration number %0.0f' ;
%disp(' ')
%fprintf(formatSpec2,Cp_itr) ;

%Q_current = refpropm('Q','T',T_air_integral_vec(1,Cp_itr),'P',P_air_init_vec(1, P_air_itr),'nitrogen','argon','oxygen',[0.7557, 0.012700,0.2316]) ;

%formatSpec3 = ' The current temperature is %3.4f K.' ;
%disp(' ')
%fprintf(formatSpec3,T_air_integral_vec(1,Cp_itr)) ;


%formatSpec4 = ' The current vapor quality is %0.4f.' ;
%disp(' ')
%fprintf(formatSpec4,Q_current) ;
%disp(' ')

if Q_current > 1
%formatSpec4 = ' The current vapor quality is %0.4f.' ;
%disp(' ')
%fprintf(formatSpec4,Q_current) ;
%disp(' ')
else
formatSpec5 = ' The current vapor quality is %0.4f!' ;
disp( ' ')
fprintf(formatSpec5,Q_current) ;
disp( ' ')
disp( ' Stepping back from the precipice...' )

formatSpec6 = ' The revised temperature is %3.4f K.' ;
disp( ' ')
fprintf(formatSpec3,T_air_integral_vec(1,Cp_itr)+T_offset) ;

Q_current = refpropm( 'Q','T',T_air_integral_vec(1,Cp_itr)+T_offset, 'P', P_air_init_vec(1,P_air_itr), 'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]) ;

formatSpec7 = ' The revised vapor quality is %0.4f.' ;
disp( ' ')
fprintf(formatSpec4,Q_current) ;
disp( ' ')

end

else
end

if Q_current > 1
Cp_new = refpropm( 'C','T',T_air_integral_vec(1,Cp_itr), 'P',P_air_init_vec(1, P_air_itr), 'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]);
else
Cp_new = refpropm( 'C','T',(T_air_integral_vec(1,Cp_itr)+T_offset), 'P', P_air_init_vec(1,P_air_itr), 'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]);
%error('A phase transition is occurring; Cp cannot be calculated.')
end

Cp_air_vec(1,Cp_itr) = Cp_air_vec(1,Cp_itr) + Cp_new ;

%delta_Cp = Cp_new - Cp_old ;

%Cp_old = Cp_new ;

% The next if-else-end statement is to return internal results for
% validation. Comment this section out if it is not needed.

if P_air_itr>=start_inspection_at_num
formatSpec4 = ' The current Cp is is %4.4f J/(kg K).' ;
fprintf(formatSpec4,Cp_air_vec(1,Cp_itr)) ;
disp( ' ')
else
end

end

Cp_air_mat(P_air_itr,:) = Cp_air_mat(P_air_itr,:) + Cp_air_vec ;

plot(T_air_integral_vec,Cp_air_vec)

% Integrate the Cp values over the specified temperature range. This
% will yield the change in enthalpy.

delta_H_air_vec(1,P_air_itr) = delta_H_air_vec(1,P_air_itr) + trapz(T_air_integral_vec, Cp_air_vec) ;

end

disp( ' ')
disp( ' ')

% Return to the original directory.

cd(WD) ;

end
