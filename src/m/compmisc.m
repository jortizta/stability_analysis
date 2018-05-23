    [xr,yr]   = rectgrid;
    [XXr,YYr] = meshgrid(xr,yr);

    wilfriedwritevectortofile(xr,[matrixpth,figdir,'xr.dat'])
    wilfriedwritevectortofile(yr,[matrixpth,figdir,'yr.dat'])



    % Load direct mode:

    globalmodes = load(fullfile(matrixpth,figdir,'globalmodes.mat'));
    evalsr = real(globalmodes.evals(isfinite(globalmodes.evals)));
    evalsi = imag(globalmodes.evals(isfinite(globalmodes.evals)));
    evalsm = [evalsr, evalsi];
    evalsm = sortrows(evalsm,2);
    omd    = evalsm(end,1)+1i*evalsm(end,2)

    qd = load([matrixpth,figdir,'globalmodes/','glob-om-',num2str(omd,'%7.5f'),'.mat'],'eveck');
    qd = qd.eveck;

    %qd = BCnb'*qd;
    %ffdata.Qbisnb = BCnb'*ffdata.Qbis*BCnb;
    %ffdata = loadvarsFF(newindnb,ffdata);

    [Cpd,Ced,Ctd,Cvd] = splitvarsFF(ffdata,qd);

    pud = Cpd{1};
    eud = Ced{1};
    tud = Ctd{1};
     ud = Cvd{1};

    pvd = Cpd{2};
    evd = Ced{2};
    tvd = Ctd{2};
     vd = Cvd{2};

    prhod = Cpd{3};
    erhod = Ced{3};
    trhod = Ctd{3};
     rhod = Cvd{3};

    ppd = Cpd{4};
    epd = Ced{4};
    tpd = Ctd{4};
     pd = Cvd{4};

    % Normalize such that pressure has always same value at outlet:
    inorm = tri2grid(ppd,tpd,pd,63.0,0.0);

      qd =   qd * inorm';
      ud =   ud * inorm';
      vd =   vd * inorm';
    rhod = rhod * inorm';
      pd =   pd * inorm';

    % Although Q is real, there seems to be a very small imaginary part of the
    % norm. We therefore take the real part.
    normqd = sqrt(real(qd'*ffdata.Qbis*qd))
    %normqd = sqrt(real(qd'*ffdata.Qbisnb*qd))

      qd =   qd/normqd;
      ud =   ud/normqd;
      vd =   vd/normqd;
    rhod = rhod/normqd;
      pd =   pd/normqd;

    figure(401), pdeplot(pud, eud, tud, 'xydata', real(ud)), colormap jet, axis equal, axis tight
    figure(402), pdeplot(pvd, evd, tvd, 'xydata', real(vd)), colormap jet, axis equal, axis tight
    figure(403), pdeplot(ppd, epd, tpd, 'xydata', real(pd)), colormap jet, axis equal, axis tight
    figure(404), pdeplot(ppd, epd, tpd, 'xydata', imag(pd)), colormap jet, axis equal, axis tight

      udxy = tri2grid(  pud,  tud,  ud,xr,yr);
      vdxy = tri2grid(  pvd,  tvd,  vd,xr,yr);
    rhodxy = tri2grid(prhod,trhod,rhod,xr,yr);
      pdxy = tri2grid(  ppd,  tpd,  pd,xr,yr);

    wilfriedwritematrixtofile(real(  udxy),[matrixpth,figdir,  'udre.dat']);
    wilfriedwritematrixtofile(real(  vdxy),[matrixpth,figdir,  'vdre.dat']);
    wilfriedwritematrixtofile(real(rhodxy),[matrixpth,figdir,'rhodre.dat']);
    wilfriedwritematrixtofile(real(  pdxy),[matrixpth,figdir,  'pdre.dat']);
    wilfriedwritematrixtofile(imag(  udxy),[matrixpth,figdir,  'udim.dat']);
    wilfriedwritematrixtofile(imag(  vdxy),[matrixpth,figdir,  'vdim.dat']);
    wilfriedwritematrixtofile(imag(rhodxy),[matrixpth,figdir,'rhodim.dat']);
    wilfriedwritematrixtofile(imag(  pdxy),[matrixpth,figdir,  'pdim.dat']);

    ind10 = find(abs(yr-1.0)<1.0e-6);
    ind05 = find(abs(yr-0.5)<1.0e-6);

      udr10 =   udxy(ind10,:);
      vdr10 =   vdxy(ind10,:);
    rhodr10 = rhodxy(ind10,:);
      pdr10 =   pdxy(ind10,:);

      udr05 =   udxy(ind05,:);
      vdr05 =   vdxy(ind05,:);
    rhodr05 = rhodxy(ind05,:);
      pdr05 =   pdxy(ind05,:);

    wilfriedwritevectortofile(real(  udr10),[matrixpth,figdir,  'udr10re.dat'])
    wilfriedwritevectortofile(real(  vdr10),[matrixpth,figdir,  'vdr10re.dat'])
    wilfriedwritevectortofile(real(rhodr10),[matrixpth,figdir,'rhodr10re.dat'])
    wilfriedwritevectortofile(real(  pdr10),[matrixpth,figdir,  'pdr10re.dat'])
    wilfriedwritevectortofile(real(  udr05),[matrixpth,figdir,  'udr05re.dat'])
    wilfriedwritevectortofile(real(  vdr05),[matrixpth,figdir,  'vdr05re.dat'])
    wilfriedwritevectortofile(real(rhodr05),[matrixpth,figdir,'rhodr05re.dat'])
    wilfriedwritevectortofile(real(  pdr05),[matrixpth,figdir,  'pdr05re.dat'])

    wilfriedwritevectortofile(abs(  udr10),[matrixpth,figdir,  'udr10abs.dat'])
    wilfriedwritevectortofile(abs(  vdr10),[matrixpth,figdir,  'vdr10abs.dat'])
    wilfriedwritevectortofile(abs(rhodr10),[matrixpth,figdir,'rhodr10abs.dat'])
    wilfriedwritevectortofile(abs(  pdr10),[matrixpth,figdir,  'pdr10abs.dat'])
    wilfriedwritevectortofile(abs(  udr05),[matrixpth,figdir,  'udr05abs.dat'])
    wilfriedwritevectortofile(abs(  vdr05),[matrixpth,figdir,  'vdr05abs.dat'])
    wilfriedwritevectortofile(abs(rhodr05),[matrixpth,figdir,'rhodr05abs.dat'])
    wilfriedwritevectortofile(abs(  pdr05),[matrixpth,figdir,  'pdr05abs.dat'])

    wilfriedwritevectortofile(abs(real(  udr10)),[matrixpth,figdir,  'udr10absre.dat'])
    wilfriedwritevectortofile(abs(real(  vdr10)),[matrixpth,figdir,  'vdr10absre.dat'])
    wilfriedwritevectortofile(abs(real(rhodr10)),[matrixpth,figdir,'rhodr10absre.dat'])
    wilfriedwritevectortofile(abs(real(  pdr10)),[matrixpth,figdir,  'pdr10absre.dat'])
    wilfriedwritevectortofile(abs(real(  udr05)),[matrixpth,figdir,  'udr05absre.dat'])
    wilfriedwritevectortofile(abs(real(  vdr05)),[matrixpth,figdir,  'vdr05absre.dat'])
    wilfriedwritevectortofile(abs(real(rhodr05)),[matrixpth,figdir,'rhodr05absre.dat'])
    wilfriedwritevectortofile(abs(real(  pdr05)),[matrixpth,figdir,  'pdr05absre.dat'])



    % Load adjoint mode:

    adjointmodes = load(fullfile(matrixpth,figdir,'adjointmodes.mat'));
    evalsr = real(adjointmodes.evals(isfinite(adjointmodes.evals)));
    evalsi = imag(adjointmodes.evals(isfinite(adjointmodes.evals)));
    evalsm = [evalsr, evalsi];
    evalsm = sortrows(evalsm,2);
    oma    = evalsm(1,1)+1i*evalsm(1,2)

    qa = load([matrixpth,figdir,'adjointmodes/','adj-om-',num2str(oma,'%7.5f'),'.mat'],'eveck');
    qa = qa.eveck;

    %qa = BCnb'*qa;

    %normqa = qa'*ffdata.Qbisnb*qd
    normqa = qa'*ffdata.Qbis*qd
    qa = qa/conj(normqa);

    [Cpa,Cea,Cta,Cva] = splitvarsFF(ffdata,qa);

    pua = Cpa{1};
    eua = Cea{1};
    tua = Cta{1};
     ua = Cva{1};

    pva = Cpa{2};
    eva = Cea{2};
    tva = Cta{2};
     va = Cva{2};

    prhoa = Cpa{3};
    erhoa = Cea{3};
    trhoa = Cta{3};
     rhoa = Cva{3};

    ppa = Cpa{4};
    epa = Cea{4};
    tpa = Cta{4};
     pa = Cva{4};

    figure(501), pdeplot(pua, eua, tua, 'xydata', real(ua)), colormap jet, axis equal, axis tight
    figure(502), pdeplot(pva, eva, tva, 'xydata', real(va)), colormap jet, axis equal, axis tight
    figure(503), pdeplot(ppa, epa, tpa, 'xydata', real(pa)), colormap jet, axis equal, axis tight
    figure(504), pdeplot(ppa, epa, tpa, 'xydata', imag(pa)), colormap jet, axis equal, axis tight

      uaxy = tri2grid(  pua,  tua,  ua,xr,yr);
      vaxy = tri2grid(  pva,  tva,  va,xr,yr);
    rhoaxy = tri2grid(prhoa,trhoa,rhoa,xr,yr);
      paxy = tri2grid(  ppa,  tpa,  pa,xr,yr);

    wilfriedwritematrixtofile(real(  uaxy),[matrixpth,figdir,  'uare.dat']);
    wilfriedwritematrixtofile(real(  vaxy),[matrixpth,figdir,  'vare.dat']);
    wilfriedwritematrixtofile(real(rhoaxy),[matrixpth,figdir,'rhoare.dat']);
    wilfriedwritematrixtofile(real(  paxy),[matrixpth,figdir,  'pare.dat']);
    wilfriedwritematrixtofile(imag(  uaxy),[matrixpth,figdir,  'uaim.dat']);
    wilfriedwritematrixtofile(imag(  vaxy),[matrixpth,figdir,  'vaim.dat']);
    wilfriedwritematrixtofile(imag(rhoaxy),[matrixpth,figdir,'rhoaim.dat']);
    wilfriedwritematrixtofile(imag(  paxy),[matrixpth,figdir,  'paim.dat']);



    % Read base flow:

    [pbase,ebase,tbase,ub,vb,rhob,pb] = readbaseflow(meshpth);

    save([matrixpth,figdir,'pbase.mat'],'pbase')
    save([matrixpth,figdir,'ebase.mat'],'ebase')
    save([matrixpth,figdir,'tbase.mat'],'tbase')
    save([matrixpth,figdir,   'ub.mat'],   'ub')
    save([matrixpth,figdir,   'vb.mat'],   'vb')
    save([matrixpth,figdir, 'rhob.mat'], 'rhob')
    save([matrixpth,figdir,   'pb.mat'],   'pb')

      ubF = TriScatteredInterp(pbase(1,:).',pbase(2,:).',  ub.','natural');
      vbF = TriScatteredInterp(pbase(1,:).',pbase(2,:).',  vb.','natural');
    rhobF = TriScatteredInterp(pbase(1,:).',pbase(2,:).',rhob.','natural');
      pbF = TriScatteredInterp(pbase(1,:).',pbase(2,:).',  pb.','natural');
      ubxy =   ubF(XXr,YYr);
      vbxy =   vbF(XXr,YYr);
    rhobxy = rhobF(XXr,YYr);
      pbxy =   pbF(XXr,YYr);

    [drhobdx,drhobdr] = gradient(rhobxy,xr,yr);
    [  dpbdx,  dpbdr] = gradient(  pbxy,xr,yr);

    [drhoddx,drhoddr] = gradient(rhodxy,xr,yr);
    [  dpddx,  dpddr] = gradient(  pdxy,xr,yr);

    wilfriedwritematrixtofile(  ubxy,[matrixpth,figdir,  'ub.dat']);
    wilfriedwritematrixtofile(  vbxy,[matrixpth,figdir,  'vb.dat']);
    wilfriedwritematrixtofile(rhobxy,[matrixpth,figdir,'rhob.dat']);
    wilfriedwritematrixtofile(  pbxy,[matrixpth,figdir,  'pb.dat']);



    % Calculate baroclinic torque:

    bartorA1 =    (drhobdx.*dpddr) ./ rhobxy.^2;
    bartorA2 =    (drhoddx.*dpbdr) ./ rhobxy.^2;
    bartorA3 =    (- dpbdx.*drhoddr) ./ rhobxy.^2;
    bartorA4 =    (- dpddx.*drhobdr) ./ rhobxy.^2;
    bartorA  =    (drhobdx.*dpddr + drhoddx.*dpbdr - dpbdx.*drhoddr - dpddx.*drhobdr) ./ rhobxy.^2;
    bartorB  =  - (drhobdx.*dpbdr - dpbdx.*drhobdr) .* 2.0 .* rhodxy ./ rhobxy.^3;

    bartor = bartorA + bartorB;

    figure(666), pcolor(XXr,YYr,real(bartor)), shading interp, axis equal, axis tight

    figure(667), pcolor(XXr,YYr,real(bartorA4)), shading interp, axis equal, axis tight

    wilfriedwritematrixtofile(real(bartor),[matrixpth,figdir,'bartorre.dat']);



    % Structural sensitivity:

    sens = sqrt(conj(ua).*ua + conj(va).*va) .* ...
           sqrt(conj(ud).*ud + conj(vd).*vd);

    figure(801), pdeplot(pud,eud,tud,'xydata',sens), axis equal, axis tight, colormap(jet), colorbar

    sensxy = tri2grid(pua,tua,sens,xr,yr);

    wilfriedwritematrixtofile(      sensxy,[matrixpth,figdir,'sens.dat']);



    % Endogeneity:

    endo = conj(qa).*(ffdata.L*qd);

    [Cpe,Cee,Cte,Cve] = splitvarsFF(ffdata,endo);

    pue = Cpe{1};
    eue = Cee{1};
    tue = Cte{1};
     ue = Cve{1};

    pve = Cpe{2};
    eve = Cee{2};
    tve = Cte{2};
     ve = Cve{2};

    prhoe = Cpe{3};
    erhoe = Cee{3};
    trhoe = Cte{3};
     rhoe = Cve{3};

    ppe = Cpe{4};
    epe = Cee{4};
    tpe = Cte{4};
     pe = Cve{4};

      uexy = tri2grid(  pue,  tue,  ue,xr,yr);
      vexy = tri2grid(  pve,  tve,  ve,xr,yr);
    rhoexy = tri2grid(prhoe,trhoe,rhoe,xr,yr);
      pexy = tri2grid(  ppe,  tpe,  pe,xr,yr);

    endoxy = uexy + vexy + rhoexy + pexy;

    wilfriedwritematrixtofile(real(endoxy),[matrixpth,figdir,'endore.dat']);
    wilfriedwritematrixtofile(imag(endoxy),[matrixpth,figdir,'endoim.dat']);



    % Sensitivity to base flow modifications

    YYrNZ = YYr;
    YYrNZ(find(YYrNZ<1e-9)) = 1e-3;

    [duddx,duddr] = gradient(udxy,xr,yr);
    [dvddx,dvddr] = gradient(vdxy,xr,yr);

    [duadx,duadr] = gradient(uaxy,xr,yr);
    [dvadx,dvadr] = gradient(vaxy,xr,yr);

    Sadvu = -conj(duddx).*uaxy      -conj(dvddx).*vaxy;
    Sadvv = -conj(duddr).*uaxy      -conj(dvddr).*vaxy;

    Sprou = duadx.*conj(udxy) + duadr.*conj(vdxy);
    Sprov = dvadx.*conj(udxy) + dvadr.*conj(vdxy);

    Su = Sadvu + Sprou;
    Sv = Sadvv + Sprov;

    Svel = sqrt(real(Su).^2 + real(Sv).^2);

    figure(3001), pcolor(xr, yr, Svel), shading interp
    hold on
    thn = 5;
    xrt = xr(1:thn:end,1:thn:end);
    yrt = yr(1:thn:end,1:thn:end);
    Sut = Su(1:thn:end,1:thn:end);
    Svt = Sv(1:thn:end,1:thn:end);
    quiver(xrt,yrt,real(Sut),real(Svt),2,'k-')
    daspect([1 1 1]);

    wilfriedwritematrixtofile(real(Sprou),[matrixpth,figdir,'Sproure.dat']);
    wilfriedwritematrixtofile(real(Sprov),[matrixpth,figdir,'Sprovre.dat']);
    wilfriedwritematrixtofile(real(Sadvu),[matrixpth,figdir,'Sadvure.dat']);
    wilfriedwritematrixtofile(real(Sadvv),[matrixpth,figdir,'Sadvvre.dat']);
    wilfriedwritematrixtofile(imag(Sprou),[matrixpth,figdir,'Sprouim.dat']);
    wilfriedwritematrixtofile(imag(Sprov),[matrixpth,figdir,'Sprovim.dat']);
    wilfriedwritematrixtofile(imag(Sadvu),[matrixpth,figdir,'Sadvuim.dat']);
    wilfriedwritematrixtofile(imag(Sadvv),[matrixpth,figdir,'Sadvvim.dat']);

    wilfriedwritematrixtofile(real(Su),[matrixpth,figdir,'Sure.dat']);
    wilfriedwritematrixtofile(real(Sv),[matrixpth,figdir,'Svre.dat']);
    wilfriedwritematrixtofile(imag(Su),[matrixpth,figdir,'Suim.dat']);
    wilfriedwritematrixtofile(imag(Sv),[matrixpth,figdir,'Svim.dat']);

    wilfriedwritematrixtofile(real(Sut),[matrixpth,figdir,'Sutre.dat']);
    wilfriedwritematrixtofile(real(Svt),[matrixpth,figdir,'Svtre.dat']);
    wilfriedwritematrixtofile(imag(Sut),[matrixpth,figdir,'Sutim.dat']);
    wilfriedwritematrixtofile(imag(Svt),[matrixpth,figdir,'Svtim.dat']);

    wilfriedwritematrixtofile(    Svel,[matrixpth,figdir,'Svel.dat']);



end

