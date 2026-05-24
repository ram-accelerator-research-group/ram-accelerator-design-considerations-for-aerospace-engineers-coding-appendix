function [ x_intersect_inlet_bottom , y_intersect_inlet_bottom , x_intersect_inlet_top , y_intersect_inlet_top , throat_size , l_toroid , xsi , ysi] = TM_Busemann_Dimensions( cone_half_angle_input , inlet_input , gamma_input , temp_input , pressure_input , Mach_input )
%
% Usage:
%
% [ x_intersect_inlet_bottom , y_intersect_inlet_bottom , x_intersect_inlet_top , y_intersect_inlet_top , throat_size , l_toroid , xsi , ysi] = TM_Busemann_Dimensions( cone_half_angle , inlet_input , gamma_input , temp_input , pressure_input , Mach_input )
%
% The purpose of this function is to return values needed for
% constructing a Busemann toroid based on calculating the shock angle for
% a specified cone using Taylor-Maccoll.

%%%%% Model Settings %%%%%%%%

inlet_size = inlet_input;
cone_half_angle = deg2rad(cone_half_angle_input);
theta_cone = cone_half_angle;

%Ram Tube
%Mach_inf = 4; %look at 2,

%Ignition tube
Mach_inf = Mach_input;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Hiroshima University Ram tube
%Page 107, Ram Accelerators, K. Takayama, A. Sasoh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Propellant = '1.4CH_4 + 2O_2 + 4.3CO_2';
gamma = gamma_input;
%freestream_enthalpy = 481.97*1000; % Units J/kg
%Sound_Speed = 299.60; %Units m/s
temp = temp_input; % Units Kelvin %Freestream Temperature
pressure = pressure_input; %Units Mpa %Freestream Pressure

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

%set the spead of rays in the system, the actual number of rays is less
%because we remove rays that go through the Busemann toroid
ray_spread = 200; %60
theta_num = ray_spread;

% %these values help with visibility of the flowfield arrows
% flowfield_linewidth = 3;
% flowfield_MaxHeadSize = 2; %2

theta_min = 0.01*(pi/180) ;
num_theta = theta_num;

%%%%%% Taylor Maccoll %%%%%%%%

[shock_half_angle, ...
theta_vec,V_prime_vec,Mach_prime_vec ...
partially_stagnated_P_vec,partially_stagnated_T_vec] = ...
given_supersonic_cone_find_shock_4(cone_half_angle,num_theta, ...
Mach_inf,P_inf,T_inf,gamma)

%for cone method %%%%%%%
theta_s = shock_half_angle;
theta_max = theta_s;

%%%%%% Shock Intersection %%%%%%%

xsi = (inlet_size/2)/tan(theta_s);
ysi = (inlet_size/2);

%%% Planar Shock at shock intersection means xsi = l_toroid/2

l_toroid = xsi * 2;

x_intersect_inlet_bottom = xsi;
y_intersect_inlet_bottom = tan(theta_cone) * xsi;

x_intersect_inlet_top = xsi;
y_intersect_inlet_top = ysi + (ysi - y_intersect_inlet_bottom);

y_o = y_intersect_inlet_bottom;

throat_size = y_intersect_inlet_top - y_intersect_inlet_bottom;

end
