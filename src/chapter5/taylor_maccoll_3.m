function [ V_prime_deriv_vec ] = taylor_maccoll_3( theta,V_prime_vec,gamma )
%
% Usage:
%
% [ V_prime_deriv_vec ] = taylor_maccoll_3( theta,V_prime_vec,gamma )
%
% The purpose of this function is to provide an expression of the
% Taylor-MacColl equation, as given via eqn. 10.15 in Anderson's
% Modern Compressible Flow, 3rd ed. More specifically, it is meant to
% solve for the first and second derivative of the nondimensionalized
% radial velocity of supersonic flow over a quasi-infinite cone, with
% respect to the theta variable. The numerical solutions to the equation
% are then determined using a solver such as ode23.
%
% This routine is based on the function "taymaceqn" written by Sercome
% and Buttsworth ("Transverse Injection From A Hypersonic Cone", 2004;
% p. 110), with corrections being made for an apparent sign
% error in the original code.
%
% Input terms:
% theta=; V_prime_vec=; gamma=;
% where
% theta = the angle between the axis of the cone and the
% flow direction of interest;
% V_prime_vec = [ V_prime_r, V_prime_theta ]
% where
% V_prime_r = nondimensionalized radial
% velocity of supersonic flow
% over the cone;
% and
% V_prime_theta = dV_prime_r_over_dtheta
% (eqn. 10.14, Anderson)
% = nondimensionalized angular
% velocity of supersonic flow
% over the cone;
% and
% gamma = the ratio of specific heats for the gas through
% which the cone is flying.
%
% Output terms:
% [ V_prime_theta
% dV_prime_theta_over_dtheta ]
%
% = [ dV_prime_r_over_dtheta
% dV_prime_theta_over_dtheta ]
%
% = [ dV_prime_r_over_dtheta
% d2V_prime_r_over_dtheta2 ]

theta = theta;

V_prime_deriv_prelim_vec = zeros(2,1);

% Set dV_prime_r_over_dtheta = V_prime_theta, as in equation 10.14 by
% Anderson.

dV_prime_r_over_dtheta = V_prime_vec(2);

V_prime_deriv_prelim_vec(1,1) = dV_prime_r_over_dtheta;

% Set V_prime_r.

V_prime_r = V_prime_vec(1);

a = (gamma-1)/2;

% Define the B term. This term is equal to the
% [1 - V_prime_r^2 + (dV_prime_r/dtheta)^2]
% term in eqn. (10.15).

B_term = 1 - ( (V_prime_r) .^ 2 ) - ( (dV_prime_r_over_dtheta) .^ 2 ) ;

c_term_1 = ( -a .* B_term .* ( (2.*V_prime_r) + (dV_prime_r_over_dtheta.*cot(theta)) ) ) ;

c_term_2 = ((dV_prime_r_over_dtheta).^2) .* (V_prime_r) ;

c = c_term_1 + c_term_2 ;

d_term_1 = a.*B_term;

d_term_2 = ( -( (dV_prime_r_over_dtheta) .^ 2 ) ) ;

d = d_term_1 + d_term_2;

%V_prime_deriv_prelim_vec(2,1) = c./d;

d2V_prime_r_over_dtheta2 = c./d;

V_prime_deriv_prelim_vec(2,1) = d2V_prime_r_over_dtheta2;

V_prime_deriv_vec = V_prime_deriv_prelim_vec;

end
