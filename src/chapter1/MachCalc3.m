function [ Machvec ] = MachCalc3( vvec,Altvec )
%
% The purpose of this function is to take a series of velocities
% in (m/s) over a corresponding range of altitudes in m, and return the
% Mach numbers corresponding to these values.
%
% Usage:
% [ Machvec ] = MachCalc3( vvec,Altvec ) ;

% PROGRAMMING NOTES
% Make sure you connect your REFPROP directory see line 36.
%
% This routine calls the non-Matlab subroutines refpropm and TempAltCS6.
%
% The subroutine TempAltCS6 requires calculation of
% atmospheric properties using tabular data, generated using the
% parameters of US Standard Atmosphere 1976.

% Hand Altvec's values off to an internal variable.

Altvec2=[];
Altvec2=Altvec;

temp_vec = TempAltCS6(Altvec2);

%Find size of vectors
numval = max(size(Altvec2));

%Set up speed of sound vector
C=ones(1,numval);

% Make a note of the current directory, then move to the REFPROP directory
% for the following calculations.
WD = pwd ;

cd('C:\Program Files (x86)\REFPROP' ) ;

for i = 1:1:numval
C(1,i)=C(1,i).*refpropm( 'A','T',temp_vec(1,i), 'P',101.325, 'nitrogen' ,'argon','oxygen', [0.7557, 0.012700,0.2316]);
end

Machvec=vvec./C;

% Return to the original directory.

cd(WD) ;

end
