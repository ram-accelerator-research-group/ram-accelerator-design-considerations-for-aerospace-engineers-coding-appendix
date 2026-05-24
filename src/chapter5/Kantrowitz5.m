function [ area_ratio ] = Kantrowitz5( Mach_num,gamma )
%
% Usage:
%
% [ area_ratio ] = Kantrowitz5( Mach_num,gamma )
% The purpose of this function is to calculate the Kantrowitz area ratio,
% of (area at cowl lip / area at inlet throat), required for a
% self-starting scramjet inlet.
% From Van Wie et al., "Starting characteristics of supersonic inlets,"
% p. 2.
%

term_0 = (Mach_num);

term_1_num = (gamma+1).*(Mach_num.^2);
term_1_den = ((gamma-1).*(Mach_num.^2))+2;
term_1_power = (-gamma)./(gamma-1);
term_1 = (term_1_num./term_1_den).^term_1_power;

term_2_num = (gamma+1);
term_2_den = (2*gamma.*(Mach_num.^2))-(gamma-1);
term_2_power = -1./(gamma-1);
term_2 = (term_2_num./term_2_den).^term_2_power;

term_3_num = 1+(((gamma-1)/2).*(Mach_num.^2));
term_3_den = (gamma+1)/2;
term_3_power = -((gamma+1)./(2*(gamma-1)));
term_3_p1 = term_3_num./term_3_den;
term_3 = term_3_p1.^term_3_power;

area_ratio_a4_over_a0 = term_0.* term_1.* term_2.* term_3;
% note this is now in the form of r_inlet/r_throat
area_ratio = 1./area_ratio_a4_over_a0;

end
