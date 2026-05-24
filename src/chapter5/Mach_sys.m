function [ mach ] = Mach_sys(gamma,V_prime_c)
%From page 371 in Anderson MCF.
% From equation 10.16, rearranged to solve for Mach
%
% Use:
% [ mach ] = Mach_sys(gamma,V_prime_c)
%
term0 = sqrt(2).*V_prime_c;
term1 = sqrt(gamma-1-((V_prime_c.^2)*gamma)+(V_prime_c.^2));

mach = term0./term1;
end
