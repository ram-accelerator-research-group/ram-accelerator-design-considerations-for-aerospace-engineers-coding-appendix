function [ delta,Mach_2 ] = delta_m2_behind_cone_shock( theta_s,Mach_inf,gamma )
%Usage:
% [ delta,Mach_2 ] = delta_m2_behind_cone_shock( theta_s,Mach_inf,gamma )
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
%
% PROGRAMMING NOTES
%
% This subroutine corresponds to step 1 of 5 in the algorithm for numerical
% flowfield calculations, as given by Anderson (Modern Compressible Flow,
% Ch. 10.4, pp. 371-2).
%
% The velocity component of the freestream Mach number orthogonal to the
% shockwave is calculated first, using eqn (4.7) from Anderson.

Mach_n_inf = Mach_inf * sin(theta_s) ;

% The deflection angle behind the shock is then computed using the
% theta-beta-M relationship, where the assumed shock wave angle theta_s
% stands in for beta. Also, the deflection angle behind the shock is termed
% delta rather than theta. (These substitutions follow Anderson's
% convention in Ch. 10 of Modern Compressible Flow.)

tbm_num = ( (Mach_inf^2) * (sin(theta_s)^2) ) - 1 ;

tbm_den = ( (Mach_inf^2) * (gamma+cos(2*theta_s)) ) + 2 ;

delta = atan( 2 * cot(theta_s) * (tbm_num/tbm_den) ) ;

% Using this information, the Mach number component of the shocked flow
% normal to, and immediately behind, the shockwave can be calculated, using
% eqn (4.10) from Anderson.

Mn2_num = (2/(gamma-1)) + (Mach_n_inf^2);

Mn2_den = ( (2*gamma/(gamma-1)) * (Mach_n_inf^2) ) - 1 ;

Mach_n_2 = sqrt( Mn2_num / Mn2_den ) ;

% Using this information, the absolute magnitude of the Mach number of the
% shocked flow immediately behind the shockwave can be calculated, using
% eqn (4.12) from Anderson.

Mach_2 = Mach_n_2 / sin (theta_s - delta) ;

end
