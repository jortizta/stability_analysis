function [Pu,nu] = buildPu(ffdata, iu)

% iu = [1,2] if variables = u,v

% Define the matrix of the projection on the velocity space
% Can be made more efficient...

disp('Building Pu matrix');
tic

idof = ffdata.idof;
ndof = ffdata.ndof;
n    = ffdata.n;

% ival = [];
% jval = [];
% dval = [];
% nu   = 0;

nu=sum(n(iu));
ival=zeros(1,nu);
jval=1:nu;
dval=ones(1,nu);
ii=0;

for ivar=1:length(iu)
    for i=1:n(ivar)
%         ival = [ival, idof(ivar,i)];
%         jval = [jval, nu+i];
%         dval = [dval, 1];
        ii = ii+1;
        ival(ii) = idof(ivar,i);
    end
%    nu = nu + n(ivar);
end

Pu = sparse(ival,jval,dval,ndof,nu);

toc

end
