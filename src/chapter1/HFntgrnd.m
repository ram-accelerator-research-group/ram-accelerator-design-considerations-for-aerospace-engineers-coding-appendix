function [ dheatfluxvec ] = HFntgrnd( Tvec,Pstag,rhostag,vvec )
%
% Usage:
%
% [ dheatfluxvec ] = HFntgrnd( Tvec,Pstag,rhostag,vvec )
%
% This function will give the differential heat flux per unit area per
% temperature unit(in W/(m^2 * K)) for an aircraft that is flying through
% Earth's atmosphere, collecting air through an intake of fixed size, and
% cooling that air to a specified temperature in a constant-pressure
% process.
%
% Input terms:
% Tvec=;Pvec=;rhovec=;vvec=;
% where
% Tvec=a vector of temperature values. In the integration, these will
% extend from the stagnation temperature to the cooled-air temperature;
% Pstag=the stagnation pressure;
% rhovec=the density value corresponding to Pstag;
% and
% v=the absolute velocity (in m/s) at which the stagnation
% temperature and pressure are observed.

dheatfluxvec=zeros(1,max(size(Tvec)));
%
for i=1:max(size(Tvec))
Cp=refpropm( 'C','T',Tvec(1,i), 'P',Pstag,'nitrogen' ,'argon','oxygen',[0.7557, 0.012700,0.2316]);
dheatfluxvec(1,i)= dheatfluxvec(1,i)+(Cp.*rhostag.*vvec);
end

end
