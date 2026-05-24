inlet_diameter = 38;
Mach_test = 3; %5
gamma = 1.3302 ;

temp = 298; % Units Kelvin %Freestream Temperature
pressure = 0.45; %Units Mpa %Freestream Pressure

%VARY cone_half_angle

figure()
hold on
grid on
title( "Taylor-Maccoll (Red) Kantrowitz (Blue) Mach=" + Mach_test + " \gamma=" + gamma + " inlet size=" + inlet_diameter + "mm",'FontSize' , 27)
xlabel( 'Cone Half Angle ^{o}' , 'FontSize' , 23)
ylabel( 'Volume (mm^{3})' , 'FontSize' , 23)
set(gca, 'FontSize' ,23)

%First we need to test values for theta cone half angle

trial_test = 3.2:0.1:3.4; %12.9:0.1:15; 0.01
trial_dim_mat = size(trial_test);
trial_num = trial_dim_mat(1,2);

toroid_volume_k = zeros(1,trial_num);

%K
for j=1:1:trial_num

%i= cone half angle also x values
[ area_ratio ] = Kantrowitz5( Mach_test,gamma );

r_throat_c_k = r_throat_calc(inlet_diameter/2, area_ratio);
%theta_cone_c_k = theta_cone_calc(inlet_size/2,r_throat_c_k,l_toroid );

toroid_volume_k(1,j) = toroid_volume_calc_cone_half_angle(inlet_diameter,r_throat_c_k*2, trial_test(1,j));

%[ toroid_surface_area_ratio_k ] = toroid_surface_area_ratio(inlet_size,r_throat_c_k*2, l_toroid);

plot(trial_test(1,j),toroid_volume_k(1,j), 'ob')
end

%TM
for j=1:1:trial_num %i= cone half angle also x values


[ x_intersect_inlet_bottom , y_intersect_inlet_bottom , x_intersect_inlet_top , y_intersect_inlet_top , throat_size(1,j) , l_toroid(1,j) , xsi , ysi] = TM_Busemann_Dimensions( trial_test(1,j) , inlet_diameter , gamma , temp , pressure , Mach_test );


toroid_volume_tm(1,j) = toroid_volume_calc(inlet_diameter,throat_size(1,j),l_toroid(1,j));
%[ toroid_surface_area_ratio_tm ] = toroid_surface_area_ratio(inlet_size,r_throat_tm*2, l_toroid);
plot(trial_test(1,j),toroid_volume_tm(1,j), 'or')
end

for j=1:1:trial_num

distance(1,j) = distance_calc(trial_test(1,j),toroid_volume_k(1,j),trial_test(1,j), toroid_volume_tm(1,j));

end

min_d = min(distance);
[ipos,iloc] = find(distance==min_d);

% x1 = trial_test(1,iloc)
% y1 = toroid_volume_k(1,iloc)
% x2 = trial_test(1,iloc+1)
% y2 = toroid_volume_k(1,iloc+1)
% x3 = trial_test(1,iloc)
% y3 = toroid_volume_tm(1,iloc)
% x4 = trial_test(1,iloc+1)
% y4 = toroid_volume_tm(1,iloc+1)

[cone_half_angle_design,toroid_volume_design] = line_line_intersection(trial_test(1,iloc), toroid_volume_k(1,iloc),trial_test(1,iloc+1),toroid_volume_k(1,iloc+1),trial_test( 1,iloc), toroid_volume_tm(1,iloc),trial_test(1,iloc+1),toroid_volume_tm(1,iloc+1))

labels = {[ 'Cone Half Angle = ' num2str(cone_half_angle_design) '^{o}' ],[ 'Volume = ' num2str(toroid_volume_design) 'mm^{3}']};
plot(cone_half_angle_design,toroid_volume_design, 'c*','MarkerSize' ,17)
plot(cone_half_angle_design,toroid_volume_design, 'oc','MarkerSize' ,17)
text(cone_half_angle_design,toroid_volume_design, labels,'VerticalAlignment' ,'top','HorizontalAlignment' ,'left', 'FontSize' , 19,'position' , [cone_half_angle_design toroid_volume_design-.00011])
