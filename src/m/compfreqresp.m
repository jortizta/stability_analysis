    % Frequency response:

    if (isdir([matrixpth,figdir,'freqresp/']) == 0)
        mkdir([matrixpth,figdir,'freqresp/'])
    end

    [Pu,nu] = buildPu(ffdata, [1,2]); % if only (u,v) are forced: [1,2]

    disp 'Build LU decomposition of PQP'
    PQP  = Pu'*ffdata.Q*Pu;
    [Lq,Uq,Pq,Qq] = lu(PQP);

    if exist(fullfile(matrixpth,figdir,'globalmodes.mat'), 'file')
        globalmodes = load(fullfile(matrixpth,figdir,'globalmodes.mat'));
        evalsr = real(globalmodes.evals(isfinite(globalmodes.evals)));
        evalsi = imag(globalmodes.evals(isfinite(globalmodes.evals)));
        evalsi = evalsi(evalsr > 0.5);
        evalsr = evalsr(evalsr > 0.5);
        evalsi = evalsi(evalsr < 2.0);
        evalsr = evalsr(evalsr < 2.0);
        evalsm = [evalsr, evalsi];
        evalsm = sortrows(evalsm,2);
        clear evalsr
        clear evalsi
        evalsr = evalsm(:,1);
        evalsi = evalsm(:,2);
        evalsr = evalsr(abs(evalsi) < 0.05);
        evalsi = evalsi(abs(evalsi) < 0.05);
        % OPGELET:
        %omega =  0.025 : 0.025 : 2.500;
        omega =  0.350 : 0.050 : 1.600;
        if length(evalsr) > 0
            for ii = 1:length(evalsr)
                omega(end+1) = evalsr(ii)-0.016;
                omega(end+1) = evalsr(ii)-0.008;
                omega(end+1) = evalsr(ii)-0.004;
                omega(end+1) = evalsr(ii)-0.002;
                omega(end+1) = evalsr(ii)-0.001;
                omega(end+1) = evalsr(ii);
                omega(end+1) = evalsr(ii)+0.001;
                omega(end+1) = evalsr(ii)+0.002;
                omega(end+1) = evalsr(ii)+0.004;
                omega(end+1) = evalsr(ii)+0.008;
                omega(end+1) = evalsr(ii)+0.016;
            end
            omega = sort(omega);
        end
    else
        omega =  0.350 : 0.050 : 1.600;
        %omega =  0.025 : 0.025 : 2.500;
    end
    nom = length(omega);
    sigma = zeros(1,nom);

    omega

    for iom = 1:nom

        om = omega(iom);

        [sig,f,q] = freqrespFF(ffdata,om,Pu,nu,Lq,Uq,Pq,Qq);

        sigma(iom) = sig;
        %response(:,iom) = q;
        % forcing(:,iom) = f;

        figure(104); hold on; plot(om,sig,'.')
        set(gca,'yscale','log');

        gr_opts.simmcolor = true;    % symmetric color range
        gr_opts.colormap  = 'jet';
        nconv = length(sig);

        for k=1:nconv

            disp(['sigma: ' num2str(sigma(k))]);

            figure, DOF = 1;
            fx = plotvarsFF(ffdata, real(f(:,k)), DOF, om(k), gr_opts, '');
            title(['forcing at omega='  num2str(om,'%7.5f') ', amplification=' num2str(sig,'%7.5f') ', real(ux)'])
            if saveplo, saveas(gcf,[matrixpth,figdir,'freqresp/','w-' num2str(om,'%7.5f') '-forc-ux.fig']), close, end

            figure, DOF = 1;
            ux = plotvarsFF(ffdata, real(q(:,k)), DOF, om(k), gr_opts, '');
            title(['response at omega=' num2str(om,'%7.5f') ', amplification=' num2str(sig,'%7.5f') ', real(ux)'])
            if saveplo, saveas(gcf,[matrixpth,figdir,'freqresp/','w-' num2str(om,'%7.5f') '-resp-ux.fig']), close, end

            figure, DOF = 3;
            p  = plotvarsFF(ffdata, real(q(:,k)), DOF, om(k), gr_opts, '');
            title(['response at omega=' num2str(om,'%7.5f') ', amplification=' num2str(sig,'%7.5f') ', real(p)'])
            if saveplo, saveas(gcf,[matrixpth,figdir,'freqresp/','w-' num2str(om,'%7.5f') '-resp-p.fig' ]), close, end

        end

        pause(0.1)

    end

    St = omega/pi;

    save( fullfile(matrixpth,figdir,'freqresp.mat'), 'omega','sigma' )

    if saveplo, saveas(104,[matrixpth,figdir,'freqresp.fig']), close, end

    wilfriedwritevectortofile(omega, [matrixpth, figdir, 'veuszfreqrespfromega.dat']);
    wilfriedwritevectortofile(St   , [matrixpth, figdir, 'veuszfreqrespfrSt.dat']);
    wilfriedwritevectortofile(sigma, [matrixpth, figdir, 'veuszfreqrespfrsigma.dat']);

