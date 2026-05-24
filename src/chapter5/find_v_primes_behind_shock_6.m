function [ V_prime_r_vec,V_prime_theta_vec,theta_vec ] = ...
find_v_primes_behind_shock_6( theta_max,theta_min,num_theta, ...
V_prime_r_at_theta_max,V_prime_theta_at_theta_max, ...
gamma )
%
% The purpose of this function is to determine the velocity components of
% the supersonic flow over a quasi-infinite cone, in the region behind
% the cone's shock wave. This is done by solving the Taylor-MacColl
% equation numerically, with the shock-wave angle and nondimensionalized
% velocity behind the shock being used as boundary values.
%_
% Usage:
%
% [ V_prime_r_vec,V_prime_theta_vec,theta_vec ] = ...
% find_v_primes_behind_shock_6( theta_max,theta_min,num_theta,...
% V_prime_r_at_theta_max,V_prime_theta_at_theta_max,...
% gamma )

% This subroutine corresponds to steps 3-4 of 5 in the algorithm for numerical
% flowfield calculations, as given by Anderson (Modern Compressible Flow,
% Ch. 10.4, pp. 371-2).

% PROGRAMMING NOTES
%
%
% 1) This routine differs from its predecessor,
% find_v_primes_behind_shock_5, in that all code for conditioning the
% output has been removed. This ensures that both physically valid,
% positive V_prime_theta values, and unphysical, negative
% V_prime_theta values, will be returned by this routine.
%
% Returning both types of V_prime_theta values facilitates this
% routine's use in the iterative stage of
% given_theta_shock_find_theta_cone_4, as the latter routine uses
% progressively-narrower integration ranges with ode113 to home in
% on the correct value of theta_cone.
%
%
% 2) This routine calls the following non-MATLAB subroutines:
%
% taylor_maccoll_3

theta_vec = theta_max:-(theta_max - theta_min)/(num_theta-1):theta_min;

% A second row vector is set up to specify the initial conditions, in terms
% of nondimensionalized flow velocities directly behind the shock.

V_prime_ic_vec = [V_prime_r_at_theta_max,-V_prime_theta_at_theta_max];

%MATLAB CORE Create or modify options structure for ODE and PDE solvers
options = odeset( 'RelTol',1e-5,'AbsTol',1e-8);

%[theta_vec,V_prime_vec] = ode113(@(theta_vec,V_prime_vec)taylor_maccoll_3( theta_vec, V_prime_vec,gamma ),theta_vec,V_prime_ic_vec,options);

%Solve stiff differential equations and DAEs — variable order method %say
%somthing about tolerances %%ERROR

[theta_vec,V_prime_vec] = ode15s(@(theta_vec,V_prime_vec)taylor_maccoll_3( theta_vec, V_prime_vec,gamma ),theta_vec,V_prime_ic_vec,options);

% Condition the output results so that the velocities returned are listed
% in order of ascending theta values.

theta_vec = flipud(theta_vec);

V_prime_r_vec = flipud(V_prime_vec(:,1)) ;

V_prime_theta_vec = -flipud(V_prime_vec(:,2)) ;

end
