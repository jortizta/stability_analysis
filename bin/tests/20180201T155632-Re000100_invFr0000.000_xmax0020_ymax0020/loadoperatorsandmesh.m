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

disp 'read L' ; L  = readmatFF(fullfile(matrixpth,'LNS'), readmattype); L  = BC'*L*BC;
disp 'read B' ; B  = readmatFF(fullfile(matrixpth,'B'  ), readmattype); B  = BC'*B*BC;
disp 'read B2'; B2 = readmatFF(fullfile(matrixpth,'B2' ), readmattype); B2 = BC'*B2*BC;
disp 'read Q' ; Q  = readmatFF(fullfile(matrixpth,'Q'  ), readmattype); Q  = BC'*Q*BC;

% remove residual non-Hermitian parts of B:
% B = 0.5*(B+B');

ffdata = struct('BC',BC,'L',L,'B',B,'B2',B2,'Q',Q);

ffdata = readdofsFF(fullfile(matrixpth,'dofs.dat'),ffdata);
ffdata = loadvarsFF(newind,ffdata);

clear BC L B B2 Q;

ffdata = loadmeshFF(meshpth,ffdata,ISpatchloadmeshff);

