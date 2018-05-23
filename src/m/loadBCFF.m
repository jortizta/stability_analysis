function [BCmat,newind] = loadBCFF(fullfilename)
%
% loadBCFF.m
%
% Read FreeFem++ BC vector from .dat file, and build BC matrix with
% entry 1 for each non-BC DOF, at (i,j)=(global DOF number, non-BC DOF number)
%
% input: fullfilename > full path (e.g. sthg like: fullfile(pathname,filename))
% outputs: BCmat > BC matrix with entry 1 for each non-BC DOF, at (i,j)=(global DOF #, non-BC DOF #)
%                  Used to extract non-BC DOFs.
%          newind > vector with i-th entry = -1, if i-th DOF is a BC DOF,
%                                          = non-BC DOF number, otherwise
%
%

disp 'loadBCFF'
tic;

bc = load(fullfilename);
n  = length(bc);

ival=find(bc==0);
jval=(1:length(ival))';
dval=ones(size(ival));
newind=-ones(n,1);
newind(ival)=jval;
ind=length(ival);

BCmat = sparse(ival,jval,dval,n,ind);

toc
