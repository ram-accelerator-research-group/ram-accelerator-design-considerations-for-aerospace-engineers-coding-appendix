
function actual_temp = actual_temp_relationship(Mach_inf,mach,gamma,temp)
%
%page 80 MCF by anderson (3.28)
%
% Use:
%
% actual_temp = actual_temp_relationship(Mach_inf,mach,gamma,temp)
%

delta_M = Mach_inf - mach;
delta_M_squared = delta_M.^2;
term0 = 1;
term1 = ((gamma-1)/2).*delta_M_squared;

actual_temp = (term0 + term1).*temp;

end
