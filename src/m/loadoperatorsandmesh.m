if exist([matrixpth, 'LNS.mat'], 'file') == 2
    readmattype = 'mat';
else
    readmattype = 'dat';
end

[BC,newind] = loadBCFF(fullfile(matrixpth,'BC.dat'));

%[BCnb,newindnb] = loadBCFF(fullfile(matrixpth,'BCnb.dat'));
% BCnb = BC'*BCnb;

% Read operators (and extract non-BC DOFs):
% With the definitions in varf, Navier-Stokes reads B*dq/dt = L*q

disp 'read L0' ; L0  = readmatFF(fullfile(matrixpth,'LNS0'), readmattype); L0  = BC'*L0*BC;
disp 'read L1' ; L1  = readmatFF(fullfile(matrixpth,'LNS1'), readmattype); L1  = BC'*L1*BC;
disp 'read L2' ; L2  = readmatFF(fullfile(matrixpth,'LNS2'), readmattype); L2  = BC'*L2*BC;
disp 'read B' ; B  = readmatFF(fullfile(matrixpth,'B'  ), readmattype); B  = BC'*B*BC;
disp 'read B2'; B2 = readmatFF(fullfile(matrixpth,'B2' ), readmattype); B2 = BC'*B2*BC;
disp 'read Q' ; Q  = readmatFF(fullfile(matrixpth,'Q'  ), readmattype); Q  = BC'*Q*BC;

% remove residual non-Hermitian parts of B:
% B = 0.5*(B+B');

k = 1;
fprintf('k=1 set in loadoperatorandmesh.m')

L = L0 + k*L1 + k^2**L2; 

ffdata = struct('BC',BC,'L',L,'B',B,'B2',B2,'Q',Q);

ffdata = readdofsFF(fullfile(matrixpth,'dofs.dat'),ffdata);
ffdata = loadvarsFF(newind,ffdata);

clear BC L B B2 Q;

ffdata = loadmeshFF(meshpth,ffdata,ISpatchloadmeshff);

