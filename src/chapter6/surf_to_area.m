function [surf_area] = surf_to_area(surf_x_mat,surf_y_mat,surf_z_mat)
%
% This function takes, as input, meshgrids that correspond to the (x,y,z)
% Cartesian coordinates of a 3-D surface. It then returns, as output, the
% overall area of this surface, as estimated using repeated application
% of the Bretschneider formula.
%
% Usage:
%
% [surf_area] = surf_to_area(surf_x_mat,surf_y_mat,surf_z_mat)
%
%
% PROGRAMMING NOTES
%
% This function makes indirect use of the following non-MATLAB
% subroutine:
%
% Bretschneider

% Validate the input.

if size(surf_x_mat)~=size(surf_y_mat)
error( 'The x and y matrices must be meshgrids of identical size.' )
else
if size(surf_x_mat)~=size(surf_z_mat)
error( 'The x and z matrices must be meshgrids of identical size.' )
else
if size(surf_y_mat)~=size(surf_z_mat)
error( 'The y and z matrices must be meshgrids of identical size.' )
else
end
end
end

surf_area = 0 ;

% Iterate across each quadruple of points in the meshgrids.

[row_num,col_num] = size(surf_x_mat) ;

for row_itr = 1:1:row_num-1
for col_itr = 1:1:col_num-1
a_x = surf_x_mat(row_itr+1,col_itr+1) ;

a_y = surf_y_mat(row_itr+1,col_itr+1) ;

a_z = surf_z_mat(row_itr+1,col_itr+1) ;

a_vec = [a_x,a_y,a_z] ;


b_x = surf_x_mat(row_itr,col_itr+1) ;

b_y = surf_y_mat(row_itr,col_itr+1) ;

b_z = surf_z_mat(row_itr,col_itr+1) ;

b_vec = [b_x,b_y,b_z] ;


c_x = surf_x_mat(row_itr,col_itr) ;

c_y = surf_y_mat(row_itr,col_itr) ;

c_z = surf_z_mat(row_itr,col_itr) ;

c_vec = [c_x,c_y,c_z] ;


d_x = surf_x_mat(row_itr+1,col_itr) ;

d_y = surf_y_mat(row_itr+1,col_itr) ;

d_z = surf_z_mat(row_itr+1,col_itr) ;

d_vec = [d_x,d_y,d_z] ;

quadrilateral_mat = vertcat(a_vec,b_vec,c_vec,d_vec) ;

[area] = Bretschneider(quadrilateral_mat) ;

surf_area = surf_area + area ;

end
end

end
