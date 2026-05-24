function [obs_truth_mat] = make_and_expand_truth_matrix(xyz_overlap_ind_mat,obs_surf_x_mat)
%
% The purpose of this function is twofold.
%
% First, it takes the n-by-2
% matrix of (row,column) values, describing points on an obstructing
% surface, that are overlapped by the bounding box of an intersecting
% ray. It then constructs a meshgrid-sized truth matrix, with "1"s
% entered at the locations of the overlapping points, and zeros
% everywhere else.
%
% Second, it takes this truth matrix and "expands" it, by ensuring that
% all these truth-value points are surrounded on all sides by one
% additional point.
%
% Usage:
% [obs_truth_mat] = make_and_expand_truth_matrix(xyz_overlap_ind_mat,obs_surf_x_mat)
%
% Use this information to construct a truth
% matrix, where each location in the meshgrid
% that is overlapped by the ray bounding box is
% 1, and every other location is 0.

obs_truth_mat = zeros(size(obs_surf_x_mat)) ;

[obs_mat_row_num,obs_mat_col_num] = size(obs_surf_x_mat) ;

for overlap_itr = 1:1:max(size(xyz_overlap_ind_mat))
size_obs_truth_mat = size(obs_truth_mat) ;
size_xyz_overlap_ind_mat = size(xyz_overlap_ind_mat) ;
%overlap_itr
obs_truth_mat(xyz_overlap_ind_mat(overlap_itr,1),xyz_overlap_ind_mat(overlap_itr,2 )) = 1 ;
end

% Fill in the blank spaces around the "overlap"
% truth values, to ensure that any ray at the
% boundary will be properly detected in the
% subsequent "line intersection" steps.

[obs_truth_mat_row_num,obs_truth_mat_col_num] = size(obs_truth_mat) ;

for i = 1:1

% Construct the four difference matrices--two
% rectilinear, two diagonal--needed to detect
% the edges of the overlapping points domain
% within the matrix.

horz_diff_mat = diff(obs_truth_mat,1,2) ;

vert_diff_mat = diff(obs_truth_mat,1,1) ;

diag_diff_LL_minus_UR_mat = conv2(obs_truth_mat,[0,1;-1,0], 'valid') ;

diag_diff_LR_minus_UL_mat = conv2(obs_truth_mat,[1,0;0,-1], 'valid') ;

% Put a 6 to the left of every 1 without a
% left-hand neighbor.

six_pre_mat = horz_diff_mat ;

six_pre_mat(six_pre_mat<0) = 0 ;

six_pre_mat = horzcat(six_pre_mat,zeros(obs_truth_mat_row_num,1)) ;

six_mat = 6.* six_pre_mat ;

obs_truth_mat = obs_truth_mat + six_mat ;

% Put a 2 to the right of every 1 without a
% right-hand neighbor.

two_pre_mat = -horz_diff_mat ;

two_pre_mat(two_pre_mat<0) = 0 ;

two_pre_mat = horzcat(zeros(obs_truth_mat_row_num,1),two_pre_mat) ;

two_mat = 2.* two_pre_mat ;

obs_truth_mat = obs_truth_mat + two_mat ;

% Put a 4 directly above every 1 without an
% neighbor above it.

four_pre_mat = vert_diff_mat ;

four_pre_mat(four_pre_mat<0) = 0;

four_pre_mat = vertcat(four_pre_mat,zeros(1,obs_truth_mat_col_num)) ;

four_mat = 4 .* four_pre_mat ;

obs_truth_mat = obs_truth_mat + four_mat ;

% Put an 8 directly below every 1 without an
% neighbor below it.

eight_pre_mat = -1 .* vert_diff_mat ;

eight_pre_mat(eight_pre_mat<0) = 0 ;

eight_pre_mat = vertcat(zeros(1,obs_truth_mat_col_num),eight_pre_mat) ;

eight_mat = 8.* eight_pre_mat ;

obs_truth_mat = obs_truth_mat + eight_mat ;

% Put a 3 diagonally above and to the right of
% every 1 without a neighbor there.

three_pre_mat = diag_diff_LL_minus_UR_mat ;

three_pre_mat(three_pre_mat < 0) = 0 ;

three_pre_mat = horzcat(zeros(obs_truth_mat_row_num-1,1),three_pre_mat) ;

three_pre_mat = vertcat(three_pre_mat,zeros(1,obs_truth_mat_col_num)) ;

three_mat = 3 .* three_pre_mat ;

obs_truth_mat = obs_truth_mat + three_mat ;

% Put a 7 diagonally down and to the left of
% every 1 without a neighbor there.

seven_pre_mat = -diag_diff_LL_minus_UR_mat ;

seven_pre_mat(seven_pre_mat<0) = 0 ;

seven_pre_mat = horzcat(seven_pre_mat,zeros(obs_truth_mat_row_num-1,1)) ;

seven_pre_mat = vertcat(zeros(1,obs_truth_mat_col_num),seven_pre_mat) ;

seven_mat = 7 .* seven_pre_mat ;

obs_truth_mat = obs_truth_mat + seven_mat ;

% Put a 5 diagonally up and to the left of
% every 1 without a neighbor there.

five_pre_mat = diag_diff_LR_minus_UL_mat ;

five_pre_mat(five_pre_mat<0) = 0 ;

five_pre_mat = horzcat(five_pre_mat,zeros(obs_truth_mat_row_num-1,1)) ;

five_pre_mat = vertcat(five_pre_mat,zeros(1,obs_truth_mat_col_num)) ;

five_mat = 5 .* five_pre_mat ;

obs_truth_mat = obs_truth_mat + five_mat ;

% Put a 9 diagonally down and to the right of
% every 1 without a neighbor there.

nine_pre_mat = -diag_diff_LR_minus_UL_mat ;

nine_pre_mat(nine_pre_mat<0) = 0 ;

nine_pre_mat = horzcat(zeros(obs_truth_mat_row_num-1,1),nine_pre_mat) ;

nine_pre_mat = vertcat(zeros(1,obs_truth_mat_col_num),nine_pre_mat) ;

nine_mat = 9 .* nine_pre_mat ;

obs_truth_mat = obs_truth_mat + nine_mat ;

end

% Reset all nonzero values in the truth matrix
% to 1.

obs_truth_mat(obs_truth_mat>1) = 1 ;

obs_truth_mat = logical(obs_truth_mat) ;

spy(obs_truth_mat)

%obs_truth_mat = obs_truth_mat

end
