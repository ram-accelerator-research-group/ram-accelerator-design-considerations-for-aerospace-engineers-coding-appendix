function [ heatflux ] = HFcalc2( A,altvec,vvec,Tcool )
% Usage:
%
% [ heatflux ] = HFcalc2( A,altvec,vvec,Tcool )
%
% Consider the case of an aircraft, with a constant intake area A, flying
% through Earth's atmosphere at an altitude h, and at a velocity v. This
% aircraft takes all air going through its intake, at a stagnation
% temperature Tstag, and cools it down to a temperature Tcool, all at the
% constant stagnation pressure Pstag.
% The question then becomes--what amount of heat energy must be
% rejected every second, under these circumstances, to accomplish such
% cooling?
% The purpose of this function is to answer the preceding question.
% This function assumes that all intake air is completely dry, and also
% assumes that no phase changes are encountered as the air is cooled.
%
% The input terms are
% A=;altvec=;vvec=;Tcool=;
% where
% A=the fixed intake area in m^2;
% altvec=the vector of altitude values, in m, over which the aircraft
% flies;
% vvec=the vector of velocities, in m/s, corresponding to those same
% altitudes in altvec
% Tcool=the temperature to which the incoming air is to be cooled.
%
% This program calls the non-Matlab subroutines TempAltCS6, BarForm2,
% MachCalc2, refpropm, StagTemp, and StagPress.
%
% The subroutines TempAltCS6, BarForm2, and MachCalc2 all make reference
% to external data tables. Generation of these tables requires
% calculation of atmospheric properties using US Standard Atmosphere 1976.

% Hand off the values in altvec to an internal variable.
altvec2=[];
altvec2=altvec;

% Calculate the atmospheric temperature at the specified altitude.

tempvec=TempAltCS6( altvec2 );

%load alttemp

%tempvec=spline(alttemp(:,1)',alttemp(:,2)',altvec);

% Calculate the atmospheric pressure at the specified altitude.

pressvec= BarForm2( altvec2 );

%load altpress

%pressvec=spline(altpress(:,1)',altpress(:,2)',altvec);

% Calculate the effective mach number using the information on velocity,
% pressure and temperature.

machvec = MachCalc2( vvec,altvec2 );

% Generate the vector of gamma values corresponding to the temperature and
% pressure values previously obtained.

gammavec=zeros(1,max(size(tempvec)));

for gammait=1:max(size(tempvec))
gammavec(1,gammait)=gammavec(1,gammait)+refpropm( 'K','T',tempvec(1,gammait), 'P',pressvec (1,gammait), 'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]);
end

% Calculate the stagnation temperature at the specified atmospheric
% temperature, atmospheric pressure and velocity.

Tstagvec=StagTemp( tempvec,gammavec,machvec );

% Calculate the stagnation pressure at the specified atmospheric
% temperature, atmospheric pressure and velocity.

Pstagvec= StagPress(pressvec,gammavec,machvec);

% Calculate the density of the gas corresponding to each stagnation temperature and
% pressure combination.

mMair=0.0289644;
R=8.314472; % units of m^3?Pa?K^?1?mol^?1

rhovec = (mMair.*Pstagvec)./(R.*Tstagvec);

% Integrate numerically across the differential heat fluxes from Tstag to
% Tcool. This will be done using Simpson's quadrature.

areaflux=zeros(1,max(size(Pstagvec)));

for iter=1:max(size(Pstagvec))
areaflux(1,iter)=areaflux(1,iter) + quad(@(T)HFntgrnd( T,Pstagvec(1,iter),rhovec(1,iter), vvec(1,iter)),Tstagvec(1,iter),Tcool);
end

% Multiply this integral by the intake area.

heatflux=areaflux.*A;

end
