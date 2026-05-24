function [ newvec ] = kro( oldvec,lowend,equallow,highend,equalhigh )
%
% Usage: [ newvec ] = kro( oldvec,lowend,equallow,highend,equalhigh )
%
% The purpose of this kro (Keep Range Only) function is to take a vector,
% return a new
% vector the same size as the old one. This is done in a manner such that
% only the values of the old vector that are within a specified range
% will be preserved. These values will be have the same indices in the
% new vector that they had in the old vector. All other parts of the new
% vector will be set to zero.
%
% Input terms:
% oldvec = the vector with the input values;
% lowend = the lowest allowable end of the desired range;
% equallow = 1 if the values to be kept may equal the low end of the desired range,
% =0 if the values to be kept may NOT equal the low end of the
% desired range;
% highend = the highest allowable end of the desired range;
% equalhigh = 1 if the values to be kept may equal the high end of the desired range,
% =0 if the values to be kept may NOT equal the high end of the
% desired range;

%Start by finding everything in oldvec above or at the specified low end.

if equallow==1
aboveind=find(oldvec>=lowend);
else
aboveind=find(oldvec>lowend);
end

%Create a vector of zeros the same size as oldvec. The preserved values
%will ultimately be entered into this vector.

valvec1=zeros(1,max(size(oldvec)));

%Enter the values that are above (or at) the specified lower limit.
for i=1:1:max(size(aboveind))
valvec1(1,aboveind(i)) = valvec1(1,aboveind(i))+oldvec(1,aboveind(i));
end

%valvec1

%Now, find everything in valvec that is below or at the specified high end.

if equalhigh==1
belowind=find(oldvec<=highend);
else
belowind=find(oldvec<highend);
end

%Create a vector of zeros the same size as oldvec. The preserved values
%from valvec1 will ultimately be entered into this vector.

valvec2=zeros(1,max(size(oldvec)));

%valvec1(1,belowind)

%Enter the values that are above (or at) the specified lower limit.
for j=1:1:max(size(belowind))
valvec2(1,belowind(j)) = valvec2(1,belowind(j))+valvec1(1,belowind(j));
end

%valvec2

% The surviving values are now entered into newvec.
newvec=valvec2;

end
