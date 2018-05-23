    % Pseudospectrum:

    if (isdir([matrixpth,figdir,'pseudospectrum/']) == 0)
        mkdir([matrixpth,figdir,'pseudospectrum/'])
    end

    [Pu,nu] = buildPu(ffdata, [1,2]); % if only (u,v) are forced: [1,2]

    disp 'Build LU decomposition of PQP'
    PQP  = Pu'*ffdata.Q*Pu;
    [Lq,Uq,Pq,Qq] = lu(PQP);

    if exist(fullfile(matrixpth,figdir,'globalmodes.mat'), 'file')
        globalmodes = load(fullfile(matrixpth,figdir,'globalmodes.mat'));
        evalsr = real(globalmodes.evals(isfinite(globalmodes.evals)));
        evalsi = imag(globalmodes.evals(isfinite(globalmodes.evals)));
        evalsm = [evalsr, evalsi];
        evalsm = sortrows(evalsm,2);
        omr = 0.025                        : 0.025 : 2.50;
        omi = floor(10.0*min(evalsi))/10.0 : 0.025 : ceil(10.0*max(evalsi))/10.0 + 0.1;
        iom = 0;
        for ii = 1:length(omr)
            for jj = 1:length(omi)
                iom = iom+1;
                omega(iom) = omr(ii) + 1i*omi(jj);
            end
        end
        for ii = 1:length(evalsr)
            omega(end+1) = evalsr(ii) + 1i * evalsi(ii);
        end
        ppp = polyfit(evalsr,evalsi,1);
        ppp(2) = ppp(2);
        evalsisep = polyval(ppp,evalsr);
        evalsselr = evalsr(evalsi >= evalsisep);
        evalsseli = evalsi(evalsi >= evalsisep);
        evalsseli = evalsseli(evalsselr>0.2);
        evalsselr = evalsselr(evalsselr>0.2);
        evalsseli = evalsseli(evalsselr<2.0);
        evalsselr = evalsselr(evalsselr<2.0);
        di = 0.01;
        for ii = 1:length(evalsselr)
            omega(end+1) = evalsselr(ii)                 + 1i * (evalsseli(ii) + di      );
            omega(end+1) = evalsselr(ii) - di * 0.866025 + 1i * (evalsseli(ii) - di * 0.5);
            omega(end+1) = evalsselr(ii) + di * 0.866025 + 1i * (evalsseli(ii) - di * 0.5);
        end
    else
        omr =  0.025:0.025:2.500;
        omi = -0.375:0.025:0.100;
        iom = 0;
        for ii = 1:length(omr)
            for jj = 1:length(omi)
                iom = iom+1;
                omega(iom) = omr(ii) + 1i*omi(jj);
            end
        end
    end

    figure(100)
    hold on
    plot(evalsr,     evalsi,     'k.')
    plot(real(omega),imag(omega),'r.')
    axis equal
    axis tight
    if saveplo, saveas(100, [matrixpth,figdir,'pseudospectrumgrid.fig']), close, end


    nom   = length(omega);
    sigma = zeros(1,nom);

    for iom = 1:nom

        om = omega(iom);

        disp(iom);
        tic;
        [sig,f,q] = freqrespFF(ffdata,om,Pu,nu,Lq,Uq,Pq,Qq);
        disp(log10(sig));
        sigma(iom) = sig;
        toc;

        nfr = 0;

        if isreal(om) % frequency response

            nfr = nfr + 1;

            fromega(nfr) = om;
            frsigma(nfr) = sig;

            %response(:,iom) = q;
            % forcing(:,iom) = f;

            gr_opts.simmcolor = true;    % symmetric color range
            gr_opts.colormap  = 'jet';

            disp(['sigma: ' num2str(sig)]);

            figure, DOF = 1;
            fx = plotvarsFF(ffdata, real(f(:,1)), DOF, om, gr_opts, '');
            title(['forcing at omega='  num2str(om,'%7.5f') ', amplification=' num2str(sig,'%7.5f') ', real(ux)'])
            if saveplo, saveas(gcf,[matrixpth,figdir,'pseudospectrum/','w-' num2str(om,'%7.5f') '-forc-ux.fig']), close, end

            figure, DOF = 1;
            ux = plotvarsFF(ffdata, real(q(:,1)), DOF, om, gr_opts, '');
            title(['response at omega=' num2str(om,'%7.5f') ', amplification=' num2str(sig,'%7.5f') ', real(ux)'])
            if saveplo, saveas(gcf,[matrixpth,figdir,'pseudospectrum/','w-' num2str(om,'%7.5f') '-resp-ux.fig']), close, end

            figure, DOF = 3;
            p  = plotvarsFF(ffdata, real(q(:,1)), DOF, om, gr_opts, '');
            title(['response at omega=' num2str(om,'%7.5f') ', amplification=' num2str(sig,'%7.5f') ', real(p)'])
            if saveplo, saveas(gcf,[matrixpth,figdir,'pseudospectrum/','w-' num2str(om,'%7.5f') '-resp-p.fig' ]), close, end

            pause(0.1)

        end

        if mod(iom,100) == 0
            save( fullfile(matrixpth,figdir,['pseudospectrum-',sprintf('%04d',iom),'.mat']), 'omega','sigma' )
        end

    end

    frSt = fromega/pi;

    save( fullfile(matrixpth,figdir,'pseudospectrum.mat'), 'omega','sigma' )

    save( fullfile(matrixpth,figdir,'freqresp.mat'), 'fromega','frsigma' )

    figure(101)
    plot(frSt,frsigma,'k-')
    xlabel('St = \omega_r/\pi')
    ylabel('Gain','rotation',0)
    set(gca,'yscale','log');

    wilfriedwritevectortofile(fromega,[matrixpth,figdir,'veuszfreqrespfromega.dat']);
    wilfriedwritevectortofile(frSt   ,[matrixpth,figdir,'veuszfreqrespfrSt.dat']);
    wilfriedwritevectortofile(frsigma,[matrixpth,figdir,'veuszfreqrespfrsigma.dat']);

    if saveplo, saveas(101,[matrixpth,figdir,'freqresp.fig']), close, end

    omega = omega.';
    sigma = sigma.';

    omr = real(omega);
    omi = imag(omega);

    epsilonlog = log10(1./sigma);

    F = TriScatteredInterp(omr,omi,epsilonlog,'natural');

    [omrint ,omiint ] = meshgrid(linspace(ceil(10.0*min(omr))/10.0,floor(10.0*max(omr))/10.0,801), ...
                                 linspace(ceil(10.0*min(omi))/10.0,floor(10.0*max(omi))/10.0,801));

    Stint = omrint/pi;

    epslogint =  F(omrint,omiint);

%    figure(102)
%    contour(omrint,omiint,epslogint,[-15:0.1:0])
%    xlabel('\omega_r')
%    ylabel('\omega_i','rotation',0)
%    colorbar
%    set(gca,'DataAspectRatio',[1 pi 1])
%    axis tight
%    if saveplo, saveas(gcf,[matrixpth,figdir,'pseudospectrum.fig']), close, end

    figure(103)
    pcolor(Stint,omiint,epslogint)
    shading interp
    xlabel('St = \omega_r/\pi')
    ylabel('\omega_i','rotation',0)
    colorbar
    set(gca,'CLim',[-15.0,0.0])
    set(gca,'DataAspectRatio',[1 pi 1])
    axis tight
    if saveplo, saveas(gcf,[matrixpth,figdir,'pseudospectrum.fig']), close, end

    wilfriedwritematrixtofile(  epslogint,[matrixpth,figdir,'veuszpseudospectrumepslogint.dat']);
    wilfriedwritevectortofile( Stint(1,:),[matrixpth,figdir,'veuszpseudospectrumStint.dat']);
    wilfriedwritevectortofile(omrint(1,:),[matrixpth,figdir,'veuszpseudospectrumomrint.dat']);
    wilfriedwritevectortofile(omiint(:,1),[matrixpth,figdir,'veuszpseudospectrumomiint.dat']);


    omrintfreqresp = linspace(ceil(10.0*min(omr))/10.0,floor(10.0*max(omr))/10.0,801);
    omiintfreqresp = zeros(size(omrintfreqresp));
    frsigmaint = 10.^(-F(omrintfreqresp,omiintfreqresp));
    fromegaint = omrintfreqresp;
    frStint    = fromegaint/pi;

    wilfriedwritevectortofile(fromegaint,[matrixpth,figdir,'veuszfreqrespfromegaint.dat']);
    wilfriedwritevectortofile(frStint   ,[matrixpth,figdir,'veuszfreqrespfrStint.dat']);
    wilfriedwritevectortofile(frsigmaint,[matrixpth,figdir,'veuszfreqrespfrsigmaint.dat']);
