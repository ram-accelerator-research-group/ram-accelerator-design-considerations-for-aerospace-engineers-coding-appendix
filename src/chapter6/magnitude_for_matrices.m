function [magnitude_a_vec] = magnitude_for_matrices(a_mat)
%
% Usage:
% [magnitude_a_vec] = magnitude(a_mat)

disp('Finding the magnitudes of the vectors in the matrix...' )

a_sq_mat = a_mat .^ 2 ;

sum_a_sq_vec = sum(a_sq_mat,2) ;

magnitude_a_vec = sqrt(sum_a_sq_vec) ;

end
