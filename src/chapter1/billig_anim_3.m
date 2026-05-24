function [delta_H_fluid_vec,T_hot_fluid_vec, ...
T_cold_fluid_mat] = ...
billig_anim_3(hot_fluid_str,P_hot_fluid, ...
cold_fluid_str,P_cold_fluid, ...
condensation_ratio_vec, ...
delta_H_min,delta_H_max,num_delta_H, ...
animate_diagram, ...
condensation_ratio_in_legend)

% This function takes, as input, the parameters describing two fluids (the
% hot fluid and the cold fluid) that are being fed into a counterflow heat
% exchanger. It then returns, as output, a Billig diagram, which plots
% the fluids' enthalpy changes on the x axis, and the fluids'
% temperatures on the y axis.
%
% In a physically realistic heat exchange system, the plot of the hot
% fluid's T(delta H) will always be above the cold fluid's T(delta H).
%
% The input terms are
%
% hot_fluid_str = ; P_hot_fluid = ;
% cold_fluid_str = ; P_cold_fluid = ;
% condensation_ratio_vec = ;
% delta_H_min = ; delta_H_max= ; num_delta_H = ;
% plot_diagram = ;
% condensation_ratio_in_legend = ;
%
% where
%
% hot_fluid_str = the string specifiying which fluid
% or mixture is to be used as the
% hot fluid in the subsequent
% calculations.
% NOTE:
% for this routine to work correctly,
% mixtures must be specified by a
% .mix
% ending, and pure fluids must
% be specified by a
% .fld
% ending;
%
% P_hot_fluid = the constant pressure (in kPa) the
% hot fluid is to be held at during
% its trip through the counterflow
% heat exchanger;
%
% cold_fluid_str = the string specifiying which fluid
% or mixture is to be used as the
% cold fluid in the subsequent
% calculations.
% NOTE:
% for this routine to work correctly,
% mixtures must be specified by a
% .mix
% ending, and pure fluids must
% be specified by a
% .fld
% ending;
%
% P_cold_fluid = the constant pressure (in kPa) the
% cold fluid is to be held at during
% its trip through the counterflow
% heat exchanger;
%
% condensation_ratio = the factor by which the mass flux
% of cold fluid needs to be scaled up
% or down to properly absorb enthalpy
% from the hot fluid.
% EXAMPLE:
% Since 13.76 kilograms of air can be
% liquefied by 1 kilogram of
% parahydrogen, the condensation
% ratio will be
% 13.76
% whenever air is the hot fluid
% and parahydrogen is the cold fluid;
%
% delta_H_min = the minimum enthalpy change to be
% used during the calculation of the
% Billig diagram;
%
% delta_H_max = the maximum enthalpy change to be
% used during the calculation of the
% Billig diagram;
%
% num_delta_H = the number of enthalpy changes to
% be used during the calculation of
% the Billig diagram;
%
% plot_diagram = the truth value of whether or not
% the Billig diagram is to be plotted
% by the routine;
%
% and
%
% condensation_ratio_in_legend= the truth value of whether or not
% the condensation ratio (i.e. the
% reciprocal of the cold fluid
% scaling factor) is to be plotted
% by the routine;
%
% Usage:
%
% [delta_H_fluid_vec,T_hot_fluid_vec,...
% T_cold_fluid_mat] = ...
% billig_anim_3(hot_fluid_str,P_hot_fluid,...
% cold_fluid_str,P_cold_fluid,...
% condensation_ratio_vec,...
% delta_H_min,delta_H_max,num_delta_H,...
% animate_diagram,...
% condensation_ratio_in_legend);

% PROGRAMMING NOTES
%
% This routine calls the non-MATLAB subroutine refpropm.

% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
%
% Validate Input
%
% VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

% Do basic validation on the data input before proceeding.

% First, confirm if the fluids' identity strings are indeed strings.

if ischar(hot_fluid_str) == 1
if ischar(cold_fluid_str) == 1
else
error( 'The name of the cold fluid fluid must be a string of characters.' )
end
else
error( 'The name of the hot fluid must be a string of characters.' )
end

% Second, confirm that the hot fluid's string is correctly identified as a
% pure fluid or mixture.

% If the hot fluid is *NOT* ID'd as a pure fluid...
if ~contains(hot_fluid_str, '.fld')
% ...check to see that it is identified as a mixture.

% If the hot fluid is *NOT* ID'd as a mixture...
if ~contains(hot_fluid_str, '.mix')
error( 'The hot fluid must be either a pure fluid (.fld) or a mixture (.mix).' )
else
end

else
end

% If the cold fluid is *NOT* ID'd as a pure fluid...
if ~contains(cold_fluid_str, '.fld')
% ...check to see that it is identified as a mixture.

% If the cold fluid is also *NOT* ID'd as a mixture...
if ~contains(cold_fluid_str, '.mix')
error( 'The cold fluid must be either a pure fluid (.fld) or a mixture (.mix).' )
else
end

else
end

if ischar(animate_diagram)
error( 'The truth value for plot_diagram must be either 1 or 0.' )
else
end

if and(animate_diagram~=0,animate_diagram~=1)
error( 'The truth value for plot_diagram must be either 1 or 0.' )
else
end

if and(condensation_ratio_in_legend~=0,condensation_ratio_in_legend~=1)
error( 'The truth value for give_condensation_ratio must be either 1 or 0.' )
else
end

% DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%
% Do Calculations
%
% DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

% Initialize the vectors that will be used for data storage.

delta_H_fluid_vec = delta_H_min : (delta_H_max-delta_H_min) / (num_delta_H-1) : delta_H_max ;

T_hot_fluid_vec = zeros(1,num_delta_H) ;

T_cold_fluid_mat = zeros(max(size(condensation_ratio_vec)),num_delta_H) ;

% Make a note of the current directory, then move to the REFPROP directory
% for the following calculations.

WD = pwd ;

cd('C:\Program Files (x86)\REFPROP' ) ;

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Hot Fluid
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

for delta_H_itr = 1:num_delta_H

% Calculate the temperature data for the hot fluid.

if contains(hot_fluid_str, '.fld') == 1
NWD1 = pwd ;

cd( 'C:\Program Files (x86)\REFPROP\FLUIDS' )

T_hot_fluid_vec(1,delta_H_itr) = T_hot_fluid_vec(1,delta_H_itr) + refpropm( 'T','H', delta_H_fluid_vec(1,delta_H_itr), 'P',P_hot_fluid,hot_fluid_str) ;

cd(NWD1) ;
else
if contains(hot_fluid_str, '.mix') == 1

NWD2 = pwd ;

cd( 'C:\Program Files (x86)\REFPROP\MIXTURES' )

T_hot_fluid_vec(1,delta_H_itr) = T_hot_fluid_vec(1,delta_H_itr) + refpropm ('T','H',delta_H_fluid_vec(1,delta_H_itr), 'P',P_hot_fluid,hot_fluid_str) ;

cd(NWD2) ;

else
error( 'The hot fluid must be either a pure fluid (.fld) or a mixture (.mix).' )
end
end

end

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Cold Fluid
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


for cr_itr = 1:1:max(size(condensation_ratio_vec))

for delta_H_itr = 1:num_delta_H

condensation_ratio = condensation_ratio_vec(1,cr_itr) ;

% Calculate the temperature data for the cold fluid.

if contains(cold_fluid_str, '.fld') == 1

NWD3 = pwd ;

cd( 'C:\Program Files (x86)\REFPROP\FLUIDS' )

T_cold_fluid_mat(cr_itr,delta_H_itr) = T_cold_fluid_mat(cr_itr,delta_H_itr) + refpropm( 'T','H',delta_H_fluid_vec(1,delta_H_itr)*condensation_ratio, 'P',P_cold_fluid, cold_fluid_str) ;

cd(NWD3) ;
else
if contains(cold_fluid_str, '.mix') == 1

NWD4 = pwd ;

cd( 'C:\Program Files (x86)\REFPROP\MIXTURES' )

T_cold_fluid_mat(cr_itr,delta_H_itr) = T_cold_fluid_mat(cr_itr,delta_H_itr) + refpropm( 'T','H',delta_H_fluid_vec(1,delta_H_itr)*condensation_ratio, 'P',P_cold_fluid, cold_fluid_str) ;

cd(NWD4) ;

else
error( 'The cold fluid must be either a pure fluid (.fld) or a mixture (. mix).')
end
end

end

end

% Return to the original directory.

cd(WD) ;

% MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
%
% Make Animation If Applicable
%
% MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
% AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

if animate_diagram == 1

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

filetype_str = 'billig_anim_' ;

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


set(h_fig_anim, 'units','pixels','position' ,[x0 y0 width height])

% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
%
% Process Names
%
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
% NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN

% Process the fluid name strings so that they can be used in the title
% and legend of the diagram.

if contains(hot_fluid_str, '.fld')
hot_fluid_name_str = erase(hot_fluid_str, '.fld') ;
else
if contains(hot_fluid_str, '.mix')
hot_fluid_name_str = erase(hot_fluid_str, '.mix') ;
else
error( 'The hot fluid must be either a pure fluid (.fld) or a mixture (.mix).' )
end
end

if contains(cold_fluid_str, '.fld')
cold_fluid_name_str = erase(cold_fluid_str, '.fld') ;
else
if contains(cold_fluid_str, '.mix')
cold_fluid_name_str = erase(cold_fluid_str, '.mix') ;
else
error( 'The cold fluid must be either a pure fluid (.fld) or a mixture (.mix).' )
end
end

% HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
%
% Hot Fluid Plot
%
% HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

% Plot the hot fluid data.
figure(h_fig_anim);

h_hot = plot(delta_H_fluid_vec,T_hot_fluid_vec, 'b') ;

% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
%
% Format the Graph
%
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
% GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG

% ...and perform the relevant formatting.

title_str = strcat( 'Billig Diagram for' ,{' '},hot_fluid_name_str,{ ' '},'and',{' '}, cold_fluid_name_str) ;

title(title_str, 'FontSize' ,32,'FontWeight' ,'bold');

xlabel( 'Enthalpy Change (J/kg)' ,'FontSize' ,24,'FontWeight' ,'bold');

ylabel( 'Temperature (K)' ,'FontSize' ,24,'FontWeight' ,'bold');

ax = gca ;
ax.FontSize = 20 ;
ax.FontWeight = 'Bold' ;
ax.GridAlpha = 0.45 ;
ax.LineWidth = 1.5 ;

%Adjust the x-axis limits accordingly.

v = axis;
v(1,1) = delta_H_min ;
v(1,2) = delta_H_max ;

% Adjust the y-axis limits accordingly.

v(1,4) = max(max(T_hot_fluid_vec),max(max(T_cold_fluid_mat))) ;

% ...hold the graph...
hold on
grid

% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
%
% Cold Fluid Plot
%
% CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
% FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
% PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

for cr_itr = 1:1:max(size(condensation_ratio_vec))

% ...then begin plotting the cold fluid data.
figure(h_fig_anim);
h_cold = plot(delta_H_fluid_vec,T_cold_fluid_mat(cr_itr,:), 'r') ;
axis(v);

if condensation_ratio_in_legend == 1
formatSpec = 'CR = %1.2f' ;
CR_str = sprintf(formatSpec,condensation_ratio_vec(1,cr_itr)) ;
legend_cold_fluid_name_str = string(strcat(cold_fluid_name_str,{ ' '},CR_str)) ;
else
legend_cold_fluid_name_str = cold_fluid_name_str ;
end

legend([h_hot,h_cold],{hot_fluid_name_str,legend_cold_fluid_name_str}, 'FontSize' , 20,'FontWeight' ,'bold','Location' ,'northwest' )

% Write the plot to the video file as a frame.
currFrame = getframe(gcf);
writeVideo(vidObj,currFrame);

% Delete the plot.
delete(h_cold);

% Delete the legend.
legend( 'off');

end

else
end

% Close the figure used to create the file.

close gcf ;

% Close the file.

close(vidObj);

end
