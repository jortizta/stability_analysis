function [sigma,f,q] = freqrespFF(ffdata,omega,Pu,nu, Lq,Uq,Pq,Qq)



method = 'power'; % power or eigs

dbg = false;

ndof = ffdata.ndof;

% Assemble operators
OP = sparse( ffdata.L + 1i*omega*ffdata.B );
B2 = ffdata.B2;

if dbg,
    figure, spy(ffdata.L), title L
    figure, spy(ffdata.B), title B
    figure, spy(OP), title OP
end

% disp 'Build LU decomposition of (L+iwB)'
[Lop,Uop,Pop,Qop] = lu(OP);


    function w = op(x) % w = (Pu'*Q*Pu)^(-H)*Pu^H*B2^H*OP^(-H)*Q*OP^(-1)*B2*Pu*x where OP=L+i*om*B
        y = Pu*x;
        z = B2*y;
        y = Qop*(Uop\(Lop\(Pop*z)));        % solve OP*y = z
        z = ffdata.Q*y;
        y = Pop'*(Lop'\(Uop'\(Qop'*z)));    % solve OP'*y = z
        z = B2'*y;
        y = Pu'*z;
        w = Pq'*(Lq'\(Uq'\(Qq'*y)));        % solve Q'*w = y
    end

switch method

    case 'eigs'

        % disp 'eigs'
        % tic
        % n = nu;
        % k = 1;
        % opts = struct('isreal',false, 'maxit',30, 'disp',3,'p',3); %  'tol',1e-8,
        % % defaults: tol=eps(machine prec.), maxit=300, disp=1, p=2*k (or at least 20)
        % [V,w] = eigs(@op,n,k,'lm',opts);
        % toc
        % disp(w)
        % disp 'done'

    case 'power'

 %       disp('power iteration')
        restol=1e-6;
        imax=10;
        V=rand(nu,1);
        V=V/sqrt(V'*V);
        res=1; w=1; ii=1;
        while (res>restol && ii<imax)
            Vnew = op(V);
            wnew = V'*Vnew;
            V = Vnew/sqrt(Vnew'*Vnew);
            res = abs((wnew-w)/wnew);
            w = wnew;
            ii = ii+1;
        end
        disp([num2str(ii-1),' iterations']);
end

if dbg, w, end

sigma = sqrt(real(w));
nconv = length(real(w));
f     = zeros(ndof,nconv);
q     = zeros(ndof,nconv);
for k=1:nconv
    f(:,k) = Pu*V(:,k);
    z      = B2*f(:,k);
    q(:,k) = -Qop*(Uop\(Lop\(Pop*z)));  % solve OP*q = -z
end

end
