function [ stagnationT ] = StagTemp( temp,gamma,mach )
%
% StagTemp Function for calculating stagnation temperature
%
% Usage:
%
% [ stagnationT ] = StagTemp( temp,gamma,mach )

stagterm = 1 + (((gamma-1)/2) * (mach.^2));
stagnationT = temp .* stagterm;

end
