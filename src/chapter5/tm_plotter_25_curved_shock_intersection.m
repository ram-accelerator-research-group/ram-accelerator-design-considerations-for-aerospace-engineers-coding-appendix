figure ()
hold on
grid on
title( 'Taylor-Maccoll Buseman Geometry Flow Field' ,'FontSize' , 27)
xlabel( 'length (mm)' , 'FontSize' , 23)
ylabel( 'height (mm)' , 'FontSize' , 23)
set(gca, 'FontSize' ,23)

%theta_s = theta_shock( r_inlet,r_throat_c,l_toroid );

% shock_half_angle = theta_s;
% cone_half_angle = 1;

%theta_s = 0.6041;
%theta_s = 0.436332;

l_toroid_guess = 150; %152 guess inlet 50 mach 4 guess %(l_toroid/inletsize) = scaling factor *inlet size we want

cone_half_angle = deg2rad(3.3461); %was 15
theta_cone = cone_half_angle;

%Ram Tube
%Mach_inf = 4; %look at 2,

%Ignition tube
Mach_inf = 3.4045; %4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Hiroshima University Ram tube
%Page 107, Ram Accelerators, K. Takayama, A. Sasoh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Propellant = '1.4CH_4 + 2O_2 + 4.3CO_2' ;
gamma = 1.3302;
freestream_enthalpy = 481.97*1000; % Units J/kg
Sound_Speed = 299.60; %Units m/s
temp = 298; % Units Kelvin %Freestream Temperature
pressure = 0.45; %Units Mpa %Freestream Pressure

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Hiroshima University Ignition tube
%Page 107, Ram Accelerators, K. Takayama, A. Sasoh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Propellant = '1.4CH_4 + 2O_2 + 2CO_2';
% gamma = 1.3344;
% freestream_enthalpy = 470.60*1000; % Units J/kg
% Sound_Speed = 317.92; %Units m/s
% temp = 298; % Units Kelvin
% pressure = 0.3; %Units Mpa

T_inf = temp;
P_inf = pressure;

%Lower limit temp scale modifer
lower_limit_temp_scale_modifer = 300;

% % set the number of streamlines and how the streamlines are spaced
% % meters
% steamlines_total = 1; %10
% streamlines_increment = .5; %1
% min_streamline = .5; %2


%this helps select the last x and y intercepts before the intersecting
%shock region
last_points_tolerance_factor = 0;

%%% Plot intersection points when streamlines passes through rays and shock
%%% waves (0 is no) (1 is yes)
plot_intersection_points = 0;

% plot ray lines (0 is no) (1 is yes)
plot_ray_lines = 0;

% plot quivers (0 is no) (1 is yes)
plot_quivers = 1;

% plot streamlines (0 is no) (1 is yes)
plot_streamlines = 1;

% plot temp scale (0 is no) (1 is yes)
plot_temp_scale = 1;

%set the spead of rays in the system, the actual number of rays is less
%because we remove rays that go through the Busemann toroid or bottom/top half
%of the axisymetric geometry
ray_spread = 100000; %60
theta_num = ray_spread;

%these values help with visibility of the flowfield arrows
flowfield_linewidth = 3;
flowfield_MaxHeadSize = 12; %2

theta_min = 0.01*(pi/180) ;
num_theta = theta_num;




%[theta_cone] = given_theta_shock_find_theta_cone_4( theta_s,Mach_inf,gamma );




[shock_half_angle, ...
theta_vec,V_prime_vec,Mach_prime_vec ...
partially_stagnated_P_vec,partially_stagnated_T_vec] = ...
given_supersonic_cone_find_shock_4(cone_half_angle,num_theta, ...
Mach_inf,P_inf,T_inf,gamma)

%for cone method %%%%%%%
theta_s = shock_half_angle;
theta_max = theta_s;

%for cone method %%%%%%%
%theta_cone = cone_half_angle;

%on second run change this FlAG FOR REVIEW
%y_o is the y intersect for the inlet on the bottom half
y_o_guess = tan(theta_cone)*(l_toroid_guess/2);

%Don't do this
%throat_size = y_intersect_inlet_top - y_intersect_inlet_bottom;

throat_size_guess = (tan(theta_s)*(l_toroid_guess/2)) - y_o_guess;

%inlet_size = 2*(y_o + (throat_size_guess/2));
inlet_diameter = 38;



%Add system information to plot
dim = [0.73 0.38 .7 0.2];
str = { "Propellant: " + Propellant + "" , "Mach = " + Mach_inf + "" , "\gamma = " + gamma + "" ,...
"C = " + Sound_Speed + " m/s" , "freestream temperature = " + temp + " K" , "freestream pressure = " + pressure + " Mpa" , "freestream enthalpy = " + freestream_enthalpy + " J/kg" ,...
"\theta_s = " + rad2deg(theta_s) + "^{\circ}" , "\theta_c = " + rad2deg(theta_cone) + "^ {\circ}" };
annotation( 'textbox' ,dim,'String', str,'FitBoxToText' ,'on','VerticalAlignment' ,'bottom','HorizontalAlignment' ,'left','FontSize' ,12);

%Construct Busemann Geometry [moved to bottem of code move this]

%find where top and bottom shocks intersect
%[xsi ,ysi]= line_line_intersection(0,0,l_toroid_guess/2,y_o+throat_size_guess,0,inlet_size, l_toroid_guess/2,y_o);

%%%%%% Shock Intersection %%%%%%%

xsi = (inlet_diameter/2)/tan(theta_s);
ysi = (inlet_diameter/2);


% set the number of streamlines and how the streamlines are spaced
% meters

% streamlines_n = 11;
%
% streamlines_increment = ysi/(streamlines_n+1); %1 %this ysi/(steamlines_total+1)
%
% min_streamline = 0.5; %2
%
% %streamlines_max = (min_streamline) + (streamlines_increment * steamlines_n) - streamlines_increment;
%
% streamlines_max = ysi- streamlines_increment-1;

%always use number divisible by the streamlines_to_plot variable
streamlines_n = 6000;
min_streamline = 1; %2

%streamlines_increment = (ysi-min_streamline)/(streamlines_n+min_streamline); %1 %this ysi/ (steamlines_total+1)
streamlines_increment = (ysi-min_streamline)/(streamlines_n);
%streamlines_max = (min_streamline) + (streamlines_increment * steamlines_n) - streamlines_increment;

%streamlines_max = ysi - 0.1; %streamlines_increment - min_streamline;
streamlines_max = ysi - 0.00001;

%this determines how many streamlines are actually plotted
streamlines_to_plot = 10;
streamline_plotting_increment = streamlines_n/streamlines_to_plot;



%%%% boundry condations for how streamlines behave
[ delta,Mach_2 ] = delta_m2_behind_cone_shock( theta_s,Mach_inf,gamma );
[ V_prime,V_prime_r,V_prime_theta ] = V_prime_r_theta( theta_s,delta,Mach_2,gamma );



V_prime_r_at_theta_max = V_prime_r ;

V_prime_theta_at_theta_max = V_prime_theta ;


[ V_prime_r_vec,V_prime_theta_vec,theta_vec ] = ...
find_v_primes_behind_shock_6( theta_max,theta_min,num_theta, ...
V_prime_r_at_theta_max,V_prime_theta_at_theta_max, ...
gamma );



th_theta_plotter = size(theta_vec);
th_theta_plot = th_theta_plotter(1,1);


% Fin V prime cartesian
[ V_prime_c ] = V_prime_sys(V_prime_r_vec,V_prime_theta_vec);
[ mach ] = Mach_sys(gamma,V_prime_c);
%[ stagnationT ] = StagTemp( temp,gamma,mach );

%Find positive values
V_prime_theta_vec_IDX = V_prime_theta_vec > 0;

%Find min positive value
V_prime_theta_vec_IDX_min = min(V_prime_theta_vec(V_prime_theta_vec_IDX));

%Find row value of min positive value
V_prime_theta_vec_IDX_min_row = find(V_prime_theta_vec==V_prime_theta_vec_IDX_min);

%ray deflection angle %%%%%this is not used
%phi = beta - alpha - theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot- 1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%set color map system
[ stagnationT ] = StagTemp( temp,gamma,mach );

% need to set max temp to the max stag temp


colormap turbo;

if plot_temp_scale == 1
colorbar
temp_units=colorbar;
title(temp_units, 'K');
end

ax = gca;
min_temp = temp-temp; %lower_limit_temp_scale_modifer;
max_temp = round(max(stagnationT)); %600
temp_diff = max_temp-min_temp;

ax.CLim = [min_temp max_temp];
actual_temp = actual_temp_relationship(Mach_inf,mach(V_prime_theta_vec_IDX_min_row: th_theta_plot-1),gamma,temp);


customCMAP = jet(temp_diff);
ax.Colormap = customCMAP;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y_rays = (l_toroid_guess/2)*tan(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot-1)); % height of ray
y_rays_size_rc = size(y_rays);
y_rays_size = y_rays_size_rc(1);

y_rays_to_plot = 20;
y_rays_plotting_increment = round(y_rays_size/y_rays_to_plot);

%y_rays_top = flip(y_rays);
y_rays_top = ((l_toroid_guess/2)*tan(- theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot- 1)))+(inlet_diameter); %height of ray


%set the streamlines to be obsurved in the plot
streamlines_bottom = (min_streamline:streamlines_increment:streamlines_max)';
streamlines_size = size(streamlines_bottom);
streamlines_num = streamlines_size(1)';

%find the x intercept of the bottom shock
x_shock = (streamlines_bottom./tan(theta_s));

%draw non interesting streamlines (ambient and non moving FOD molecules)

if plot_streamlines == 1
for ind=1:streamline_plotting_increment:streamlines_num(1)
line([0 x_shock(ind)],[streamlines_bottom(ind) streamlines_bottom(ind)], 'color',customCMAP (temp,:))
end
end

%draw TOP non interesting streamlines (ambient and non moving FOD molecules)
if plot_streamlines == 1
for ind=1:streamline_plotting_increment:streamlines_num(1)
line([0 x_shock(ind)],[(ysi*2)-streamlines_bottom(ind) (ysi*2)- streamlines_bottom (ind)],'color',customCMAP(temp,:))
end
end

% for i=1:1:streamlines_num(1)
% line([0 x_shock(i)],[streamlines_top(i) streamlines_top(i)])
% end

%find height of a streamline deflected from the bottom shock ((l_toroid/2)- x_shock)*tan (delta)
y_delta1 = y_delta(l_toroid_guess,x_shock,delta);

%find height of general y from streamlines
y_delta_prime = streamlines_bottom + y_delta1;

for ind=1:1:streamlines_num(1)
[xdp(ind) ,ydp(ind)]= line_line_intersection(0,0,l_toroid_guess./2,y_rays(y_rays_size), x_shock(ind),streamlines_bottom(ind),l_toroid_guess./2,y_delta_prime(ind));
end

if plot_intersection_points == 1
for ind=1:1:streamlines_num(1)
plot(xdp(ind),ydp(ind), 'or')
end
end

%Here we extract the x and y components of V prime r and V prime theta
V_r_x = cos(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot- 1)).*V_prime_r_vec (V_prime_theta_vec_IDX_min_row:th_theta_plot-1);
V_r_y = sin(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot- 1)).*V_prime_r_vec (V_prime_theta_vec_IDX_min_row:th_theta_plot-1);

V_theta_x = cos(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot-1)- (pi/2)). *V_prime_theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot-1);
V_theta_y = sin(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot-1)- (pi/2)). *V_prime_theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot-1);

Xcomp_U = V_r_x + V_theta_x;
Ycomp_V = V_r_y + V_theta_y;

%testing
Ycomp_V_top = -Ycomp_V;

%Here we find the deflection angle of each ray
ray_d_angle = atan(Ycomp_V./Xcomp_U);

xdp_t = xdp';
ydp_t = ydp';

%constructs a line from the x and y intercepts from streamline headed into the shockwave into the
%first or top ray to the throat used to find the intersection points
%%%%%y_phi_rays = ((l_toroid/2)-xdp).*tan(ray_d_angle(y_rays_size)) +ydp;
%confirm last ray is correct in matrix
%y_phi_rays = ((l_toroid/2)-xdp_t(1:5)).*tan(ray_d_angle(4)) +ydp_t(1:5)



%%% marker
XYintercepts_b = zeros(streamlines_num,2,y_rays_size);
XYintercepts_t = zeros(streamlines_num,2,y_rays_size);
y_phi_ray_n = zeros(streamlines_num,1,y_rays_size);

%top ray

XYintercepts_b(:,1,y_rays_size) = xdp_t;
XYintercepts_b(:,2,y_rays_size) = ydp_t;

for ind=1:1:streamlines_num
y_phi_ray_n(ind,:,y_rays_size) = ((((l_toroid_guess/2)- xdp_t(ind)).*tan(ray_d_angle (y_rays_size))) +ydp_t(ind))';
[XYintercepts_b(ind,1,y_rays_size-1) ,XYintercepts_b(ind,2,y_rays_size-1)] = line_line_intersection(0,0,l_toroid_guess/2,y_rays(y_rays_size- 1),xdp_t(ind),ydp_t(ind), l_toroid_guess/2,y_phi_ray_n(ind,:,y_rays_size));
end

% % % XYintercepts_b(:,1,y_rays_size) = xdp_t;
% % % XYintercepts_b(:,2,y_rays_size) = ydp_t;

%plot(XYintercepts_b(:,1,y_rays_size),XYintercepts_b(:,2,y_rays_size),'or')

% for testing
%line([xdp_t(3) l_toroid/2],[ydp_t(3) y_phi_ray_n(3,:,y_rays_size)])
%xdp_t(i),ydp_t(i),l_toroid/2,y_phi_ray_n(i,:,y_rays_size)


for j=2:1:y_rays_size-1 %was 2
for ind=1:1:streamlines_num
y_phi_ray_n(ind,:,y_rays_size-j+1) = ((((l_toroid_guess/2)- XYintercepts_b(ind,1, y_rays_size-j+1)).*tan(ray_d_angle(y_rays_size-j+1))) +XYintercepts_b(ind,2,y_rays_size-j+1));
[XYintercepts_b(ind,1,y_rays_size-j) ,XYintercepts_b(ind,2,y_rays_size-j)] = line_line_intersection(0,0,l_toroid_guess/2,y_rays(y_rays_size- j),XYintercepts_b(ind,1, y_rays_size-j+1),XYintercepts_b(ind,2,y_rays_size- j+1),l_toroid_guess/2,y_phi_ray_n(ind,:, y_rays_size-j+1));
end
end

% construct top x y intercepts

for ind=1:1:y_rays_size
XYintercepts_t(:,2,ind) = (ysi*2)-XYintercepts_b(:,2,ind);
XYintercepts_t(:,1,ind) = XYintercepts_b(:,1,ind);
end

% Cut off the rays before the intersection region
% We find where the bottom rays intersect with the top shock
y_rays_bir = zeros(y_rays_size,2);
for ind=1:1:y_rays_size
[y_rays_bir(ind,1) ,y_rays_bir(ind,2)] = line_line_intersection(0,0,l_toroid_guess/2,y_rays (ind),0,inlet_diameter,l_toroid_guess/2,y_o_guess);
end

%plot bottom rays
if plot_ray_lines == 1
for ind=1:1:y_rays_size
plot([y_rays_bir(ind,1) 0],[y_rays_bir(ind,2) 0], 'g')
end
end


%cut off rays
y_rays_bir_top = zeros(y_rays_size,2);
for ind=1:1:y_rays_size
[y_rays_bir_top(ind,1) ,y_rays_bir_top(ind,2)] = line_line_intersection(0,inlet_diameter, l_toroid_guess/2,y_rays_top(ind),0,0,l_toroid_guess/2,y_o_guess+throat_size_guess) ;
end

%plot top rays
if plot_ray_lines == 1
for ind=1:1:y_rays_size
plot([y_rays_bir_top(ind,1) 0],[y_rays_bir_top(ind,2) inlet_diameter], 'g')
end
end

%%%%%

%%plot top x y intercepts
% for i=1:1:y_rays_size
% %if XYintercepts_t(:,1,y_rays_size-i+1) <= l_toroid/2
% plot(XYintercepts_t(:,1,y_rays_size-i+1),XYintercepts_t(:,2,y_rays_size- i+1),'or')
% %hold on
% %else
% %end
% end

if plot_intersection_points == 1
for j=1:1:streamlines_num
for ind=1:1:y_rays_size
if XYintercepts_t(j,1,y_rays_size-ind+1) <= y_rays_bir_top(y_rays_size- ind+1,1)- last_points_tolerance_factor
plot(XYintercepts_t(j,1,y_rays_size-ind+1),XYintercepts_t(j,2,y_rays_size- ind+1), 'or')
hold on
else
end
end
end
end

% %plot bottom x y intercepts


% for i=1:1:y_rays_size
% %if XYintercepts_b(:,1,y_rays_size-i+1) <= l_toroid/2
% plot(XYintercepts_b(:,1,y_rays_size-i+1),XYintercepts_b(:,2,y_rays_size- i+1),'or')
% %hold on
% %else
% %end
% end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plot_intersection_points == 1
for j=1:1:streamlines_num
for ind=1:1:y_rays_size
if XYintercepts_b(j,1,y_rays_size-ind+1) <= y_rays_bir(y_rays_size-ind+1,1)- last_points_tolerance_factor
plot(XYintercepts_b(j,1,y_rays_size-ind+1),XYintercepts_b(j,2,y_rays_size- ind+1), 'or')
hold on
else
end
end
end
end
%

%%%%plot streamlines passing through the first shock to the first ray


% the last ray is theta shock, and the corasponding values associated with
% this last ray are used to the temp of a streamline after the first
% deflection
actual_temp_after_first_shock = actual_temp_relationship(Mach_inf,mach(th_theta_plot),gamma, temp);


%%%%plot streamlines passing through the first shock to the first ray

if plot_streamlines == 1
for ind=1:streamline_plotting_increment:streamlines_num
line([x_shock(ind) xdp(ind)],[streamlines_bottom(ind) ydp(ind)], 'color',customCMAP(round (actual_temp_after_first_shock(1))-min_temp,:))
end
end

if plot_streamlines == 1
for ind=1:streamline_plotting_increment:streamlines_num
line([x_shock(ind) xdp(ind)],[(ysi*2)-streamlines_bottom(ind) (ysi*2)- ydp(ind)], 'color', customCMAP(round(actual_temp_after_first_shock(1))-min_temp,:))
end
end

%[ray_temp] = [y_rays stagnationT(V_prime_theta_vec_IDX_min_row:th_theta_plot- 1)];

%plot the bottom flow field

if plot_quivers == 1
for j=1:streamline_plotting_increment:streamlines_num
if XYintercepts_b(j,1,y_rays_size) <= xsi-last_points_tolerance_factor %y_rays_bir (y_rays_size,1)-last_points_tolerance_factor
quiver(XYintercepts_b(j,1,y_rays_size),XYintercepts_b(j,2,y_rays_size),Xcomp_U(y_r ays_size), Ycomp_V(y_rays_size), 'linewidth' ,flowfield_linewidth, 'MaxHeadSize' ,flowfield_MaxHeadSize, 'color', customCMAP(round(actual_temp(y_rays_size))-min_temp,:))
hold on
else
end
end
end

if plot_quivers == 1
for j=1:streamline_plotting_increment:streamlines_num
for ind=1:y_rays_plotting_increment:y_rays_size-1
if XYintercepts_b(j,1,y_rays_size-ind) <= xsi-last_points_tolerance_factor %y_rays_bir (y_rays_size-ind,1)-last_points_tolerance_factor
quiver(XYintercepts_b(j,1,y_rays_size-ind),XYintercepts_b(j,2,y_rays_size- ind),Xcomp_U (y_rays_size-ind),Ycomp_V(y_rays_size-ind), 'linewidth' ,flowfield_linewidth, 'MaxHeadSize' , flowfield_MaxHeadSize, 'color',customCMAP(round(actual_temp(y_rays_size-ind))- min_temp,:)) % turbocustom(round(actual_temp(1)),1)
hold on
else
end
end
end
end

% %plot the top flow field removing invalid points on the top

if plot_quivers == 1
for j=1:streamline_plotting_increment:streamlines_num
if XYintercepts_t(j,1,y_rays_size) <= xsi-last_points_tolerance_factor %y_rays_bir (y_rays_size-ind,1)-last_points_tolerance_factor
quiver(XYintercepts_t(j,1,y_rays_size),XYintercepts_t(j,2,y_rays_size),Xcomp_U(y_r ays_size), Ycomp_V_top(y_rays_size), 'linewidth' ,flowfield_linewidth, 'MaxHeadSize' , flowfield_MaxHeadSize, 'color',customCMAP(round(actual_temp(y_rays_size))- min_temp,:))
hold on
else
end
end
end


if plot_quivers == 1
for j=1:streamline_plotting_increment:streamlines_num
for ind=1:y_rays_plotting_increment:y_rays_size-1
if XYintercepts_t(j,1,y_rays_size-ind) <= xsi-last_points_tolerance_factor %y_rays_bir (y_rays_size-ind,1)-last_points_tolerance_factor
quiver(XYintercepts_t(j,1,y_rays_size-ind),XYintercepts_t(j,2,y_rays_size- ind),Xcomp_U (y_rays_size-ind),Ycomp_V_top(y_rays_size-ind), 'linewidth' ,flowfield_linewidth, 'MaxHeadSize' , flowfield_MaxHeadSize, 'color',customCMAP(round(actual_temp(y_rays_size-ind))- min_temp,:))
hold on
else
end
end
end
end

%%%%% Second Shock Deflection


%Bottom 2nd deflection intercepts
% for j=1:1:streamlines_num
% for i=1:1:y_rays_size
% if XYintercepts_b(j,1,y_rays_size-i+1) <= y_rays_bir(y_rays_size-i+1,1)
% XYintercepts_b_last(j,1,y_rays_size-i+1) = XYintercepts_b(j,1,y_rays_size- i+1);
% XYintercepts_b_last(j,2,y_rays_size-i+1) = XYintercepts_b(j,2,y_rays_size- i+1);
% else
% end
% end
% end
%
%
% XYintercepts_b_last_ray_points_before_shock = max(XYintercepts_b_last);

% Here we begin to trace the streamlines through the rays.
% We make sure the x and y intercepts coraspond to the first ray
XYintercepts_all_rays_last_b = zeros(y_rays_size,2,streamlines_num);
for j=1:1:y_rays_size
for ind = 1:1:streamlines_num
XYintercepts_all_rays_last_b(j,:,ind) = XYintercepts_b(ind,:,y_rays_size-j+1);
end
end

%Here we check which x and y intercepts on each ray are before the
%intersection region.
% We also place the ray deflection angle for the corasponding ray in the
% third colomn

XYintercepts_all_rays_last_b_n = zeros(y_rays_size,3,streamlines_num);
for ind=1:1:streamlines_num
for j=1:1:y_rays_size
if XYintercepts_all_rays_last_b(j,1,streamlines_num-ind+1) <= xsilast_ points_tolerance_factor %y_rays_bir(y_rays_size-j+1,1)- last_points_tolerance_factor
XYintercepts_all_rays_last_b_n(j,1,streamlines_num-ind+1) = XYintercepts_all_rays_last_b (j,1,streamlines_num-ind+1);
XYintercepts_all_rays_last_b_n(j,2,streamlines_num-ind+1) = XYintercepts_all_rays_last_b (j,2,streamlines_num-ind+1);
XYintercepts_all_rays_last_b_n(j,3,streamlines_num-ind+1) = ray_d_angle(y_rays_sizej+ 1); %y_rays_size-j+1
else
end
end
end


% These are the last x and y intercepts before the intersection region
XYintercepts_b_last_ray_points_before_shock_n = max(XYintercepts_all_rays_last_b_n);


for j=1:1:streamlines_num
y_2nd_deflection_bottom(1,1,streamlines_num-j+1) = ((((l_toroid_guess/2)- XYintercepts_b_last_ray_points_before_shock_n(1,1,streamlines_num-j+1)).*tan (XYintercepts_b_last_ray_points_before_shock_n(1,3,streamlines_num-j+1))) +XYintercepts_b_last_ray_points_before_shock_n(1,2,streamlines_num-j+1));
end

%XYintercepts_b_last_ray_points_before_shock_n(1,1,streamlines_num-j+1))

%for a test can delete
%plot(l_toroid/2,y_2nd_deflection_bottom(:,:,4),'og')

%%% Here we are setting up 6 columns
%%% col1 x, col2 y, col3 ray_d_angle, col4 Mach, col 5 temperature, col 6
%%% ray_d_angle_theta_s
XYintercepts_2nd_shock = zeros(1,6,streamlines_num);

for j=1:1:streamlines_num
[XYintercepts_2nd_shock(1,1,j) ,XYintercepts_2nd_shock(1,2,j)] = line_line_intersection(0, inlet_diameter,l_toroid_guess/2,y_o_guess,XYintercepts_b_last_ray_points_before_sh ock_n(1,1,j), XYintercepts_b_last_ray_points_before_shock_n(1,2,j),l_toroid_guess/2,y_2nd_deflec tion_bottom (1,:,j));
end

%for testing
% for j=1:1:streamlines_num
% line([XYintercepts_b_last_ray_points_before_shock_n(1,1,j) l_toroid/2], [XYintercepts_b_last_ray_points_before_shock_n(1,2,j) y_2nd_deflection_bottom(1,:,j)])
% end
%XYintercepts_b_last_ray_points_before_shock_n(1,2,j)


if plot_intersection_points == 1
for ind=1:1:streamlines_num
plot(XYintercepts_2nd_shock(1,1,streamlines_num- ind+1),XYintercepts_2nd_shock(1,2, streamlines_num-ind+1), 'ob')
end
end

% this adds the previous deflection angle in the third colomn
% this will allow us to match the correct deflection angles in the
% deflection region to the streamlines
for ind=1:1:streamlines_num
XYintercepts_2nd_shock(1,3,streamlines_num-ind+1) = XYintercepts_b_last_ray_points_before_shock_n(1,3,streamlines_num-ind+1);
end



%%% TOP 2nd deflection intercepts

for ind=1:1:streamlines_num
XYintercepts_2nd_shock_top(:,2,ind) = (ysi*2)-XYintercepts_2nd_shock(:,2,ind);
XYintercepts_2nd_shock_top(:,1,ind) = XYintercepts_2nd_shock(:,1,ind);
end

if plot_intersection_points == 1
for ind=1:1:streamlines_num
plot(XYintercepts_2nd_shock_top(1,1,streamlines_num- ind+1),XYintercepts_2nd_shock_top (1,2,streamlines_num-ind+1), 'or')
end
end

%%%prep for theta-beta-m %%% actually beta-theta-M
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Here we extract the x and y components of V prime r and V prime theta,
%the last ray which is the shock is omitted from this routine
V_r_x = cos(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot- 1)).*V_prime_r_vec (V_prime_theta_vec_IDX_min_row:th_theta_plot-1);
V_r_y = sin(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot- 1)).*V_prime_r_vec (V_prime_theta_vec_IDX_min_row:th_theta_plot-1);

V_theta_x = cos(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot-1)- (pi/2)). *V_prime_theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot-1);
V_theta_y = sin(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot-1)- (pi/2)). *V_prime_theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot-1);

Xcomp_U = V_r_x + V_theta_x;
Ycomp_V = V_r_y + V_theta_y;

%Here we find the deflection angle of each ray
ray_d_angle_to_theta_s = atan(Ycomp_V./Xcomp_U);


mach_values = mach(V_prime_theta_vec_IDX_min_row:th_theta_plot-1);


%this adds the Mach number to the 4th column and the ray_d_angle_to_theta_s to the 6th column
% associated with the corasponding streamline, ray_d_angle, and x y coordinates
for j=1:1:y_rays_size
for ind=1:1:streamlines_num
if ray_d_angle(y_rays_size-j+1) == XYintercepts_2nd_shock(1,3,streamlines_num- ind+1)
XYintercepts_2nd_shock(1,4,streamlines_num-ind+1) = mach_values(y_rays_size- j+1);
XYintercepts_2nd_shock(1,6,streamlines_num-ind+1) = ray_d_angle_to_theta_s(y_rays_size-j+1);
end
end
end

%%%%% here we calculate beta_old, M_2_2nd_shock, beta_new, and theta_s_new
%%%%% for the first segment of the curved bottom shock. Note that the
%%%%% ray_d_angles and Mach system numbers associated with a particular
%%%%% streamline are stored in col 3 and col 4.

%try ray_d_angle with ray_d_angle_to_theta_s

beta_old_bottom_first = ray_d_angle(y_rays_size,1) + theta_s;

M_2_2nd_shock_bottom_first = Mach_2_2nd_shock(mach_values(y_rays_size,1), beta_old_bottom_first,gamma,ray_d_angle(y_rays_size,1));

beta_new_bottom_first = beta_new_calc(mach_values(y_rays_size,1),gamma,ray_d_angle (y_rays_size,1));

theta_s_new_bottom_from_top = abs(ray_d_angle(y_rays_size,1) - beta_new_bottom_first);


beta_old_ray_values = zeros(y_rays_size,1);
beta_old_ray_values(y_rays_size,1) = beta_old_bottom_first;

M_2_2nd_ray_values = zeros(y_rays_size,1);
M_2_2nd_ray_values(y_rays_size,1) = M_2_2nd_shock_bottom_first;

beta_new_ray_values = zeros(y_rays_size,1);
beta_new_ray_values(y_rays_size,1) = beta_new_bottom_first;

theta_s_new_ray_values = zeros(y_rays_size,1);
theta_s_new_ray_values(y_rays_size,1) = theta_s_new_bottom_from_top;

for ind=1:1:y_rays_size-1
beta_old_ray_values(y_rays_size-ind,1) = ray_d_angle(y_rays_size-ind,1) + theta_s_new_ray_values(y_rays_size-ind+1,1);
M_2_2nd_ray_values(y_rays_size-ind,1) = Mach_2_2nd_shock(mach_values(y_rays_size-ind,1), beta_old_ray_values(y_rays_size-ind,1),gamma,ray_d_angle(y_rays_size-ind,1));
beta_new_ray_values(y_rays_size-ind,1) = beta_new_calc(mach_values(y_rays_size-ind,1),gamma, ray_d_angle(y_rays_size-ind,1));
theta_s_new_ray_values(y_rays_size-ind,1) = abs(ray_d_angle(y_rays_size-ind,1) - beta_new_ray_values(y_rays_size-ind,1));
end





%beta = beta_fxn(Xcomp_U,Ycomp_V,theta_s,throat_size,y_rays_size);

%%%%%%%%
%theta_beta_M = theta_beta_M_2nd_shock(mach(V_prime_theta_vec_IDX_min_row:th_theta_plot-1), beta,gamma);


%%%%%%%%

M_2_2nd_shock = M_2_2nd_ray_values;


V_max = sqrt(2*freestream_enthalpy);
V_actual = (((2./((gamma-1).*M_2_2nd_shock.^2))+1).^-(.5)).*V_max; %PAGE 371 Anderson MCF
V_prime_curved = V_actual./V_max;



%RAY_D_ANGLE

%%% perhaps the temp should not be the freestream temp since at these
%%% locations the temp is from the actual_temp relation

for ind=1:1:y_rays_size
actual_temp_intersection_region(y_rays_size-ind+1,1) = actual_temp_relationship(mach_values (y_rays_size-ind+1,1),M_2_2nd_shock(y_rays_size- ind+1,1),gamma,actual_temp(y_rays_size-ind+1,1));
end


%%%%%test comment out
% for j=1:1:streamlines_num
% y_2nd_final_deflection_bottom(j,1) = ((((l_toroid/2)- XYintercepts_2nd_shock(1,1,j)).*tan (XYintercepts_2nd_shock(1,4,j))) +XYintercepts_2nd_shock(1,2,j));
% end
%
% if plot_intersection_points == 1
% for j=1:1:streamlines_num
% plot(l_toroid/2,y_2nd_final_deflection_bottom(j,1),'or')
% end
% end

%We need to pair the tempature of the streamline in the intersection region
%to the streamline
for j=1:1:y_rays_size
for ind=1:1:streamlines_num
if ray_d_angle(y_rays_size-j+1) == XYintercepts_2nd_shock(1,3,streamlines_num- ind+1)
XYintercepts_2nd_shock(1,5,streamlines_num-ind+1) = actual_temp_intersection_region (y_rays_size-ind+1) ;
end
end
end


%This plots the bottom streamlines in the intersection region
% for i=1:1:streamlines_num
% if XYintercepts_2nd_shock(1,1,i) < l_toroid/2
% line([XYintercepts_2nd_shock(1,1,i) l_toroid/2],[XYintercepts_2nd_shock(1,2,i) y_2nd_final_deflection_bottom(i,1)],'color',customCMAP(round(XYintercepts_2nd_shoc k(1,5,i))- min_temp,:))
% end
% end


%%% Top 2nd shock streamlines
%%%%%%%%% test comment oout
% for ind=1:1:streamlines_num
% y_2nd__final_deflection_top(ind,1) = (ysi*2)- y_2nd_final_deflection_bottom(ind,1);
% end
%
% if plot_intersection_points == 1
% for j=1:1:streamlines_num
% plot(l_toroid/2,y_2nd__final_deflection_top(j,1),'og')
% end
% end


% the bounds are the same for the top and bottom streamlines so we just use
% the bottom bounds here
% for i=1:1:streamlines_num
% if XYintercepts_2nd_shock(1,1,i) < l_toroid/2 %bottom bounds
% line([XYintercepts_2nd_shock_top(1,1,i) l_toroid/2],[XYintercepts_2nd_shock_top(1,2,i) y_2nd__final_deflection_top(i,1)],'color',customCMAP(round(XYintercepts_2nd_shock( 1,5,i))- min_temp,:))
% end
% end

%%%%%%%%%%%%%%%%%%%%%%%%2nd shock flowfield points top

% look here
% for i=1:1:streamlines_num
% if XYintercepts_2nd_shock(1,1,i) < l_toroid/2
% quiver(XYintercepts_2nd_shock_top(1,1,i),XYintercepts_2nd_shock_top(1,2,i),cos(- XYintercepts_2nd_shock(1,4,i)),sin(-XYintercepts_2nd_shock(1,4,i)),'linewidth', flowfield_linewidth,'MaxHeadSize',flowfield_MaxHeadSize,'color',customCMAP(round (XYintercepts_2nd_shock(1,5,i))-min_temp,:))
% end
% end

% % look here
% for i=1:1:streamlines_num
% if XYintercepts_2nd_shock(1,1,i) < l_toroid/2
% quiver(XYintercepts_2nd_shock_top(1,1,i),XYintercepts_2nd_shock_top(1,2,i),cos(- XYintercepts_2nd_shock(1,4,i)),sin(-XYintercepts_2nd_shock(1,4,i)),'linewidth', flowfield_linewidth,'MaxHeadSize',flowfield_MaxHeadSize,'color',customCMAP(round (XYintercepts_2nd_shock(1,5,i))-min_temp,:))
% end
% end


%plot bottom middle streamlines
if plot_streamlines == 1
for j=1:1:y_rays_size-1
for ind=1:streamline_plotting_increment:streamlines_num
if XYintercepts_b(ind,1,y_rays_size-j) <= xsi-last_points_tolerance_factor %y_rays_bir (y_rays_size-j,1)-last_points_tolerance_factor
line([XYintercepts_b(ind,1,y_rays_size-j+1) XYintercepts_b(ind,1,y_rays_size- j)], [XYintercepts_b(ind,2,y_rays_size-j+1) XYintercepts_b(ind,2,y_rays_size-j)], 'color',customCMAP (round(actual_temp(y_rays_size-j))-min_temp,:))
%hold on
%else
end
end
end
end

% plot top middle streamlines
if plot_streamlines == 1
for j=1:1:y_rays_size-1
for ind=1:streamline_plotting_increment:streamlines_num
if XYintercepts_t(ind,1,y_rays_size-j) <= xsi-last_points_tolerance_factor % y_rays_bir_top(y_rays_size-j,1)-last_points_tolerance_factor
line([XYintercepts_t(ind,1,y_rays_size-j+1) XYintercepts_t(ind,1,y_rays_size- j)], [XYintercepts_t(ind,2,y_rays_size-j+1) XYintercepts_t(ind,2,y_rays_size-j)], 'color',customCMAP (round(actual_temp(y_rays_size-j))-min_temp,:))
end
end
end
end

% Marker
%%%%%%%%%% Prepare Curved Shock Plot
%beta2 = beta2_calc(mach(V_prime_theta_vec_IDX_min_row),gamma,theta_cone);
%Here we extract the x and y components of V prime r and V prime theta
% V_r_x_to_theta_s = cos(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot)). *V_prime_r_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot);
% V_r_y_to_theta_s = sin(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot)). *V_prime_r_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot);
%
% V_theta_x_to_theta_s = cos(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot)-(pi/2)). *V_prime_theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot);
% V_theta_y_to_theta_s = sin(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot)-(pi/2)). *V_prime_theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot);
%
% Xcomp_U_to_theta_s = V_r_x_to_theta_s + V_theta_x_to_theta_s;
% Ycomp_V_to_theta_s = V_r_y_to_theta_s + V_theta_y_to_theta_s;
%
% %testing
% %Ycomp_V_top_to_theta_s = -Ycomp_V_to_theta_s;
%
% %Here we find the deflection angle of each ray
% ray_d_angle_to_theta_s = atan(Ycomp_V_to_theta_s./Xcomp_U_to_theta_s);

%this includes the last ray which is the shock.
mach_rays = mach(V_prime_theta_vec_IDX_min_row:th_theta_plot);

%Here we extract the x and y components of V prime r and V prime theta,
%including the last ray which is the shock
V_r_x_all_rays = cos(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot)).*V_prime_r_vec (V_prime_theta_vec_IDX_min_row:th_theta_plot);
V_r_y_all_rays = sin(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot)).*V_prime_r_vec (V_prime_theta_vec_IDX_min_row:th_theta_plot);

V_theta_x_all_rays = cos(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot)-(pi/2)). *V_prime_theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot);
V_theta_y_all_rays = sin(theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot)-(pi/2)). *V_prime_theta_vec(V_prime_theta_vec_IDX_min_row:th_theta_plot);

Xcomp_U_all_rays = V_r_x_all_rays + V_theta_x_all_rays;
Ycomp_V_all_rays = V_r_y_all_rays + V_theta_y_all_rays;

%Here we find the deflection angle of each ray
ray_d_angle_to_theta_s_all_rays = atan(Ycomp_V_all_rays./Xcomp_U_all_rays);

%here we connect beta2 with ray_d_angle_to_theta_s
%%%%%%%%%%%%%%%%%%%%%%% dont't use theta_cone here
for ind=1:1:y_rays_size+1
beta_new(ind,1) = beta_new_calc(mach_rays(ind,1),gamma,- ray_d_angle_to_theta_s_all_rays(ind, 1));
beta_new(ind,2) = -ray_d_angle_to_theta_s_all_rays(ind,1);
end

for ind=1:1:y_rays_size+1
new_shock_deflection(1,1,ind) = -ray_d_angle_to_theta_s_all_rays(ind,1) - beta_new(ind,1);
new_shock_deflection(1,2,ind) = -ray_d_angle_to_theta_s_all_rays(ind,1);
end


%marker
%Here we set the top x and y intercepts to the corasponding ray_d_angle,
%which is the value in col.3
for ind=1:1:streamlines_num
XYintercepts_b_last_ray_points_before_shock_n_top(1,1,ind) = XYintercepts_b_last_ray_points_before_shock_n(1,1,ind);
XYintercepts_b_last_ray_points_before_shock_n_top(1,2,ind) = (ysi*2)- XYintercepts_b_last_ray_points_before_shock_n(1,2,ind);
XYintercepts_b_last_ray_points_before_shock_n_top(1,3,ind) = - XYintercepts_b_last_ray_points_before_shock_n(1,3,ind);
end

%Here we set the top x and y intercepts to the corasponding
%new_shock_deflection angle to col.4
for j=1:1:y_rays_size+1
for ind=1:1:streamlines_num
if new_shock_deflection(1,2,y_rays_size-j+1+1) == XYintercepts_b_last_ray_points_before_shock_n_top(1,3,streamlines_num-ind+1)
XYintercepts_b_last_ray_points_before_shock_n_top(1,4,streamlines_num-ind+1) = new_shock_deflection(1,1,y_rays_size+1-j+1);
end
end
end

%XYintercepts_2nd_shock_top
%curved_shock_last_angle_y = (tan(new_shock_deflection(y_rays_size+1))*((l_toroid/2)-xsi)) +ysi;
%[x_csi ,y_csi] = line_line_intersection(xsi,ysi,l_toroid/2,curved_shock_last_angle_y, XYintercepts_b_last_ray_points_before_shock_n_top(1,1,6), XYintercepts_b_last_ray_points_before_shock_n_top(1,2,6),XYintercepts_2nd_shock_to p(1,1,6), XYintercepts_2nd_shock_top(1,2,6));


% marker

%For the top part of the shock wave past the shock intersection we let the
%initial x and y intercepts be the point of shock intersection, we do this
%because the first deflection angle comes from some streamline passing
%through that ray, even if it is not plotted, it is there
XYintercepts_curved_shock_top = zeros(1,5,streamlines_num+1);
XYintercepts_curved_shock_top(1,1,streamlines_num+1) = xsi;
XYintercepts_curved_shock_top(1,2,streamlines_num+1) = ysi;
XYintercepts_curved_shock_top(1,3,streamlines_num+1) = new_shock_deflection(1,2, y_rays_size+1); %ray_d_angle %%%%%% confirm this is the last ray shock ray_d_angle
XYintercepts_curved_shock_top(1,4,streamlines_num+1) = theta_s; %new_shock_deflection(1,1, y_rays_size+1); %shock deflection angle %%%%%%I think this first value should be theta_s

%theta_s;%

curved_shock_last_angle_y_top_first = (tan(theta_s)*((l_toroid_guess/2)- XYintercepts_curved_shock_top(1,1,streamlines_num+1)))+XYintercepts_curved_shock_t op(1,2, streamlines_num+1);
%curved_shock_last_angle_y_top_first = (tan(new_shock_deflection(1,1,y_rays_size+1))* ((l_toroid/2)-XYintercepts_curved_shock_top(1,1,streamlines_num+1))) +XYintercepts_curved_shock_top(1,2,streamlines_num+1);

%curved_shock_last_angle_y_top_first_test = (tan(theta_s)*((l_toroid/2)- XYintercepts_curved_shock_top(1,1,streamlines_num+1)))+XYintercepts_curved_shock_t op(1,2, streamlines_num+1)
%plot(l_toroid/2,curved_shock_last_angle_y_top_first_test,'-or')

XYintercepts_curved_shock_top(1,5,streamlines_num+1) = curved_shock_last_angle_y_top_first;
%$$start here
hello=8;

[XYintercepts_curved_shock_top(1,1,streamlines_num) ,XYintercepts_curved_shock_top(1,2, streamlines_num)] = line_line_intersection(XYintercepts_curved_shock_top(1,1,streamlines_num+1), XYintercepts_curved_shock_top(1,2,streamlines_num+1),l_toroid_guess/2, XYintercepts_curved_shock_top(1,5,streamlines_num+1), XYintercepts_b_last_ray_points_before_shock_n_top(1,1,streamlines_num), XYintercepts_b_last_ray_points_before_shock_n_top(1,2,streamlines_num),XYintercept s_2nd_shock_top (1,1,streamlines_num),XYintercepts_2nd_shock_top(1,2,streamlines_num));

hi=8;

%XYintercepts_b_last_ray_points_before_shock_n_top
%col 5 is some y value that corresponds with l_toroid/2, we use these
%values with a line line intersection routine to find when the next
%streamline intersects with the curved shock
for j=1:1:y_rays_size+1
for ind=1:1:streamlines_num
XYintercepts_curved_shock_top(1,5,streamlines_num+1-ind) = (tan (XYintercepts_curved_shock_top(1,4,streamlines_num+1-ind+1))*((l_toroid_guess/2)- XYintercepts_curved_shock_top(1,1,streamlines_num+1- ind+1)))+XYintercepts_curved_shock_top(1,5, streamlines_num+1-ind+1);
[XYintercepts_curved_shock_top(1,1,streamlines_num+1-ind) ,XYintercepts_curved_shock_top (1,2,streamlines_num+1-ind)] = line_line_intersection(XYintercepts_curved_shock_top(1,1, streamlines_num+1+1-ind),XYintercepts_curved_shock_top(1,2,streamlines_num+1+1- ind), l_toroid_guess/2,XYintercepts_curved_shock_top(1,5,streamlines_num+1-ind+1), XYintercepts_b_last_ray_points_before_shock_n_top(1,1,streamlines_num+1-ind), XYintercepts_b_last_ray_points_before_shock_n_top(1,2,streamlines_num+1-ind), XYintercepts_2nd_shock_top(1,1,streamlines_num+1- ind),XYintercepts_2nd_shock_top(1,2, streamlines_num+1-ind));
if new_shock_deflection(1,2,y_rays_size-j+1+1) == XYintercepts_b_last_ray_points_before_shock_n_top(1,3,streamlines_num-ind+1)
XYintercepts_curved_shock_top(1,3,streamlines_num+1-ind) = new_shock_deflection(1,2, y_rays_size-j+1+1);
XYintercepts_curved_shock_top(1,4,streamlines_num+1-ind) = new_shock_deflection(1,1, y_rays_size-j+1+1);
end
end
end



if plot_intersection_points == 1
for ind=1:1:streamlines_num+1
plot(XYintercepts_curved_shock_top(1,1,ind),XYintercepts_curved_shock_top(1,2,ind) , 'or')
end
end

%XYintercepts_curved_shock_bottom = XYintercepts_curved_shock_top

for ind=1:1:streamlines_num+1
XYintercepts_curved_shock_bottom(1,1,ind) = XYintercepts_curved_shock_top(1,1,ind);
XYintercepts_curved_shock_bottom(1,2,ind) = (ysi*2)- XYintercepts_curved_shock_top(1,2,ind);
XYintercepts_curved_shock_bottom(1,3,ind) = - 1*XYintercepts_curved_shock_top(1,3,ind);
XYintercepts_curved_shock_bottom(1,4,ind) = XYintercepts_curved_shock_top(1,4,ind);
XYintercepts_curved_shock_bottom(1,5,ind) = XYintercepts_curved_shock_top(1,5,ind);
end


if plot_intersection_points == 1
for ind=1:1:streamlines_num+1
plot(XYintercepts_curved_shock_bottom(1,1,ind),XYintercepts_curved_shock_bottom(1, 2, ind),'or')
end
end


%%%%% End prep curved shock data

%plot bottom streamlines from last x y intercepts to 2nd shock x y
%intercepts

if plot_streamlines == 1
for j=1:streamline_plotting_increment:streamlines_num
if XYintercepts_2nd_shock(1,1,j) < l_toroid_guess/2 %bottom bounds
line([XYintercepts_curved_shock_bottom(1,1,j) XYintercepts_b_last_ray_points_before_shock_n (1,1,j)],[XYintercepts_curved_shock_bottom(1,2,j) XYintercepts_b_last_ray_points_before_shock_n (1,2,j)], 'color',customCMAP(round(actual_temp(y_rays_size))-min_temp,:))
end
end
end

%top

if plot_streamlines == 1
for j=1:streamline_plotting_increment:streamlines_num
if XYintercepts_curved_shock_top(1,1,j) < l_toroid_guess/2 %bottom bounds
line([XYintercepts_curved_shock_top(1,1,j) XYintercepts_b_last_ray_points_before_shock_n (1,1,j)],[XYintercepts_curved_shock_top(1,2,j) inlet_diameter- XYintercepts_b_last_ray_points_before_shock_n(1,2,j)], 'color',customCMAP(round(actual_temp (y_rays_size))-min_temp,:))
end
end
end

%plot curved shockline top
for j=1:1:streamlines_num
line([XYintercepts_curved_shock_top(1,1,j) XYintercepts_curved_shock_top(1,1,j+1)], [XYintercepts_curved_shock_top(1,2,j) XYintercepts_curved_shock_top(1,2,j+1)], 'color','black')
end


%[x_top_shockline ,y_top_shockline]= line_line_intersection(0,inlet_sizedouble_ shockline_threshold,xsi,ysi-double_shockline_threshold,xsi,ysi,0,0);
%
% for j=1:1:streamlines_num
% line([XYintercepts_curved_shock_top(1,1,j) XYintercepts_curved_shock_top(1,1,j+1)], [XYintercepts_curved_shock_top(1,2,j)+double_shockline_threshold XYintercepts_curved_shock_top (1,2,j+1)+double_shockline_threshold],'Color','black')
% end


%plot curved shockline bottom
for j=1:1:streamlines_num
line([XYintercepts_curved_shock_bottom(1,1,j) XYintercepts_curved_shock_bottom(1,1,j+1)], [XYintercepts_curved_shock_bottom(1,2,j) XYintercepts_curved_shock_bottom(1,2, j+1)],'color','black')
end


%%%%%%%%%%%%%%%%%%%%%%%%2nd shock flowfield points bottom

%this adds the second shock deflection angle to the fourth colomn to the
%corasponding streamline %look here %may need to delete this or comment out
% DOUBLE CHECK v_PRIME_CURVED AND ACTUAL_TEMP ARE CORRECT VALUES needs to
% be fixded
for j=1:1:y_rays_size
for ind=1:1:streamlines_num+1
if ray_d_angle(y_rays_size-j+1) == XYintercepts_curved_shock_bottom(1,3,streamlines_numind+ 1+1)
XYintercepts_curved_shock_bottom(1,6,streamlines_num-ind+1+1) = 0; % was second_shock_theta_deflection(y_rays_size-j+1)
XYintercepts_curved_shock_bottom(1,7,streamlines_num-ind+1+1) = V_prime_curved(y_rays_sizeind+ 1);
XYintercepts_curved_shock_bottom(1,8,streamlines_num-ind+1+1) = actual_temp_intersection_region(y_rays_size-ind+1);
end
end
end

%bottom flowfield quivers
if plot_quivers == 1
for ind=1:streamline_plotting_increment:streamlines_num
if XYintercepts_curved_shock_bottom(1,1,ind) < l_toroid_guess/2
quiver(XYintercepts_curved_shock_bottom(1,1,ind),XYintercepts_curved_shock_bottom( 1,2, ind),XYintercepts_curved_shock_bottom(1,7,ind),0, 'linewidth' ,flowfield_linewidth, 'MaxHeadSize' , flowfield_MaxHeadSize, 'color',customCMAP(round(XYintercepts_curved_shock_bottom(1,8,ind))- min_temp,:))
end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%2nd shock flowfield points top

for j=1:1:y_rays_size
for ind=1:1:streamlines_num+1
if -ray_d_angle(y_rays_size-j+1) == XYintercepts_curved_shock_top(1,3,streamlines_numind+ 1+1)
XYintercepts_curved_shock_top(1,6,streamlines_num-ind+1+1) = 0 ; % was second_shock_theta_deflection(y_rays_size-j+1)
XYintercepts_curved_shock_top(1,7,streamlines_num-ind+1+1) = V_prime_curved(y_rays_sizeind+ 1) ;
XYintercepts_curved_shock_top(1,8,streamlines_num-ind+1+1) = actual_temp_intersection_region (y_rays_size-ind+1) ;
end
end
end

%top curved quivers

if plot_quivers == 1
for ind=1:streamline_plotting_increment:streamlines_num
if XYintercepts_curved_shock_top(1,1,ind) < l_toroid_guess/2
quiver(XYintercepts_curved_shock_top(1,1,ind),XYintercepts_curved_shock_top(1,2,in d), XYintercepts_curved_shock_top(1,7,ind),0, 'linewidth' ,flowfield_linewidth, 'MaxHeadSize' , flowfield_MaxHeadSize, 'color',customCMAP(round(XYintercepts_curved_shock_top(1,8,ind))- min_temp,:))
end
end
end




%here we use pchip to interlopate from the last point on the curved shock
%to in body of the vehicle


%theta_intersect(1,1:streamlines_num) = - 1*XYintercepts_curved_shock_top(1,3,1: streamlines_num);

theta_intersect_top_vec(1,1:streamlines_num) = -atan((inlet_diameter- XYintercepts_curved_shock_top(1,2,1:streamlines_num))./XYintercepts_curved_shock_t op(1,1,1: streamlines_num));


% theta_s
%
% theta_intersect
%
% theta_cone



XY_for_pchip_x_t(1,1:streamlines_num) = XYintercepts_curved_shock_top(1,1,1: streamlines_num);
x_intersect_inlet_top = pchip(theta_intersect_top_vec,XY_for_pchip_x_t,- theta_cone);

%theta_intersect(1,1:streamlines_num) = - 1*XYintercepts_curved_shock_top(1,3,1: streamlines_num);
XY_for_pchip_y_t(1,1:streamlines_num) = XYintercepts_curved_shock_top(1,2,1: streamlines_num);
y_intersect_inlet_top = pchip(theta_intersect_top_vec,XY_for_pchip_y_t,- theta_cone);

%theta_intersect(1,1:streamlines_num) = XYintercepts_curved_shock_bottom(1,3,1: streamlines_num);




theta_intersect_bottom_vec(1,1:streamlines_num) = atan(XYintercepts_curved_shock_bottom (1,2,1:streamlines_num)./XYintercepts_curved_shock_bottom(1,1,1:streamlines_num));

% theta_s
%
% theta_intersect_bottom_vec
%
% theta_cone


XY_for_pchip_x_b(1,1:streamlines_num) = XYintercepts_curved_shock_bottom(1,1,1: streamlines_num);
x_intersect_inlet_bottom = pchip(theta_intersect_bottom_vec,XY_for_pchip_x_b,theta_cone);

%theta_intersect(1,1:streamlines_num) = XYintercepts_curved_shock_bottom(1,3,1: streamlines_num);
XY_for_pchip_y_b(1,1:streamlines_num) = XYintercepts_curved_shock_bottom(1,2,1: streamlines_num);
y_intersect_inlet_bottom = pchip(theta_intersect_bottom_vec,XY_for_pchip_y_b,theta_cone);



%%%%%%%%%%% Busemann Geometry Curved Shocks %%%%%%%%%%%

%top
line([XYintercepts_curved_shock_top(1,1,1) x_intersect_inlet_top], [XYintercepts_curved_shock_top(1,2,1) y_intersect_inlet_top], 'color','black')

%bottom
line([XYintercepts_curved_shock_bottom(1,1,1) x_intersect_inlet_bottom], [XYintercepts_curved_shock_bottom(1,2,1) y_intersect_inlet_bottom], 'color','black')

%Double Shockline threshold
double_shockline_threshold = 0.1;

% bottom x_intersect_inlet_bottom y_intersect_inlet_bottom
line([x_intersect_inlet_bottom*2 0],[0 0], 'Color','black')
line([x_intersect_inlet_bottom 0],[y_intersect_inlet_bottom 0], 'Color','black')
line([x_intersect_inlet_bottom*2 x_intersect_inlet_bottom],[0 y_intersect_inlet_bottom], 'Color','black')

%fill(0,0,'black',l_toroid,0,'black',l_toroid/2,y_o,'black')

%theta shock bottom (r_inlet-r_throat_c)+2*r_throat_c
line([0 xsi],[0 ysi], 'Color','black')

[x_bottom_shockline ,y_bottom_shockline]= line_line_intersection(0,0 +double_shockline_threshold,xsi,ysi+double_shockline_threshold,xsi,ysi,0,inlet_dia meter);
line([0 x_bottom_shockline],[0+double_shockline_threshold y_bottom_shockline], 'Color','black')

% [x_bottom_shockline ,y_bottom_shockline]= line_line_intersection(0,0+.1,l_toroid/2, y_o+throat_size+.1,l_toroid/2,y_o+throat_size,0,inlet_size);
% line([0 x_bottom_shockline],[0+.1 y_bottom_shockline],'Color','black')

%line([0 l_toroid/2],[0+.1 y_o+throat_size+.1],'Color','black')

%theta shock top
%line([0 l_toroid/2],[inlet_size y_o],'Color','black')
line([0 xsi],[inlet_diameter ysi], 'Color','black')

[x_top_shockline ,y_top_shockline]= line_line_intersection(0,inlet_diameterdouble_ shockline_threshold,xsi,ysi-double_shockline_threshold,xsi,ysi,0,0);
line([0 x_top_shockline],[inlet_diameter-double_shockline_threshold y_top_shockline], 'Color','black')

% [x_top_shockline ,y_top_shockline]= line_line_intersection(0,inlet_size- .1,l_toroid/2,y_o- .1,l_toroid/2,y_o,0,0);
% line([0 x_top_shockline],[inlet_size-.1 y_top_shockline],'Color','black')

%line([0 l_toroid/2],[inlet_size-.1 y_o-.1],'Color','black')

%top x_intersect_inlet_top*2 y_intersect_inlet
line([x_intersect_inlet_top*2 0],[inlet_diameter inlet_diameter], 'Color','black')
line([x_intersect_inlet_top 0],[y_intersect_inlet_top inlet_diameter], 'Color','black')
line([x_intersect_inlet_top x_intersect_inlet_top*2] ,[y_intersect_inlet_top inlet_diameter ],'Color','black')

% Set graph to the limits of Busemann Geometry examined
xlim([0 x_intersect_inlet_bottom*2])
ylim([0 inlet_diameter])



%%%%%%%%% Output Values %%%%%%%%%%%%

y_o = y_intersect_inlet_bottom;

throat_size = y_intersect_inlet_top - y_intersect_inlet_bottom;

l_toroid = x_intersect_inlet_bottom*2;



%label inlet and nozzle regions
inlet_label = { 'inlet region' };
text(5,ysi,inlet_label, 'FontSize' ,20)

nozzle_label = { 'nozzle region' };
text((l_toroid/2) + 10,ysi,nozzle_label, 'FontSize' ,20)
