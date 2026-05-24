function [shock_half_angle, ...
theta_vec,V_prime_vec,Mach_vec, ...
partially_stagnated_P_vec,partially_stagnated_T_vec] = ...
given_supersonic_cone_find_shock_4(cone_half_angle,num_theta, ...
Mach_inf,P_inf,T_inf,gamma)
%
% This function takes, as input, the Mach number and angle of a
% supersonic cone flying through an atmosphere with zero angle of attack,
% along with the properties of that atmosphere. It returns, as output,
% the resulting shock wave angle created by that cone, along with the
% flow velocities, partially stagnated pressures, and partially stagnated
% temperatures created by that shock.
% This is done by using the Taylor-MacColl codes to find the cones that
% support various conical shocks, then implementing a root-finding
% algorithm to home in on the shock supported by the specified cone.
%
% Input terms:
%
% cone_half_angle = ; num_theta = ;
% Mach_inf = ; P_inf = ; T_inf = ; gamma = ;
%
% where
%
% cone_half_angle = the angular distance, in radians, from the central
% axis of the cone to its outer surface;
%
% num_theta = the number of theta values, from the shock wave
% to the cone, that flowfield calculations should be
% done at;
%
% Mach_inf = the freestream Mach number of the atmospheric gas
% the cone is flying through;
%
% P_inf = the freestream pressure of the atmospheric gas the
% cone is flying through;
%
%
% T_inf = the freestream temperature of the atmospheric gas
% the cone is flying through;
%
% and
%
% gamma = the heat capacity ratio of the atmospheric gas the
% cone is flying through.
%
% Usage:
%
% [shock_half_angle,...
% theta_vec,V_prime_vec,Mach_prime_vec...
% partially_stagnated_P_vec,partially_stagnated_T_vec] = ...
% given_supersonic_cone_find_shock_4(cone_half_angle,num_theta,...
% Mach_inf,P_inf,T_inf,gamma)

% PROGRAMMING NOTES
%
% This routine directly calls the following non-MATLAB subroutines:
%
% m2_behind_cone_shock
% delta_behind_cone_shock
% given_theta_shock_find_theta_cone_4
% delta_m2_behind_cone_shock
% V_prime_r_theta
% find_v_primes_behind_shock_6
% StagPress
% StagTemp
%
%
% This routine indirectly calls the following non-MATLAB subroutines:
%
% taylor_maccoll_3 (via: given_theta_shock_find_theta_cone_4,
% find_v_primes_behind_shock_6)

tic

% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
%
% Validation
%
% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

% Validate the data input.

if cone_half_angle < 0
error( 'The half-angle of the cone must be no lower than zero.' )
else
if isreal(cone_half_angle)==0
error( 'The half-angle of the cone must be a real number.' )
else
if cone_half_angle > pi/2
error( 'The half-angle of the cone must be no larger than pi/2.' )
else
end
end
end

if Mach_inf < 1
error( 'The freestream Mach number must be no lower than one.' )
else
if isreal(Mach_inf)==0
error( 'The freestream Mach number must be a real number.' )
else
end
end

if T_inf < 0
error( 'The freestream temperature must be no lower than zero.' )
else
if isreal(T_inf)==0
error( 'The freestream temperature must be a real number.' )
else
end
end

if P_inf < 0
error( 'The freestream pressure must be no lower than zero.' )
else
if isreal(P_inf)==0
error( 'The freestream pressure must be a real number.' )
else
end
end

if num_theta <= 0
error( 'The number of angular locations within the flowfield must be at least one.' )
else
if isreal(num_theta)==0
error( 'The number of angular locations within the flowfield must be a real number.' )
else
if mod(num_theta,1) >= 1e-12
error( 'The number of angular locations within the flowfield must be a whole number.')
else
end
end
end

% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
% LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
% OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
%
% Find Upper and Lower Limits of Shock Angle
%
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
% LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
% OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

% Before a rootfinding search for the correct shock angle / cone angle
% combo can be performed, the upper and lower limits of acceptable shock
% angle values must be determined for the given freestream Mach number and
% atmospheric gamma value.

% The lowest acceptable shock angle will be the one that gives a Mach
% number behind the shock which is exactly equal to the freestream Mach
% number. Spuriously low shock angles may be identified by the following
% characteristics:
% 1) negative delta values;
% 2) imaginary values of M2; and / or
% 3) values of M2 in excess of the freestream Mach number.

fun1 = @(theta_s) abs(Mach_inf - real(m2_behind_cone_shock( theta_s,Mach_inf,gamma ))) ;

theta_s_lower = fminbnd(fun1,0,pi/2)

% The highest acceptable shock angle will be the one that gives the largest
% possible value of delta. Spuriously high shock angles will result in
% decreases in the angle of flow deflection, corresponding to the detached,
% bow-shock / strong-shock solution.

fun2 = @(theta_s) abs(delta_behind_cone_shock( theta_s,Mach_inf,gamma ) - delta_behind_cone_shock( (theta_s+0.001),Mach_inf,gamma )) ;

theta_s_upper = fminbnd(fun2,theta_s_lower,pi/2) + 0.0005

% Once the range of valid shock wave angles is known, these can be used, in
% conjunction with a cone-angle-finding subroutine, to determine the
% shock wave angle that corresponds to the actual cone being used.

fun3 = @(theta_s) abs(cone_half_angle - given_theta_shock_find_theta_cone_4( theta_s, Mach_inf,gamma )) ;

shock_half_angle = fminbnd(fun3,theta_s_lower,theta_s_upper) ;

% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
% MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%
% Taylor-MacColl
%
% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
% MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

% Given the true value of theta_s, back out all the other terms associated
% with this supersonic cone by running through the Taylor-MacColl relations
% one more time.

% First, calculate the deflection angle and Mach number for the slowed-down
% flow immediately behind the shock.

[ delta,Mach_2 ] = delta_m2_behind_cone_shock( shock_half_angle,Mach_inf,gamma ) ;

% Second, using this information, find the normal and radial components of
% the flow velocity immediately behind the shock.

[ ~,V_prime_r_at_theta_max,V_prime_theta_at_theta_max ] = V_prime_r_theta( shock_half_angle, delta,Mach_2,gamma ) ;

% Third, use this information to calculate the flowfield behind the shock,
% by working inward from the shock toward the cone. The angle at which the
% V_prime_theta = 0 must be the angle of the cone. (Anderson, p. 371)

[ V_prime_r_vec,V_prime_theta_vec,theta_vec ] = ...
find_v_primes_behind_shock_6( shock_half_angle,cone_half_angle,num_theta, ...
V_prime_r_at_theta_max,V_prime_theta_at_theta_max, ...
gamma ) ;

% Once their two orthogonal velocity components are known, the V_primes for
% all theta values can be computed.

V_prime_vec = sqrt( (V_prime_r_vec.^2) + (V_prime_theta_vec.^2) ) ;

% The associated Mach numbers can now be computed, using eq. 10.16 from
% Anderson (p. 371).

rad_den_vec = ( ( (V_prime_vec.^-2) - 1 ) * ( gamma - 1 ) ) ;

Mach_vec = sqrt( 2 ./ rad_den_vec ) ;

% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
%
% Partial Stagnation Relationships
%
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR

% Standard "calorically perfect," ideal-gas relationships can then be used
% to determine the stagnated pressures and temperatures behind the shock.

delta_Mach_vec = Mach_inf - Mach_vec ;

[ partially_stagnated_P_vec ] = StagPress(P_inf,gamma,delta_Mach_vec) ;

[ partially_stagnated_T_vec ] = StagTemp(T_inf,gamma,delta_Mach_vec) ;

toc

end
