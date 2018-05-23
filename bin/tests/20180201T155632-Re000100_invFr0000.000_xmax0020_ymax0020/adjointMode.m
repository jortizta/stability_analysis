function [evec,om] = adjointMode(A,B,shift_om,nval,startvec)
%
% Solve A'*w = +i*om*B'*w, for om near shift_om
%
% Input shift_om should be close to conj. of direct eigval of interest
%

if ~issparse(A)
    A=sparse(A);
end
if ~issparse(B)
    B=sparse(B);
end

shift = +1i*shift_om;

OP = A'-shift*B';

[L,U,p,q] = lu(OP,'vector');

h = @(x)shiftinvert(L,U,p,q,B,x);
opts.isreal = false;
opts.maxit  = 200;
opts.tol    = 1e-10;
opts.disp   = 2;
% opts.v0     = startvec;
[evec,v] = eigs(h,length(A),nval,'lm',opts);

%lam = 1./diag(v) + shift_lam;
% convert to omega
om = -1i*( 1./diag(v) + shift );

function out = shiftinvert(L,U,p,q,B,x) % return OP^(-1)*B*x
    y = B*x;
    out(q) = U\(L\y(p));
%    spparms('spumoni',0)
end

end
