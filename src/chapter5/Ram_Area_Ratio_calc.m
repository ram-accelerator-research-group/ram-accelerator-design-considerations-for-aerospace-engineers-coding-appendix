function [ ram_area_ratio ] = Ram_Area_Ratio_calc( Mach_num,gamma )
% Isentropic Area Ratio
%
% Usage:
% [ Ram_area_ratio ] = Ram_Area_Ratio_calc( Mach_num,gamma )
% From "The Subdetonative Ram Accelerator Starting Process"
% By Eric Schultz
% p. 10 EQ. 2.1
%

term_0 = (1/(Mach_num^2));

term_1_num = 2;
term_1_den = (gamma+1);
term_1_power = (gamma+1)./(gamma-1);

term_2_par = 1 + (((gamma-1)/2).*Mach_num.^2);

term_1_2 = ((term_1_num./term_1_den).*(term_2_par)).^term_1_power;

% in the form A_tube/A_throat
ram_area_ratio = sqrt(term_0 .* term_1_2) ;

end
