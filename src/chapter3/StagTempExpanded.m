function [ stagnationTExpanded ] = StagTempExpanded( v,freestream_temp,gamma,R,molar_mass )
%
%StagTempExpanded Function for calculating stagnation temperature, where
%Mach is equal to v^2 / c^2. And v is the velocity of the projectile, c is
%the speed of sound in the gas (local speed of sound).
% Usage:
% [ stagnationTExpanded ] = StagTempExpanded( v,freestream_temp,gamma,R,molar_mass )

stagterm0 = ((gamma-1)/2);
stagterm1 = v.^2;
stagterm2 = molar_mass/(gamma * R);
stagnationTExpanded = freestream_temp + (stagterm0.*stagterm1.*stagterm2);

end
