function [ stagnationP ] = StagPress(pressure,gamma,mach)
%
% StagPress Function for calculating stagnation pressure
%
% Usage:
%
% [ stagnationP ] = StagPress(pressure,gamma,mach)
%
% freestream pressure
% pressure of the gas in the bore of the ram accelerator
%
stagPquant = 1+((gamma-1)/2)*(mach.^2);
stagPexp = gamma / (gamma-1);
stagPterm = stagPquant .^ stagPexp;
stagnationP = pressure .* stagPterm;

end
