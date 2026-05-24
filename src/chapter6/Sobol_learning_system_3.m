function [aug_Sobol_mat] = Sobol_learning_system_3(aug_Sobol_mat,row_num,is_good)
%
% The purpose of this function is to take, as input, an augmented Sobol
% set matrix, along with a given row index in that matrix, and whether or
% not that row is considered to return "good" (i.e. non-obstructed)
% values in a view factor context. It will then return, as output, a
% re-weighted version of the augmented matrix, based on that input.
%
% Input terms:
%
% aug_Sobol_mat = a matrix, where each row is structured as follows:
%
% [s1(index_num),s2(index_num),s3(index_num),s4(index_num),probability_ranking]
%
% where
%
% s1(index_number) et al.
% = numbers, in the (0,1) domain, from the 4-
% dimensional Sobol set being used to select
% coordinates within a view factor problem;
%
% and
%
% probability_ranking
% = a number, in the (0,1) domain, expressing the
% probability that a given row will be accepted for
% a Monte Carlo step in a view factor calculation.
%

% PROGRAMMING NOTES
%
% This routine takes and returns the revised aug_Sobol_mat
% format (i.e. without index numbers)
% being used by aug_Sobol_select_8 et al.

% HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
% DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%
% Hamming Distance Calculation
%
% HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
% DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

% Initialize the vectors for approximating distances between points in
% Sobol space.

dist_vec = ones( max(size(aug_Sobol_mat)), 1 ) ;

abs_delta_s1_vec = ones( max(size(aug_Sobol_mat)), 1 ) ;

abs_delta_s2_vec = ones( max(size(aug_Sobol_mat)), 1 ) ;

abs_delta_s3_vec = ones( max(size(aug_Sobol_mat)), 1 ) ;

abs_delta_s4_vec = ones( max(size(aug_Sobol_mat)), 1 ) ;

% For each row past row_num, estimate the distance between that Sobol
% vector and the Sobol vector at row_num.

coming_rows_vec = row_num+1:1:max(size(aug_Sobol_mat)) ;

abs_delta_s1_vec(coming_rows_vec,1) = abs ( aug_Sobol_mat(row_num,2) - aug_Sobol_mat (coming_rows_vec,1) ) ;

abs_delta_s2_vec(coming_rows_vec,1) = abs ( aug_Sobol_mat(row_num,3) - aug_Sobol_mat (coming_rows_vec,2) ) ;

abs_delta_s3_vec(coming_rows_vec,1) = abs ( aug_Sobol_mat(row_num,4) - aug_Sobol_mat (coming_rows_vec,3) ) ;

abs_delta_s4_vec(coming_rows_vec,1) = abs ( aug_Sobol_mat(row_num,5) - aug_Sobol_mat (coming_rows_vec,4) ) ;

dist_vec(coming_rows_vec,1) = 0.25 * ( abs_delta_s1_vec(coming_rows_vec,1) + abs_delta_s2_vec(coming_rows_vec,1) + abs_delta_s3_vec(coming_rows_vec,1) + abs_delta_s4_vec (coming_rows_vec,1) ) ;

% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
%
% Sort and Reweight
%
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR

% Sort the rows past row_num in order of their increasing Sobol-set
% distance from row_num.

%[~,sorted_dist_ind_vec] = sort(dist_vec(coming_rows_vec,1),'ascend') ;

%sorted_dist_ind_vec = sorted_dist_ind_vec + row_num ;

%aug_Sobol_mat(coming_rows_vec,:) = aug_Sobol_mat(sorted_dist_ind_vec,:) ;

prob_pos_reweighting_factor = 0.0025 ;

prob_neg_reweighting_factor = 0.0025 ;

% Reweight the probabilities for up to the first 48 rows past row_num.

if max(size(aug_Sobol_mat)) - row_num >= 48
num_reweighted_rows = 48 ;
else
if and ( (max(size(aug_Sobol_mat)) - row_num) < 48 , (max(size(aug_Sobol_mat)) - row_num) > 0 )
num_reweighted_rows = max(size(aug_Sobol_mat)) - row_num ;
else
num_reweighted_rows = 0 ;
end
end

% If the number of reweighted rows is greater than zero....

if num_reweighted_rows > 0
% ...find the (number of reweighted rows) smallest distances between
% the point pair at row_num and the other point pairs in the coming
% rows.

[~,min_dist_ind_vec] = mink(dist_vec(coming_rows_vec,1),num_reweighted_rows) ;

for reweight_probs_itr = 1:1:num_reweighted_rows
if is_good == 1
% Increase the probability ranking by some percent of the distance
% between itself and 1.
aug_Sobol_mat(row_num+min_dist_ind_vec(reweight_probs_itr),5) = aug_Sobol_mat (row_num+min_dist_ind_vec(reweight_probs_itr),5) + ((1- aug_Sobol_mat(row_num+min_dist_ind_vec (reweight_probs_itr),5))*prob_pos_reweighting_factor) ;
else
% Decrease the probability ranking by some percent of the distance
% between itself and 0.
aug_Sobol_mat(row_num+min_dist_ind_vec(reweight_probs_itr),5) = aug_Sobol_mat (row_num+min_dist_ind_vec(reweight_probs_itr),5) - (aug_Sobol_mat(row_num+min_dist_ind_vec (reweight_probs_itr),5)*prob_neg_reweighting_factor) ;
end
end

else
end

end
