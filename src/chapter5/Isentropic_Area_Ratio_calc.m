function [ isentropic_area_ratio ] = Isentropic_Area_Ratio_calc( Mach_num,gamma )
% Isentropic Area Ratio
%
% Usage:
% [ isentropic_area_ratio ] = Isentropic_Area_Ratio_calc( Mach_num,gamma )
% From Van Wie, “Scramjet Inlets,” in
% Scramjet Propulsion, E.T Curran and S.N.B. Murthy (eds), Chapter 7,
% p. 463 EQ. 33
%

term_0 = (Mach_num);

term_1_num = (gamma+1);
term_1_den = 2;
term_1_power = (gamma+1)./(2*(gamma-1));
term_1 = (term_1_num./term_1_den).^term_1_power;

term_2_par = 1 + (((gamma-1)/2).*Mach_num.^2);
term_2_power = (gamma+1)./(2*(gamma-1));
term_2 = (term_2_par).^((-1)*term_2_power);

isentropic_area_ratio = term_0 .* term_1 .* term_2 ;

end
