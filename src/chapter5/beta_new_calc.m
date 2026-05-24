function [ beta_new ] = beta_new_calc(mach,gamma,theta_oblique)
%lambda-kai-theta-beta-theta relation page 143 Modern Compressable Flow
% Note that theta_oblique comes from the theat in the oblique shock
% geometry diagram in Anderson on page 134, figure 4.7

term0lam = ((mach.^2)-1).^2;
term1lam = 1+((gamma-1)./2).*(mach.^2);
term2lam = 1+((gamma+1)./2).*(mach.^2);
term3lam = tan(theta_oblique).^2;

lambda = (term0lam-(3*(term1lam .* term2lam .* term3lam))).^.5;

term0kai = ((mach.^2)-1).^3;
term1kai = 1+(((gamma-1)./2).*(mach.^2));
term2kai_1 = 1;
term2kai_2 = ((gamma-1)./2).*(mach.^2);
term2kai_3 = ((gamma+1)./4).*(mach.^4);
term2kai = term2kai_1 + term2kai_2 + term2kai_3;
term3kai = tan(theta_oblique).^2;

kai = (term0kai - (9.*(term1kai.*( term2kai ).*term3kai)))./(lambda.^3);

%delta = 1 for weak shock solution
delta = 1;

term0beta = (mach.^2)-1;
term0cfun = (4.*pi.*delta)+acos(kai);
term1beta = 2.*lambda.*cos(term0cfun./3);

term2beta = 1+(((gamma-1)./2).*(mach.^2));

tbeta = (term0beta + term1beta)./(3.*term2beta.*tan(theta_oblique));

beta_new = atan(tbeta);

end
