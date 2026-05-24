function [theta_cone] = given_theta_shock_find_theta_cone_4( theta_s,Mach_inf,gamma )
%
% The purpose of this function is to find the angle of a cone that
% supports a specified shock wave, given a particular Mach number of
% flight, and a known gamma for the atmosphere it is flying through.
%
% This is done by carrying out a restricted version of steps 1-4 in Anderson's
% procedure for the numerical solution of the Taylor-MacColl equations
% (Modern Compressible Flow, 3rd ed, pp. 371-372).
%
% We use Piecewise Cubic Hermite Interpolating Polynomial (PCHIP)interpolation to find theta_cone.
%
% Usage:
% [theta_cone] = given_theta_shock_find_theta_cone_4( theta_s,Mach_inf,gamma )
%
% PROGRAMMING NOTES
%
% This routine calls the following non-MATLAB subroutines:
%
% delta_m2_behind_cone_shock
% V_prime_r_theta
% find_v_primes_behind_shock_6
% Set theta_num at line 69

% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
% MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
%
% Initial Taylor-MacColl Steps
%
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
% MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS

% First, calculate the deflection angle and Mach number for the slowed-down
% flow immediately behind the shock.

[ delta,Mach_2 ] = delta_m2_behind_cone_shock( theta_s,Mach_inf,gamma );

% Second, using this information, find the normal and radial components of
% the flow velocity immediately behind the shock.

[ ~,V_prime_r,V_prime_theta ] = V_prime_r_theta( theta_s,delta,Mach_2,gamma ) ;

% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
%
% Iterative V_prime Solver
%
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS

% Third, use this information to calculate the flowfield behind the shock,
% by working inward from the shock toward the cone. The angle at which the
% V_prime_theta = 0 must be the angle of the cone. (Anderson, p. 371)

theta_max = theta_s;

theta_min = 0.01*(pi/180) ;

theta_num = 10000 ;

V_prime_r_at_theta_max = V_prime_r ;

V_prime_theta_at_theta_max = V_prime_theta ;

for num_itr = 1:1:10

disp( ' ')
sprintf( 'This is iteration number %d.' ,num_itr)
disp( ' ')

[ V_prime_r_vec,V_prime_theta_vec,theta_vec ] = ...
find_v_primes_behind_shock_6( theta_max,theta_min,theta_num, ...
V_prime_r_at_theta_max,V_prime_theta_at_theta_max, ...
gamma )

% Find the center of the negative V_prime_theta_values.

neg_V_prime_theta_ind_vec = find(V_prime_theta_vec<0)

max_neg_V_prime_theta_ind = max(neg_V_prime_theta_ind_vec)

ind_middle_neg_V_prime_theta = floor(max_neg_V_prime_theta_ind/2)

% Reset theta_min to the angle that occurs at the center of the
% negative V_prime_theta range.

theta_min = theta_vec(ind_middle_neg_V_prime_theta,1) ;

% Find the center of the positive V_prime_theta values.

ind_middle_pos_V_prime_theta = ceil( (max_neg_V_prime_theta_ind + 1 + max(size (theta_vec))) / 2 )

% Reset theta_max to the angle that occurs at the center of the
% positive V_prime_theta range.

theta_max = theta_vec(ind_middle_pos_V_prime_theta,1) ;

% Reset the initial conditions of V_prime_r and V_prime_theta to those
% that hold at the center of the positive V_prime_theta range.

V_prime_r_at_theta_max = V_prime_r_vec(ind_middle_pos_V_prime_theta,1) ;

V_prime_theta_at_theta_max = V_prime_theta_vec(ind_middle_pos_V_prime_theta,1) ;

end

disp( ' ')
disp( 'Leaving iterative step.' )
disp( ' ')

% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%
% Generate Theta_Cone
%
% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

% Using interpolation, estimate the theta and V_prime_r values at the
% surface of the cone. (The V_prime_theta value at the surface of the cone
% must, by definition, be zero; see Anderson, p. 371.)

% Do interpolation to find theta_cone.
% Piecewise Cubic Hermite Interpolating Polynomial (PCHIP)

theta_cone = pchip(V_prime_theta_vec,theta_vec,0);

end
