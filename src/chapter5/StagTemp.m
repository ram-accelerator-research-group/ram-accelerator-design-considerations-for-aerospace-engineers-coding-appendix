function [ stagnationT ] = StagTemp( temp,gamma,mach )
%
% StagTemp Function for calculating stagnation temperature
%
% Usage:
%
% [ stagnationT ] = StagTemp( temp,gamma,mach )
%
% freestream temperature
% temperature of the gas in the bore of the ram accelerator

stagterm = 1 + (((gamma-1)/2) * (mach.^2));
stagnationT = temp .* stagterm;

end
