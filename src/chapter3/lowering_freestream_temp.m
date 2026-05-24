gamma = 1.4; % ratio no units
R = 8.314; % mol^-1 K^-1
molar_mass = 28.8*10^-3; %kg mol^-1
freestream_temp1 = 300; %K
freestream_temp2 = 100; %K
v=990:9700; % m/s

stagnationTExpanded1 = StagTempExpanded( v,freestream_temp1,gamma,R,molar_mass );
stagnationTExpanded2 = StagTempExpanded( v,freestream_temp2,gamma,R,molar_mass );

precent_of_original_t_stag = (stagnationTExpanded2./stagnationTExpanded1)*100;

figure ()
hold on
grid on
title( "% of original T_{stag} vs. Velocity (m/s)" ,'FontSize' , 27)
xlabel( 'Velocity (m/s)' , 'FontSize' , 23)
ylabel( '% of original T_{stag}' , 'FontSize' , 23)

plot(990:1:9700,precent_of_original_t_stag, 'ob')
