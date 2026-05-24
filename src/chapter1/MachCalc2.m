function [ Machvec ] = MachCalc2( vvec,Altvec )
%
% Usage:
%
% [ Machvec ] = MachCalc2( vvec,Altvec )
%
% The purpose of this function is to take a series of velocities
% in (m/s) over a corresponding range of altitudes in m, and return the
% Mach numbers corresponding to these values.
%
% This routine calls the non-Matlab subroutines refpropm and TempAltCS6.
%
% The subroutine TempAltCS6 requires calculation of
% atmospheric properties using tabular data, generated using the
% parameters of US Standard Atmosphere 1976.

% Hand Altvec's values off to an internal variable.

Altvec2=[];
Altvec2=Altvec;

%Find size of vectors
numval = max(size(Altvec2));

%Set up speed of sound vector
C=ones(1,numval);

for i = 1:1:numval
C(1,i)=C(1,i).*refpropm( 'A','T',TempAltCS6(Altvec2(1,i)), 'P', 101.325,'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]);
end

Machvec=vvec./C;
end
