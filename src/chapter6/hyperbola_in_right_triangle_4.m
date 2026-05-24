function [x_filtered_vec,y_filtered_vec] = hyperbola_in_right_triangle_4(l_major,l_minor, ...
num_x_points, ...
plot_results)
%
% Consider a right triangle, with its major leg coincident with the x
% axis, its minor leg displaced in the +x direction, and its most-acute
% angle at the origin. Within this right triangle, a hyperbola is
% incribed. This hyperbola's axis of symmetry lies along the line
% bisecting the most acute angle of the right triangle. Additionally, the
% asymptotes of this hyperbola coincide with the x axis and the
% hypotenuse. Finally, the "origin-most" point on the hyperbola is
% positioned so that, when its tangent line is drawn, that line
% intersects the major leg and hypotenuse at places that are both equally
% displaced from the origin.
%
% Usage:
% [x_filtered_vec,y_filtered_vec] = ...
% hyperbola_in_right_triangle_4(l_major,l_minor,...
% num_x_points,...
% plot_results) ;

% PROGRAMMING NOTES
%
% 1) The number of x points to be assessed on each branch of
% the hyperbola is set by the user as an
% input, and not by the program itself.
%
% 2) This routine calls the following non-MATLAB subroutine:
%
% A_and_C_equidistant_from_O
% hyperbola

l_hypotenuse = sqrt((l_minor^2)+(l_major^2)) ;

% Find the most-acute angle of the right triangle.

theta = atan( l_minor / l_major ) ;

% Determine the points on the right triangle that need to be intersected by
% the innermost tangent line of the hyperbola.

[f_eq] = A_and_C_equidistant_from_O(l_minor,l_major) ;

l_rh = f_eq * l_hypotenuse ;

% Determine the parameters for the "un-rotated" version of the hyperbola.

a = l_rh * cos(theta/2) ;

b = a * tan(theta/2) ;

% Generate the two branches of the un-rotated hyperbola.

% Two x vectors need to be generated to accomplish this. The lower branch
% will need to have a smaller x range, to prevent it from jutting
% excessively past the minor leg of the right triangle when it is rotated
% into position.
% Similarly, the upper branch of the hyperbola will need to have a larger x
% range, to prevent it from falling short of the minor leg of the right
% triangle when it is rotated into position.
% In both cases,the routine will err on the side of having values of the
% hyperbola's branches that stick out past l_major on the x axis.

length_of_bisecting_line_seg = l_major / cos(theta/2) ;

%delta_x = length_of_bisecting_line_seg - l_major ;

%max_x_for_neg_branch = cos(theta/2) * l_major ;

max_x_for_neg_branch = length_of_bisecting_line_seg ;

max_x_for_pos_branch = cos(theta/2) * l_hypotenuse ;

x_neg_vec = a:(max_x_for_neg_branch-a)/(num_x_points-1):max_x_for_neg_branch ;

[y_neg_vec,~] = hyperbola(a,b,x_neg_vec) ;

x_pos_vec = a:(max_x_for_pos_branch-a)/(num_x_points-1):max_x_for_pos_branch ;

[~,y_pos_vec] = hyperbola(a,b,x_pos_vec) ;

% Rotate the hyperbola to its correct orientation.

R = [ cos(theta/2) -sin(theta/2); sin(theta/2) cos(theta/2)] ;

old_xy_pos_mat = vertcat(x_pos_vec,y_pos_vec);

new_xy_pos_mat = R * old_xy_pos_mat ;

old_xy_neg_mat = vertcat(x_neg_vec,y_neg_vec);

new_xy_neg_mat = R * old_xy_neg_mat ;

new_xy_mat = horzcat(new_xy_neg_mat,new_xy_pos_mat) ;

[x_sorted_vec,x_sorted_ind_vec] = sort(new_xy_mat(1,:)) ;

y_sorted_vec = new_xy_mat(2,x_sorted_ind_vec) ;

x_filtered_ind_vec = find(x_sorted_vec<=l_major) ;

x_filtered_vec = x_sorted_vec(x_filtered_ind_vec) ;

y_filtered_vec = y_sorted_vec(x_filtered_ind_vec) ;

% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
%
% Plot Results
%
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR

% Plot the results, if requested.

if plot_results == 1

figure

% Plot the hyperbola.

plot(x_filtered_vec,y_filtered_vec, 'g*','MarkerSize' ,12);

% Adjust the settings for the plot.

hold on;
axis equal;
grid

v = axis;
v(1) = -0.1 * l_major ;
v(2) = 1.1 * l_major ;
v(3) = -0.1 * l_minor ;
v(4) = 1.1 * l_minor ;
axis(v);
axis manual

% Plot the right triangle.

plot([0,l_major],[0,0], 'b-','LineWidth' ,2.5)
plot([0,l_major],[0,l_minor], 'b-','LineWidth' ,2.5)
plot([l_major,l_major],[0,l_minor], 'b-','LineWidth' ,2.5)

% Plot the bisecting line segment.

y_bisect = l_major * tan(theta/2) ;

plot([0,l_major],[0,y_bisect], 'c-','LineWidth' ,2.5)

else
end

end
