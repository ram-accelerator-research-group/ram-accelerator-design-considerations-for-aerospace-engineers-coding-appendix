function [x_intersect_vec,y_intersect_vec] = right_triangle_with_quasi_hyperbola(l_minor, l_major,num_line_segments)
%
% Usage:
%
% [x_intersect_vec,y_intersect_vec] = ...
% right_triangle_with_quasi_hyperbola(l_minor,l_major,num_line_segments) ;

% Draw the right triangle.

x_major_vec = [0,l_major] ;
y_major_vec = [0,0] ;

plot(x_major_vec,y_major_vec, 'b');

grid
axis equal
hold on

x_minor_vec = [l_major,l_major] ;
y_minor_vec = [0,l_minor] ;

plot(x_minor_vec,y_minor_vec, 'b') ;

x_hypotenuse = [0,l_major] ;
y_hypotenuse = [0,l_minor] ;

plot(x_hypotenuse,y_hypotenuse, 'b') ;

x_bisect = [0, l_major] ;
y_bisect = [0, l_minor/2] ;

plot(x_bisect,y_bisect, 'c') ;

% Create a vector that describes the points along the major leg where the
% line segments will originate from.

A_x_vec = 0:(l_major-0)/(num_line_segments+1):l_major ;

A_y_vec = zeros(1,max(size(A_x_vec))) ;

% Create a vector that describes the points along the hypotenuse where the
% line segments will go to.
%
% As was the case with the A points, the C points will need to be evenly
% spaced along their part of the right triangle, i.e. the hypotenuse.

C_x_vec = A_x_vec ;

C_y_vec = ( l_minor / l_major ) .* C_x_vec ;

% Plot the A and C points.

plot(A_x_vec,A_y_vec, 'k.')

plot(C_x_vec,C_y_vec, 'k.')

% Draw the line segments running between the A and C points.

C_x_new_vec = fliplr(C_x_vec) ;

C_y_new_vec = fliplr(C_y_vec) ;

for line_seg_itr = 1:max(size(A_x_vec))
AC_x_vec = [A_x_vec(1,line_seg_itr),C_x_new_vec(1,line_seg_itr)] ;
AC_y_vec = [A_y_vec(1,line_seg_itr),C_y_new_vec(1,line_seg_itr)] ;
plot(AC_x_vec,AC_y_vec, 'r-')
end

% Plot the midpoints of these line segments.

%AC_x_mat = [ A_x_vec; C_x_new_vec ] ;

%AC_y_mat = [ A_y_vec; C_y_new_vec ] ;

%midpoint_x_vec = mean(AC_x_mat,1) ;
%midpoint_y_vec = mean(AC_y_mat,1) ;

%plot(midpoint_x_vec,midpoint_y_vec,'g*') ;

% Plot the intersection points of adjacent line segments.

x_intersect_vec = [] ;

y_intersect_vec = [] ;

for intersect_itr = 2:max(size(A_x_vec))-2
m_1 = ( C_y_new_vec(1,intersect_itr) - A_y_vec(1,intersect_itr) ) / ( C_x_new_vec(1, intersect_itr) - A_x_vec(1,intersect_itr) ) ;
m_2 = ( C_y_new_vec(1,intersect_itr+1) - A_y_vec(1,intersect_itr+1) ) / ( C_x_new_vec (1,intersect_itr+1) - A_x_vec(1,intersect_itr+1) ) ;

y_term = A_y_vec(1,intersect_itr+1) - A_y_vec(1,intersect_itr) ;

mx_term = ( m_1 * A_x_vec(1,intersect_itr) ) - ( m_2 * A_x_vec(1,intersect_itr+1) ) ;

x_intersect = ( y_term + mx_term ) / ( m_1 - m_2 ) ;

x_intersect_vec = [x_intersect_vec,x_intersect] ;

y_intersect = ( m_1 * ( x_intersect - A_x_vec(1,intersect_itr) ) ) + A_y_vec (1,intersect_itr) ;

y_intersect_vec = [y_intersect_vec,y_intersect] ;

end

plot(x_intersect_vec, y_intersect_vec, 'g.') ;

end
