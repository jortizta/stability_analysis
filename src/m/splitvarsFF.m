function [Cp,Ce,Ct,Cv] = splitvarsFF(ffdata,q)

idof     = ffdata.idof;
itot     = ffdata.itot;
vartype  = ffdata.vartype;
varorder = ffdata.varorder;

for k = 1:length(vartype);

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

    Cv{k} = v;
    Cp{k} = p;
    Ce{k} = e;
    Ct{k} = t;

end

end

