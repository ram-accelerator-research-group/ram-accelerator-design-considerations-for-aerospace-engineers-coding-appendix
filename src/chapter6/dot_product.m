function [a_dot_b] = dot_product(a_vec,b_vec)
%
% Usage:
% [a_dot_b] = dot_product(a_vec,b_vec)
%
vector_prod = a_vec .* b_vec ;

a_dot_b = sum(vector_prod) ;

end
