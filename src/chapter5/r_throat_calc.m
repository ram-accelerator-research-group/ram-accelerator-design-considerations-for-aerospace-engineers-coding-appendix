function [ r_throat_c ] = r_throat_calc(r_inlet,area_ratio)
% This calculates the radius of the throat of the Busemann toroid using the
% Kantrowitz ratio, since the bore size is known.

r_throat_c = sqrt((r_inlet.^2)./area_ratio);

end
