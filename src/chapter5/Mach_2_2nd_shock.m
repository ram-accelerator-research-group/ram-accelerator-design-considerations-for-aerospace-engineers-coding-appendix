
function M_2_2nd_shock = Mach_2_2nd_shock(mach,beta_old,gamma,theta_M_1_cart)

%page 135 MCF by anderson
%

%first we need to find Mn1

Mn1 = mach.*sin(beta_old); %4.7

term0l = Mn1.^2;
term0r = 2/(gamma-1);
term1l = ((2*gamma)/(gamma-1)).*(Mn1.^2);
term1r = 1;

%4.10 Anderson Page 135

top = term0l+term0r;
bottom = term1l-term1r;
Mn2 = sqrt(top./bottom);

M_2_2nd_shock = Mn2./sin(beta_old-theta_M_1_cart);

end
