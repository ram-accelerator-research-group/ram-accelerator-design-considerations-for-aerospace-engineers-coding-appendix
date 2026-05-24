function [ pressvec ] = BarForm2( altvec )
%
% Usage: [ pressvec ] = BarForm2( altvec )
%
% The purpose of this function is to find the barometric pressures
% (in Pascals) of Earth's atmosphere, for a range of given altitudes
% (in m). This is done by interpolating tables generated from the
% parameters specified for the US Standard Atmosphere
% 1976.
%
% Input terms:
%
% altvec = vector of altitudes (in m) for which the barometric pressure
% is to be evaluated
%
% Output terms:
%
% pressvec = the barometric pressures (in Pa) at those altitudes

% Hand off the input variable to a local variable.

%size_altvec=size(altvec) ;

altvec2=[];

altvec2=altvec;

%size_altvec2=size(altvec2) ;

% Load the table of altitudes and pressures used to interpolate the values.

load altpress2 ;

% Load the altitude and pressure data into input vectors for the spline routine.

tabalt=altpress2(1,:);

tabpress=altpress2(2,:);

% Use a spline to interpolate the table values, to get the corresponding
% pressure values for the altitude input vector.

pressvec=spline(tabalt,tabpress,altvec2);

end
