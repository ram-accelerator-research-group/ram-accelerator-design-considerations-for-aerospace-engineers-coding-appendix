function [x_meshes_for_boxes_3mat,y_meshes_for_boxes_3mat,z_meshes_for_boxes_3mat, ...
inner_radius_of_ring_of_boxes,outer_radius_of_ring_of_boxes] = ...
create_ring_of_boxes_7(size_of_cube,number_of_meshgrid_points,number_of_cubes, ...
skip_every_nth_box,cube_orientation, ...
plot_ring_of_boxes,plot_ring_of_boxes_as_new_figure)
%
% The purpose of this function is to take, as input, the size of a given
% cube, and the number of copies of this cube that will be fastened
% together, at their "inner" (z-axis-facing) faces, to create a ring.
% This function will then return, as output, meshgrids that define each
% and every one of the cubes in the ring.
%
% Input terms:
%
% size_of_cube = the length of one side of the cube;
%
% number_of_meshgrid_points = the number of rows and columns that the
% initial meshgrids defining each face of
% the cube will have;
%
% number_of_cubes = the number of cubes (ignoring deletions
% ...more on this below) that will be
% joined together to create the ring of
% cubes;
%
% skip_every_nth_box = if boxes are being omitted, the routine
% will skip every nth box, but plot all
% others;
%
% cube_orientation = a number specifying how the cubes will
% abut one another, where...
%
% 1 = cubes joined along lower edges,
% with their inner faces joined in a
% continuous ribbon having as many
% squares as there are cubes;
%
% 2 = cubes joined along side edges,
% with their +/- z-axis-oriented
% faces joined along face diagonals,
% such that their faces form a
% necklace of diamonds;
%
% 3 = cubes joined at vertices along
% common side edges, with those side
% edges oriented inward toward the z
% azis, such that the cubes form a
% charm bracelet of diamonds;
%
% 4 = cubes joined at the vertices lying
% on their face diagonals, along
% their inward-oriented faces,
% such that their faces form a ring
% of diamonds; and
%
% 5 = cubes joined at the vertices lying
% on their body diagonals, such that
% they form a "necklace" of cubes;
%
% plot_ring_of_boxes = the truth value of whether or not the
% ring of boxes is to be plotted (1 if
% yes, 0 if no) ;
%
% and
%
% plot_ring_of_boxes_as_new_figure
% = the truth value of whether the ring of
% boxes is to be plotted as a new figure
% (1 if yes, 0 if no).
%
% Usage:
%
% [x_meshes_for_boxes_3mat,y_meshes_for_boxes_3mat,z_meshes_for_boxes_3mat,...
% inner_radius_of_ring_of_boxes,outer_radius_of_ring_of_boxes] = ...
% create_ring_of_boxes_7(size_of_cube,number_of_meshgrid_points,number_of_cubes,...
% skip_every_nth_box,cube_orientation,...
% plot_ring_of_boxes,plot_ring_of_boxes_as_new_figure)

% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
%
% Validation
%
% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

if size_of_cube <= 0
error( 'The size of the cube must be a positive, non-zero number.' )
else
end

tol = 1e-14 ;

if abs(mod(number_of_meshgrid_points,1)) > tol
error( 'The number of meshgrid points must be a whole number.' )
else
if number_of_meshgrid_points <= 0
error( 'The number of meshgrid points must be a positive, nonzero integer.' )
else
end
end

%number_of_meshgrid_points = int32(number_of_meshgrid_points) ;

if abs(mod(number_of_cubes,1)) > tol
error( 'The number of cubes must be a whole number.' )
else
if number_of_cubes <= 0
error( 'The number of cubes must be a positive, nonzero integer.' )
else
end
end

%number_of_cubes = int32(number_of_cubes) ;

if abs(mod(skip_every_nth_box,1)) > tol
error( 'The number specifying that the nth box must be skipped must be a whole number.' )
else
if skip_every_nth_box < 0
error( 'The number specifying that the nth box must be skipped must be a positive integer.' )
else
end
end

skip_every_nth_box = int32(skip_every_nth_box) ;

if abs(mod(cube_orientation,1)) > tol
error( 'The number specifying the cube orientation must be a whole number.' )
else
if cube_orientation <= 0
error( 'The number specifying the cube orientation must be a positive, nonzero integer.' )
else
if and(and(and(cube_orientation~=1, cube_orientation~=2),and(cube_orientation~=3, cube_orientation~=4)),cube_orientation~=5)
error( 'The cube orientation number must be 1, 2, 3, 4 or 5.' )
else
end
end
end

cube_orientation = int32(cube_orientation) ;

if and(plot_ring_of_boxes~=0,plot_ring_of_boxes~=1)
error( 'The truth value for plotting results must be a zero or a one.' )
else
end

plot_ring_of_boxes = logical(plot_ring_of_boxes) ;

if and(plot_ring_of_boxes_as_new_figure~=0,plot_ring_of_boxes_as_new_figure~=1)
error( 'The truth value for plotting as a new figure must be a zero or a one.' )
else
end

plot_ring_of_boxes_as_new_figure = logical(plot_ring_of_boxes_as_new_figure) ;

% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
% YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
%
% Generate xy-Aligned Cube Faces
%
% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
% YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

% Create a cube with one of its eight vertices at the origin.

x_vec = 0:1/(number_of_meshgrid_points-1):1 ;

y_vec = 0:1/(number_of_meshgrid_points-1):1 ;

z_vec = 0:1/(number_of_meshgrid_points-1):1 ;

% lower

[x_cube_lower_xy_face_mat,y_cube_lower_xy_face_mat] = meshgrid(x_vec,y_vec) ;

z_cube_lower_xy_face_mat = zeros(number_of_meshgrid_points) ;

% upper

x_cube_upper_xy_face_mat = x_cube_lower_xy_face_mat ;

y_cube_upper_xy_face_mat = y_cube_lower_xy_face_mat ;

z_cube_upper_xy_face_mat = z_cube_lower_xy_face_mat + 1 ;

% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
% ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
%
% Generate yz-Aligned Cube Faces
%
% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
% ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

% left

[y_cube_left_yz_face_mat,z_cube_left_yz_face_mat] = meshgrid(y_vec,z_vec) ;

x_cube_left_yz_face_mat = zeros(number_of_meshgrid_points) ;

% right

y_cube_right_yz_face_mat = y_cube_left_yz_face_mat ;

z_cube_right_yz_face_mat = z_cube_left_yz_face_mat ;

x_cube_right_yz_face_mat = x_cube_left_yz_face_mat + 1 ;

% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
% ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
%
% Generate xz-Aligned Cube Faces
%
% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
% XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
% ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

% back

[x_cube_back_xz_face_mat,z_cube_back_xz_face_mat] = meshgrid(x_vec,z_vec) ;

y_cube_back_xz_face_mat = zeros(number_of_meshgrid_points) ;

% front

x_cube_front_xz_face_mat = x_cube_back_xz_face_mat ;

z_cube_front_xz_face_mat = z_cube_back_xz_face_mat ;

y_cube_front_xz_face_mat = y_cube_back_xz_face_mat + 1 ;

x_orig_cube_mat = vertcat( x_cube_lower_xy_face_mat, ...
x_cube_back_xz_face_mat, ...
x_cube_right_yz_face_mat, ...
x_cube_front_xz_face_mat, ...
x_cube_left_yz_face_mat, ...
x_cube_upper_xy_face_mat ) ;

y_orig_cube_mat = vertcat( y_cube_lower_xy_face_mat, ...
y_cube_back_xz_face_mat, ...
y_cube_right_yz_face_mat, ...
y_cube_front_xz_face_mat, ...
y_cube_left_yz_face_mat, ...
y_cube_upper_xy_face_mat ) ;

z_orig_cube_mat = vertcat( z_cube_lower_xy_face_mat, ...
z_cube_back_xz_face_mat, ...
z_cube_right_yz_face_mat, ...
z_cube_front_xz_face_mat, ...
z_cube_left_yz_face_mat, ...
z_cube_upper_xy_face_mat ) ;

% Shift this cube so that the center of this cube is at the origin.

x_orig_cube_mat = x_orig_cube_mat - 0.5 ;

y_orig_cube_mat = y_orig_cube_mat - 0.5 ;

z_orig_cube_mat = z_orig_cube_mat - 0.5 ;

% Change the size of this cube so that it is consistent with the specified
% size.

x_orig_cube_mat = x_orig_cube_mat .* size_of_cube ;

y_orig_cube_mat = y_orig_cube_mat .* size_of_cube ;

z_orig_cube_mat = z_orig_cube_mat .* size_of_cube ;

% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%
% Copy, Translate and Rotate Cubes
%
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

% If the first, "ribbon of squares" arrangement is chosen, no angular
% reorientations of the cube will be needed before the loop.

[row_num,col_num] = size(x_orig_cube_mat) ;

if cube_orientation == 1
else

% If the second, "ribbon of diamonds, joined along edges" arrangement
% is chosen, the cube will need to be rotated by pi/4 around the z-axis
% before the loop.

if cube_orientation == 2

current_cube_angle = pi/4 ;

z_rotation_mat = [ cos(current_cube_angle),-sin(current_cube_angle), 0; ...
sin(current_cube_angle), cos(current_cube_angle), 0; ...
0, 0, 1] ;

% Convert the meshgrids into a single n x 3 matrix of Cartesian
% triples.

x_orig_cube_vec = reshape(x_orig_cube_mat,[],1) ;

y_orig_cube_vec = reshape(y_orig_cube_mat,[],1) ;

z_orig_cube_vec = reshape(z_orig_cube_mat,[],1) ;

cartesian_xyz_orig_cube_mat = [x_orig_cube_vec,y_orig_cube_vec,z_orig_cube_vec] ;

% Rotate the Cartesian points by multiplying them into the rotation
% matrix; re-orient the resulting 3 x n matrix when done.

cartesian_xyz_orig_cube_mat = z_rotation_mat * cartesian_xyz_orig_cube_mat(:,1:3)' ;

cartesian_xyz_orig_cube_mat = cartesian_xyz_orig_cube_mat' ;

x_orig_cube_mat = reshape(cartesian_xyz_orig_cube_mat(:,1),row_num,col_num) ;

y_orig_cube_mat = reshape(cartesian_xyz_orig_cube_mat(:,2),row_num,col_num) ;

z_orig_cube_mat = reshape(cartesian_xyz_orig_cube_mat(:,3),row_num,col_num) ;

else
if cube_orientation == 3

% If the third, "charm bracelet of diamonds" arrangement is
% chosen, the cube will need to be rotated by pi/4 around the
% y-axis before the loop.

current_cube_angle = pi/4 ;

y_rotation_mat = [ cos(current_cube_angle), 0, sin(current_cube_angle) ; ...
0, 1, 0 ; ...
-sin(current_cube_angle), 0, cos(current_cube_angle) ] ;

% Convert the meshgrids into a single n x 3 matrix of Cartesian
% triples.

x_orig_cube_vec = reshape(x_orig_cube_mat,[],1) ;

y_orig_cube_vec = reshape(y_orig_cube_mat,[],1) ;

z_orig_cube_vec = reshape(z_orig_cube_mat,[],1) ;

cartesian_xyz_orig_cube_mat = [x_orig_cube_vec,y_orig_cube_vec,z_orig_cube_vec] ;

% Rotate the Cartesian points by multiplying them into the rotation
% matrix; re-orient the resulting 3 x n matrix when done.

cartesian_xyz_orig_cube_mat = y_rotation_mat * cartesian_xyz_orig_cube_mat(:,1: 3)' ;

cartesian_xyz_orig_cube_mat = cartesian_xyz_orig_cube_mat' ;

x_orig_cube_mat = reshape(cartesian_xyz_orig_cube_mat(:,1),row_num,col_num) ;

y_orig_cube_mat = reshape(cartesian_xyz_orig_cube_mat(:,2),row_num,col_num) ;

z_orig_cube_mat = reshape(cartesian_xyz_orig_cube_mat(:,3),row_num,col_num) ;


else
if cube_orientation == 4

% If the fourth, "ribbon of diamonds, joined at inner face
% vertices" arrangement is chosen, the cube will need to be
% rotated by pi/4 around the x-axis before the loop.

current_cube_angle = pi/4 ;

x_rotation_mat = [ 1, 0, 0; ...
0, cos(current_cube_angle), -sin (current_cube_angle); ...
0, sin(current_cube_angle), cos (current_cube_angle) ] ;

% Convert the meshgrids into a single n x 3 matrix of Cartesian
% triples.

x_orig_cube_vec = reshape(x_orig_cube_mat,[],1) ;

y_orig_cube_vec = reshape(y_orig_cube_mat,[],1) ;

z_orig_cube_vec = reshape(z_orig_cube_mat,[],1) ;

cartesian_xyz_orig_cube_mat = [x_orig_cube_vec,y_orig_cube_vec, z_orig_cube_vec] ;

% Rotate the Cartesian points by multiplying them into the rotation
% matrix; re-orient the resulting 3 x n matrix when done.

cartesian_xyz_orig_cube_mat = x_rotation_mat * cartesian_xyz_orig_cube_mat(:, 1:3)' ;

cartesian_xyz_orig_cube_mat = cartesian_xyz_orig_cube_mat' ;

x_orig_cube_mat = reshape(cartesian_xyz_orig_cube_mat(:,1),row_num,col_num) ;

y_orig_cube_mat = reshape(cartesian_xyz_orig_cube_mat(:,2),row_num,col_num) ;

z_orig_cube_mat = reshape(cartesian_xyz_orig_cube_mat(:,3),row_num,col_num) ;

else
% If the fifth, "necklace of cubes" arrangement is chosen, three separate
% angular reorientations of the cube will be required before the loop.

% 1) The first angular reorientation will be a rotation of the original
% cube by pi/4 around the z-axis.

current_cube_angle = pi/4 ;

z_rotation_mat = [ cos(current_cube_angle),-sin(current_cube_angle), 0; ...
sin(current_cube_angle), cos(current_cube_angle), 0; ...
0, 0, 1] ;

% Convert the meshgrids into a single n x 3 matrix of Cartesian
% triples.

x_orig_cube_vec = reshape(x_orig_cube_mat,[],1) ;

y_orig_cube_vec = reshape(y_orig_cube_mat,[],1) ;

z_orig_cube_vec = reshape(z_orig_cube_mat,[],1) ;

cartesian_xyz_orig_cube_mat = [x_orig_cube_vec,y_orig_cube_vec, z_orig_cube_vec] ;


% Rotate the Cartesian points by multiplying them into the rotation
% matrix; re-orient the resulting 3 x n matrix when done.

cartesian_xyz_orig_cube_mat = z_rotation_mat * cartesian_xyz_orig_cube_mat(:, 1:3)' ;

cartesian_xyz_orig_cube_mat = cartesian_xyz_orig_cube_mat' ;

% 2) The second angular reorientation will take the cube produced by
% step 1, and rotate it by an angle of atan(1/sqrt(2)) (i.e. the
% elevation of the body diagonal from the cube face) around the
% y-axis.

current_cube_angle = atan(1/sqrt(2)) ;

y_rotation_mat = [ cos(current_cube_angle), 0, sin(current_cube_angle) ;...
0, 1, 0 ; ...
-sin(current_cube_angle), 0, cos(current_cube_angle) ] ;

cartesian_xyz_orig_cube_mat = y_rotation_mat * cartesian_xyz_orig_cube_mat(:, 1:3)' ;

cartesian_xyz_orig_cube_mat = cartesian_xyz_orig_cube_mat' ;

% 3) The third and final reorientation will take the cube produced by
% step 2, and rotate it by an angle of pi/2 around the x-axis. At
% this point, the body diagonal of the cube will be coincident with
% the xy-plane, and orthogonal to the x axis.

current_cube_angle = pi/2 ;

z_rotation_mat = [ cos(current_cube_angle),-sin(current_cube_angle), 0; ...
sin(current_cube_angle), cos(current_cube_angle), 0; ...
0, 0, 1] ;

cartesian_xyz_orig_cube_mat = z_rotation_mat * cartesian_xyz_orig_cube_mat(:, 1:3)' ;

cartesian_xyz_orig_cube_mat = cartesian_xyz_orig_cube_mat' ;

x_orig_cube_mat = reshape(cartesian_xyz_orig_cube_mat(:,1),row_num,col_num) ;

y_orig_cube_mat = reshape(cartesian_xyz_orig_cube_mat(:,2),row_num,col_num) ;

z_orig_cube_mat = reshape(cartesian_xyz_orig_cube_mat(:,3),row_num,col_num) ;
end
end

end

end

% For the specified number of cubes...

if plot_ring_of_boxes_as_new_figure == 1
figure
grid
hold on
axis equal
camva manual
else
end

%[row_num,col_num] = size(x_orig_cube_mat) ;

x_meshes_for_boxes_3mat = zeros(row_num,col_num,number_of_cubes) ;

y_meshes_for_boxes_3mat = zeros(row_num,col_num,number_of_cubes) ;

z_meshes_for_boxes_3mat = zeros(row_num,col_num,number_of_cubes) ;

for cube_itr = 1:1:number_of_cubes

% ...translate and rotate the original cube so that it will correspond to the current cube of the ring.

ring_angle = 2*pi / number_of_cubes ;

if cube_orientation == 1

% ...i.e. the "ribbon of squares" case...

inner_radius_of_ring_of_boxes = (size_of_cube/2) / tan(ring_angle/2) ;

cube_center_radius = inner_radius_of_ring_of_boxes + (size_of_cube/2) ;

r_inner_vec = [0,inner_radius_of_ring_of_boxes] ;

diag_half_cube = size_of_cube * sqrt(5) / 2 ;

theta_half_cube_2 = atan(2) ;

diag_half_cube_vec = [diag_half_cube*cos(theta_half_cube_2),diag_half_cube*sin (theta_half_cube_2)] ;

r_outer_vec = r_inner_vec + diag_half_cube_vec ;

outer_radius_of_ring_of_boxes = magnitude(r_outer_vec) ;

else
if cube_orientation == 2

% ...i.e. the "ring of diamonds, joined along edges" case...

cube_center_radius = (sqrt(2)*size_of_cube/2) / tan(ring_angle/2) ;

inner_radius_of_ring_of_boxes = cube_center_radius - (sqrt(2)*size_of_cube/2) ;

outer_radius_of_ring_of_boxes = cube_center_radius + (sqrt(2)*size_of_cube/2) ;

else
if cube_orientation == 3

% ... i.e. the "charm bracelet of diamonds" case...

inner_radius_of_ring_of_boxes = (size_of_cube/2) / tan(ring_angle/2) ;

cube_center_radius = inner_radius_of_ring_of_boxes + (sqrt(2) *size_of_cube/2);


r_inner_vec = [inner_radius_of_ring_of_boxes,0] ;

diag_half_cube = size_of_cube * 3/2 ;

theta_half_cube_3 = atan(2*sqrt(2)) ;

diag_half_cube_vec = [diag_half_cube*sin(theta_half_cube_3), diag_half_cube*cos(theta_half_cube_3)] ;


r_outer_vec = r_inner_vec + diag_half_cube_vec ;

outer_radius_of_ring_of_boxes = magnitude(r_outer_vec) ;


else
if cube_orientation == 4

% ...i.e. the "ring of diamonds, joined at vertices"
% case...

inner_radius_of_ring_of_boxes = (sqrt(2)*size_of_cube/2) / tan (ring_angle/2) ;

cube_center_radius = inner_radius_of_ring_of_boxes + (size_of_cube/2) ;

outer_face_radius = cube_center_radius + (size_of_cube/2) ;

outer_radius_of_ring_of_boxes = sqrt((outer_face_radius^2)+((sqrt(2) *size_of_cube/2)^2)) ;

else

% ...i.e. the "necklace of cubes, joined at vertices"
% case...

cube_center_radius = (sqrt(3)*size_of_cube/2) / tan(ring_angle/2) ;

inner_radius_of_ring_of_boxes = cube_center_radius - (sqrt(2) *size_of_cube/2) ;

outer_radius_of_ring_of_boxes = cube_center_radius + (sqrt(2) *size_of_cube/2) ;

end
end
end
end

current_cube_angle = ring_angle * ( cube_itr - 1 ) ;

%current_cube_angle = pi/6 ;

z_rotation_mat = [ cos(current_cube_angle),-sin(current_cube_angle), 0; ...
sin(current_cube_angle), cos(current_cube_angle), 0; ...
0, 0, 1] ;

% Convert the meshgrids into a single n x 3 matrix of Cartesian
% triples.

x_orig_cube_vec = reshape(x_orig_cube_mat,[],1) ;

y_orig_cube_vec = reshape(y_orig_cube_mat,[],1) ;

z_orig_cube_vec = reshape(z_orig_cube_mat,[],1) ;

cartesian_xyz_orig_cube_mat = [x_orig_cube_vec,y_orig_cube_vec,z_orig_cube_vec] ;

% Rotate the Cartesian points by multiplying them into the rotation
% matrix; re-orient the resulting 3 x n matrix when done.

cartesian_xyz_rot_cube_mat = z_rotation_mat * cartesian_xyz_orig_cube_mat(:,1:3)' ;

cartesian_xyz_rot_cube_mat = cartesian_xyz_rot_cube_mat' ;

x_rot_cube_mat = reshape(cartesian_xyz_rot_cube_mat(:,1),row_num,col_num) ;

y_rot_cube_mat = reshape(cartesian_xyz_rot_cube_mat(:,2),row_num,col_num) ;

z_rot_cube_mat = reshape(cartesian_xyz_rot_cube_mat(:,3),row_num,col_num) ;

x_trans_rot_cube_mat = x_rot_cube_mat + (cube_center_radius*cos(current_cube_angle)) ;

y_trans_rot_cube_mat = y_rot_cube_mat + (cube_center_radius*sin(current_cube_angle)) ;

z_trans_rot_cube_mat = z_rot_cube_mat ;

if skip_every_nth_box==0

x_meshes_for_boxes_3mat(:,:,cube_itr) = x_trans_rot_cube_mat ;

y_meshes_for_boxes_3mat(:,:,cube_itr) = y_trans_rot_cube_mat ;

z_meshes_for_boxes_3mat(:,:,cube_itr) = z_trans_rot_cube_mat ;

if plot_ring_of_boxes == 1
surf(x_trans_rot_cube_mat,y_trans_rot_cube_mat,z_trans_rot_cube_mat, " LineStyle" ,'none')
%colormap("pink")
else
end

else

if and( skip_every_nth_box~=0, mod(cube_itr,skip_every_nth_box) > tol )

x_meshes_for_boxes_3mat(:,:,cube_itr) = x_trans_rot_cube_mat ;

y_meshes_for_boxes_3mat(:,:,cube_itr) = y_trans_rot_cube_mat ;

z_meshes_for_boxes_3mat(:,:,cube_itr) = z_trans_rot_cube_mat ;

if plot_ring_of_boxes == 1
surf(x_trans_rot_cube_mat,y_trans_rot_cube_mat,z_trans_rot_cube_mat, " LineStyle" ,'none')
else
end

else

x_meshes_for_boxes_3mat(:,:,cube_itr) = nan(row_num,col_num) ;

y_meshes_for_boxes_3mat(:,:,cube_itr) = nan(row_num,col_num) ;

z_meshes_for_boxes_3mat(:,:,cube_itr) = nan(row_num,col_num) ;

end

end

end

if plot_ring_of_boxes == 1
rotate3d
else
end

end
