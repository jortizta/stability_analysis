function v = plotvarsFF(ffdata,q,k,om,gr_opts,plottype)

% plotvarsFF.m
%
% inputs:  ffdata
%          q > vector to plot
%          k > which DOF (e.g. (u,v,rho,p)=(1,2,3,4)
%          gr_opts > options such as simmcolor [true|false]
%                                 or colormap

idof     = ffdata.idof;
itot     = ffdata.itot;
vartype  = ffdata.vartype;
varorder = ffdata.varorder;

iind = find(ffdata.idofi(k,:)~=0);

if strcmp(vartype(k),'p1')
    v = zeros(ffdata.np1,1);
else % 'p2'
    v = zeros(ffdata.np2,1);
end

if (length(q) == ffdata.ndof)
    qui                       = q( idof(k,idof(k,:)~=0) );
    v( itot(k,itot(k,:)~=0 )) = qui;
    v                         = v(varorder{k});
elseif (length(q) == ffdata.ntot)
    v                         = q(ffdata.idofi(k,iind));
    v                         = v(varorder{k});
else
    disp 'Error(wrong size)'
end

vr = real(v);
vi = imag(v);

if gr_opts.simmcolor
    Mx = max(abs(vr));
    mx = -Mx;
else
    Mx = max(vr);
    mx = min(vr);
end

if strcmp(vartype(k),'p1')
    meshpts = ffdata.meshp1.meshpts;
    meshtri = ffdata.meshp1.meshtri;
else % 'p2'
    meshpts = ffdata.meshp2.meshpts;
    meshtri = ffdata.meshp2.meshtri;
end

p = meshpts';
e = [];
t = double([meshtri,zeros(size(meshtri,1),1)]');

if strcmp(plottype,'phaseVel')

    subplot(3,1,1)
    pdeplot(p,e,t,'xydata',vr)
    caxis([mx,Mx]);
    colormap(gr_opts.colormap);

    xax=0:0.1:max(p(1,:));
    y=0.5;
    vax=tri2grid(p,t,v,xax,y);
    wavnum=(vax(3:end)-vax(1:end-2))./(xax(3:end)-xax(1:end-2))./(1i*vax(2:end-1));
    cph=om./wavnum;

    subplot(3,1,2)
    plot(xax(2:end-1),real(cph))

    subplot(3,1,3)
    plot(xax(2:end-1),imag(cph))

else

    subplot(2,1,1)
    pdeplot(p,e,t,'xydata',vr)
    caxis([mx,Mx]);
    colormap(gr_opts.colormap);

    subplot(2,1,2)
    x=0:0.1:max(p(1,:));
    y=0.5;
    uxy=tri2grid(p,t,vr,x,y);
    semilogy(x,abs(uxy));

end

end
