function [Cp_paraH2_mat] = Cp_air_Cp_paraH2_anim(T_air_mat,Cp_air_mat)
%
% The purpose of this function is to animate the Cp values that both air
% and parahydrogen take, as they go through the section of a counterflow
% heat exchanger that cools the air down to its liquefaction temperature.
%
% Usage:
%
% [Cp_paraH2_mat] = Cp_air_Cp_paraH2_anim(T_air_mat,Cp_air_mat);

% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
%
% Set Up Animation
%
% SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
% UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

% First, create a string that describes the contents of the file.

filetype_str = 'Cp_air_Cp_pH2_' ;

% Next, generate the date and time in non-separated, Euro 24-hr format.
% This is needed, as dots and slashes would conflict with directory
% addresses on the computer.

t = datetime( 'now','Format','ddMMyy_HHmmss' );

% Since MATLAB has its own dedicated date vector format that it uses for
% this output, this date must be converted into a string by calling the
% string function.

datetime_str = string(t) ;

% Now, concatenate the "filetype" string with the "datetime" string, and
% append a ".avi" to the end. This will give the full filename for the
% video.

filename_str = strcat(filetype_str,datetime_str, '.avi') ;

vidObj = VideoWriter(filename_str) ;
open(vidObj);

% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
%
% Create a Figure
%
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

% Create a new figure, where the images to be animated will be set up.
% Creating a new figure for this ensures that any currently-displayed
% old figures will not be overwritten by mistake.

h_fig_anim = figure ;

%fig = gcf ;

x0 = 0 ;
y0 = 0 ;

width = 1280 ;

height = 720 ;

ax = gca ;
ax.FontSize = 20 ;
ax.FontWeight = 'Bold' ;

set(h_fig_anim, 'units','pixels','position' ,[x0,y0,width,height]) ;

xlabel( 'Cp for Air (J/(kg*K))' ,'FontSize' ,24,'FontWeight' ,'bold');

ylabel( 'Cp for para-H_2 (J/(kg*K))' ,'FontSize' ,24,'FontWeight' ,'bold');

% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
% DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
%
% Animate the Data
%
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
% DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD

[num_press_row,~] = size(T_air_mat) ;

[Cp_paraH2_mat,~] = ...
integrate_paraH2_Pcrit_Cp_4(T_air_mat) ;

% For each vector of heat exchanger temperatures...

for press_row_itr = 1:1:num_press_row

% Extract the corresponding vector of Cp values for air.

Cp_air_vec = Cp_air_mat(press_row_itr,:) ;

%T_air_vec = T_air_mat(press_row_itr,:) ;

% Generate the corresponding vector of Cp values for parahydrogen.

Cp_paraH2_vec = Cp_paraH2_mat(press_row_itr,:) ;

% Plot the air Cp values on the x axis, and the parahydrogen Cp values on
% the y axis.

if press_row_itr == 1

figure(h_fig_anim) ;

h_plotCp = plot(Cp_air_vec,Cp_paraH2_vec, 'b') ;

v = axis ;
axis(v) ;

hold on

grid

else
figure(h_fig_anim) ;
h_plotCp = plot(Cp_air_vec,Cp_paraH2_vec, 'b') ;
axis(v) ;
end

% Write the plot to the video file as a frame.
currFrame = getframe(gcf);
writeVideo(vidObj,currFrame);

% Delete the plot.
delete(h_plotCp);

end

% Close the figure used to create the file.

close gcf ;

% Close the file.

close(vidObj);

end
