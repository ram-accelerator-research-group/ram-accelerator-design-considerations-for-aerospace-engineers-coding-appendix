function [surf_1_a_vec,surf_1_b_vec,surf_1_c_vec,surf_1_d_vec, ...
surf_2_a_vec,surf_2_b_vec,surf_2_c_vec,surf_2_d_vec] = ...
quadrilateral_pairs_select(surf_1_x_mat,surf_1_y_mat,surf_1_z_mat, ...
surf_2_x_mat,surf_2_y_mat,surf_2_z_mat, ...
row_col_ind_vec)
%
% The purpose of this function is to generate a series of quasi-randomly
% selected vectors of adjacent points on a surface, using a Sobol-set-based
% routine to choose these points.
%
% Input terms:
%
% surf_1_x_mat = ; surf_1_y_mat = ; surf_1_z_mat = ;
%
% surf_2_x_mat = ; surf_2_y_mat = ; surf_2_z_mat = ;
%
% num_points = ;
%
% where
%
% surf_1_x_mat = the meshgrid of x-coordinates of points on
% surface 1 that are being investigated;
%
% surf_1_y_mat = the meshgrid of y-coordinates of points on
% surface 1 that are being investigated;
%
% surf_1_z_mat = the meshgrid of z-coordinates of points on
% surface 1 that are being investigated;
%
%
% surf_2_x_mat = the meshgrid of x-coordinates of points on
% surface 2 that are being investigated;
%
% surf_2_y_mat = the meshgrid of y-coordinates of points on
% surface 2 that are being investigated;
%
% surf_2_z_mat = the meshgrid of z-coordinates of points on
% surface 2 that are being investigated;
%
% and
%
% row_col_ind_vec = a vector extracted from the row_col_ind_mat
% output of aug_sobol_select_6, with the
% structure
%
% [surf_1_row_ind,surf_1_col_ind,surf_2_row_ind,surf_2_col_ind]
%
% Output terms:
%
% surf_1_a_vec = ; surf_1_b_vec = ; surf_1_c_vec = ; surf_1_d_vec = ;
%
% surf_2_a_vec = ; surf_2_b_vec = ; surf_2_c_vec = ; surf_2_d_vec = ;
%
% where
%
% surf_1_a_vec = a vector with num_points rows, and 3
% columns, representing the (x,y,z)
% coordinates of each "a" point, in each
% quadrilateral cluster of points in surface
% 1, that is selected with reference to the
% Sobol set;
%
% surf_1_b_vec = a vector with num_points rows, and 3
% columns, representing the (x,y,z)
% coordinates of each "b" point, in each
% quadrilateral cluster of points in surface
% 1, that is selected with reference to the
% Sobol set;
%
% surf_1_c_vec = a vector with num_points rows, and 3
% columns, representing the (x,y,z)
% coordinates of each "c" point, in each
% quadrilateral cluster of points in surface
% 1, that is selected with reference to the
% Sobol set;
%
% surf_1_d_vec = a vector with num_points rows, and 3
% columns, representing the (x,y,z)
% coordinates of each "b" point, in each
% quadrilateral cluster of points in surface
% 1, that is selected with reference to the
% Sobol set;
%
%
% surf_2_a_vec = a vector with num_points rows, and 3
% columns, representing the (x,y,z)
% coordinates of each "a" point, in each
% quadrilateral cluster of points in surface
% 2, that is selected with reference to the
% Sobol set.
%
% surf_2_b_vec = a vector with num_points rows, and 3
% columns, representing the (x,y,z)
% coordinates of each "b" point, in each
% quadrilateral cluster of points in surface
% 2, that is selected with reference to the
% Sobol set.
%
% surf_2_c_vec = a vector with num_points rows, and 3
% columns, representing the (x,y,z)
% coordinates of each "c" point, in each
% quadrilateral cluster of points in surface
% 2, that is selected with reference to the
% Sobol set.
%
% surf_2_d_vec = a vector with num_points rows, and 3
% columns, representing the (x,y,z)
% coordinates of each "b" point, in each
% quadrilateral cluster of points in surface
% 2, that is selected with reference to the
% Sobol set.
%
% Usage:
%
% [aug_Sobol_mat,...
% surf_1_a_mat,surf_1_b_mat,surf_1_c_mat,surf_1_d_mat,...
% surf_2_a_mat,surf_2_b_mat,surf_2_c_mat,surf_2_d_mat] =...
% sobol_surface_element_select_5(surf_1_x_mat,surf_1_y_mat,surf_1_z_mat,...
% surf_2_x_mat,surf_2_y_mat,surf_2_z_mat,...
% num_points);

% PROGRAMMING NOTES
%
% This routine only returns vectors of
% coordinates for surfaces 1 and 2, given indices specified by a separate
% Sobol subroutine (aug_sobol_select_8).

% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
%
% Validation
%
% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

if size(surf_1_x_mat)~=size(surf_1_y_mat)
error( 'The x and y matrices for suface 1 must be meshgrids of identical size.' )
else
if size(surf_1_x_mat)~=size(surf_1_z_mat)
error( 'The x and z matrices for surface 1 must be meshgrids of identical size.' )
else
if size(surf_1_y_mat)~=size(surf_1_z_mat)
error( 'The y and z matrices for surface 1 must be meshgrids of identical size.' )
else
end
end
end


if size(surf_2_x_mat)~=size(surf_2_y_mat)
error( 'The x and y matrices for surface 2 must be meshgrids of identical size.' )
else
if size(surf_2_x_mat)~=size(surf_2_z_mat)
error( 'The x and z matrices for surface 2 must be meshgrids of identical size.' )
else
if size(surf_2_y_mat)~=size(surf_2_z_mat)
error( 'The y and z matrices for surface 2 must be meshgrids of identical size.' )
else
end
end
end

% EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
%
% Extract Indices
%
% EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

surf_1_row_ind = row_col_ind_vec(1,1) ;

surf_1_col_ind = row_col_ind_vec(1,2) ;

surf_2_row_ind = row_col_ind_vec(1,3) ;

surf_2_col_ind = row_col_ind_vec(1,4) ;

% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
%
% Generate Surface Quadrilaterals
%
% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ

% Given these row and column indices, generate the coordinates for the
% corresponding (a,b,c,d) quadrilaterals on each surface.

% For surface 1...

surf_1_a_x = surf_1_x_mat( surf_1_row_ind+1, surf_1_col_ind+1 ) ;

surf_1_a_y = surf_1_y_mat( surf_1_row_ind+1, surf_1_col_ind+1 ) ;

surf_1_a_z = surf_1_z_mat( surf_1_row_ind+1, surf_1_col_ind+1 ) ;

surf_1_a_vec = [ surf_1_a_x, surf_1_a_y, surf_1_a_z ] ;


surf_1_b_x = surf_1_x_mat( surf_1_row_ind, surf_1_col_ind+1 ) ;

surf_1_b_y = surf_1_y_mat( surf_1_row_ind, surf_1_col_ind+1 ) ;

surf_1_b_z = surf_1_z_mat( surf_1_row_ind, surf_1_col_ind+1 ) ;

surf_1_b_vec = [ surf_1_b_x, surf_1_b_y, surf_1_b_z ] ;


surf_1_c_x = surf_1_x_mat( surf_1_row_ind,surf_1_col_ind ) ;

surf_1_c_y = surf_1_y_mat( surf_1_row_ind,surf_1_col_ind ) ;

surf_1_c_z = surf_1_z_mat( surf_1_row_ind,surf_1_col_ind ) ;

surf_1_c_vec = [ surf_1_c_x, surf_1_c_y, surf_1_c_z ] ;


surf_1_d_x = surf_1_x_mat( surf_1_row_ind+1, surf_1_col_ind ) ;

surf_1_d_y = surf_1_y_mat( surf_1_row_ind+1, surf_1_col_ind ) ;

surf_1_d_z = surf_1_z_mat( surf_1_row_ind+1, surf_1_col_ind) ;

surf_1_d_vec = [ surf_1_d_x, surf_1_d_y, surf_1_d_z ] ;


% ...and for surface 2.

surf_2_a_x = surf_2_x_mat( surf_2_row_ind+1, surf_2_col_ind+1 ) ;

surf_2_a_y = surf_2_y_mat( surf_2_row_ind+1, surf_2_col_ind+1 ) ;

surf_2_a_z = surf_2_z_mat( surf_2_row_ind+1, surf_2_col_ind+1 ) ;

surf_2_a_vec = [ surf_2_a_x, surf_2_a_y, surf_2_a_z ] ;


surf_2_b_x = surf_2_x_mat( surf_2_row_ind, surf_2_col_ind+1 ) ;

surf_2_b_y = surf_2_y_mat( surf_2_row_ind, surf_2_col_ind+1 ) ;

surf_2_b_z = surf_2_z_mat( surf_2_row_ind, surf_2_col_ind+1 ) ;

surf_2_b_vec = [ surf_2_b_x, surf_2_b_y, surf_2_b_z ] ;


surf_2_c_x = surf_2_x_mat( surf_2_row_ind,surf_2_col_ind ) ;

surf_2_c_y = surf_2_y_mat( surf_2_row_ind,surf_2_col_ind ) ;

surf_2_c_z = surf_2_z_mat( surf_2_row_ind,surf_2_col_ind ) ;

surf_2_c_vec = [ surf_2_c_x, surf_2_c_y, surf_2_c_z ] ;


surf_2_d_x = surf_2_x_mat( surf_2_row_ind+1, surf_2_col_ind ) ;

surf_2_d_y = surf_2_y_mat( surf_2_row_ind+1, surf_2_col_ind ) ;

surf_2_d_z = surf_2_z_mat( surf_2_row_ind+1, surf_2_col_ind) ;

surf_2_d_vec = [ surf_2_d_x, surf_2_d_y, surf_2_d_z ] ;

end
