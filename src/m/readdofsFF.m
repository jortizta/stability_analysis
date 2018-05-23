function [ffdata] = readdofsFF(fullfilename,ffdata)
%
% readdofsFF.m
%
% Read FreeFem++ DOFs from .dat file.
%
% inputs: fullfilename > full path (e.g. sthg like: fullfile(pathname,filename))
%
%

disp 'readdofsFF'
tic;

uxy = load(fullfilename);
u = uxy(:,1);   % [0,1,2,3,4] for p,u,v,w,rho
x = uxy(:,2);   % x coords
y = uxy(:,3);   % y coords

nvar = max(u)+1;
ntot = length(u);

ffdata.nvar = nvar;
ffdata.dofs = uxy;
ffdata.ntot = ntot;
ffdata.x = x;

toc

end
