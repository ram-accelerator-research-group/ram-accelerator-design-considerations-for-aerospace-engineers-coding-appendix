function [ delta ] = delta_behind_cone_shock( theta_s,Mach_inf,gamma )
%
% Usage:
%
% [ delta ] = delta_behind_cone_shock( theta_s,Mach_inf,gamma )
%
% The purpose of this function is to return values for the Mach number
% and deflection angle directly behind an oblique shockwave on a
% supersonic cone at zero angle of attack, given an initial shockwave
% angle, a freestream Mach number, and the gamma value for the gas the
% cone is travelling through.
%
% Input terms:
% theta_s=; Mach_inf=; gamma=;
% where
% theta_s = the angle of the shockwave (in radians);
% Mach_inf = the freestream Mach number; and
% gamma = the ratio of specific heats of the gas (unitless).

% PROGRAMMING NOTES
%
% 1) This subroutine corresponds to step 1 of 5 in the algorithm for numerical
% flowfield calculations, as given by Anderson (Modern Compressible Flow,
% Ch. 10.4, pp. 371-2).

% The deflection angle behind the shock is then computed using the
% theta-beta-M relationship, where the assumed shock wave angle theta_s
% stands in for beta. Also, the deflection angle behind the shock is termed
% delta rather than theta. (These substitutions follow Anderson's
% convention in Ch. 10 of Modern Compressible Flow.)

tbm_num = ( (Mach_inf^2) * (sin(theta_s)^2) ) - 1 ;

tbm_den = ( (Mach_inf^2) * (gamma+cos(2*theta_s)) ) + 2 ;

delta = atan( 2 * cot(theta_s) * (tbm_num/tbm_den) ) ;

end
