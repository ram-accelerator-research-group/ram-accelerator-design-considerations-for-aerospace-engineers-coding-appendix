function [ Tempvec ] = TempAltCS6( altvec )
%
% Usage: [ Tempvec ] = TempAltCS6( altvec )
%
% The purpose of this function is to generate a series of temperatures
% for the Earth's atmosphere over a series of given altitudes, using the
% US Standard Atmosphere 1976 parameters. This series can then be used to
% construct a table of temperatures as a function of altitude. This table
% may then be saved as a .mat file, and used by other routines that
% require such data.
%
% Input terms:
%
% altvec = the vector of all altitudes above sea level, in meters,
% for which the temperature is to be calculated.
%
% Output terms:
%
% Tempvec = the vector of absolute temperatures, in Kelvin,
% corresponding to the input vector of altitudes.

%size_altvec=size(altvec)

altvec2=altvec;

% Load the external data table alttemp2.
load alttemp2;

%size_altvec2=size(altvec2)

tabalt=[];
tabalt=alttemp2(1,:);
size(tabalt);

tabtemp=[];
tabtemp=alttemp2(2,:);
size(tabtemp);

% Interpolate the input data with the table, generating Tempvec.
Tempvec=[];
Tempvec=spline(tabalt,tabtemp,altvec2);

end
