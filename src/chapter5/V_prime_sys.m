function [ V_prime_c ] = V_prime_sys(V_prime_r_vec,V_prime_theta_vec)
%
%
% Use;
% [ V_prime_c ] = V_prime_sys(V_prime_r_vec,V_prime_theta_vec)
%

V_prime_c = sqrt((V_prime_r_vec.^2)+(V_prime_theta_vec.^2));

end
