%% inlet_throat_plots_isentropic
% This script is designed to plot a 2D view of the Busemann toroid
% demonstrating how the Isentropic area ratio influences the throat size.

for Mach_num = 1:11

figure()
hold on
grid on

Mach_inf = Mach_num;
bore_diameter = 38.1; % (mm) %UW Ram Accelerator Bore Diameter
r_inlet = (bore_diameter-0.1)/2;

title([ 'Isentropic Area Ratio' ] ,...
['How \gamma influences r_{throat} at Mach ' num2str(Mach_num) ' with bore diameter ' num2str(bore_diameter) 'mm, ' 'subcaliber inlet diameter ' num2str(r_inlet*2) 'mm'],'FontSize' , 27)
xlabel( '\gamma = C_p/C_v' , 'FontSize' , 23)
ylabel( 'r_{throat} (mm)' , 'FontSize' , 23)
set(gca, 'FontSize' ,23)

% For ploting display regions this scales the size of the aerospace
% vehicle when plotted
r_throat_calc_modifier = 1.5;

gamma = [1.5243 1.4 1.3736 1.3143 1.3302 1.2768 1.2525 1.2349];

variable_num_dim = size(gamma);
variable_num_size = variable_num_dim(1,2);

isentropic_area_ratio_1 = Isentropic_Area_Ratio_calc( Mach_num,gamma );

isentropic_area_ratio = 1./isentropic_area_ratio_1;

r_throat_c = r_throat_calc(r_inlet, isentropic_area_ratio);

for ind=1:variable_num_size
labels(ind) = {[ 'r_{throat}= ' num2str(r_throat_c(ind)) 'mm']};
end

for ind=1:variable_num_size

plot(gamma(ind),r_throat_c(ind), 'ob','MarkerSize' ,r_throat_calc_modifier*2*r_throat_c(ind));
plot(gamma(ind),r_throat_c(ind), 'ob','MarkerSize' ,r_throat_calc_modifier*2*r_inlet);
text(gamma(ind),r_throat_c(ind),labels (ind),'VerticalAlignment' ,'top','HorizontalAlignment' ,'left', 'FontSize' , 19,'position' ,[gamma (ind) r_throat_c(ind)-.00011])

end

%%% Plot gamma vs. r_throat through center of 2D Busemann toroids.
%%% This helps display overall trend.
gamma_test = linspace(1.1,1.6);

variable_test_num_dim = size(gamma_test);
variable_test_num_size = variable_test_num_dim(1,2);

area_ratio_test_1 = Isentropic_Area_Ratio_calc( Mach_num,gamma_test );

area_ratio_test = 1./Isentropic_Area_Ratio_calc( Mach_num,gamma_test );
r_throat_c_test = r_throat_calc(r_inlet, area_ratio_test);

plot(gamma_test,r_throat_c_test, '-r')

end
