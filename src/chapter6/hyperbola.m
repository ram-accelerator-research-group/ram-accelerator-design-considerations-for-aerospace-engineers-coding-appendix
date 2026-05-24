function [y_neg_vec,y_pos_vec] = hyperbola(a,b,x_vec)
%
% The purpose of this function is to plot the positive half of a
% hyperbola that is centered on the origin, whose functional form is
% given by the formula
% x^2/a^2 - y^2/b^2 = 1.
%
% Usage:
% [y_neg_vec,y_pos_vec] = hyperbola(a,b,x_vec)

% Generate the +y branch of the hyperbola.

y_pos_vec = sqrt( (b^2) .* ( ((x_vec.^2)/(a^2)) - 1 ) ) ;

% Generate the -y branch of the hyperbola.

y_neg_vec = -y_pos_vec ;

end
