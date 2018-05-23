if (isdir([matrixpth,figdir,'adjoint/']) == 0)
    mkdir([matrixpth,figdir,'adjoint/'])
end

shiftvec = 0.90;

nev = 10;

evals = [];

for shift = shiftvec

    disp(shift');

    [evec,om] = adjointMode(ffdata.L, ffdata.B, shift', nev);

    gr_opts.simmcolor = true;    % symmetric color range
    gr_opts.colormap  = 'jet';
    nconv = length(om);

    evals(end+1:end+nconv,1) = om;

    for k = 1:nconv

        disp(['omega: ' num2str(om(k))])

        eveck   = evec(:,k);
        eveckrs = rescaleadjoint(ffdata,eveck);

        figure, DOF = 1;
        ux = plotvarsFF(ffdata, real(eveckrs), DOF, om(k), gr_opts, '');
        title(['adjoint mode (omega=' num2str(om(k)) '), real(u)'])
        if saveplo, saveas(gcf,[matrixpth,figdir,'adjoint/','adj-om-' num2str(om(k),'%7.5f') '-u-.fig']), close, end

        figure, DOF = 2;
        uy = plotvarsFF(ffdata, real(eveckrs), DOF, om(k), gr_opts, '');
        title(['adjoint mode (omega=' num2str(om(k)) '), real(v)'])
        if saveplo, saveas(gcf,[matrixpth,figdir,'adjoint/','adj-om-' num2str(om(k),'%7.5f') '-v-re.fig']), close, end

        figure, DOF = 3;
        uy = plotvarsFF(ffdata, real(eveckrs), DOF, om(k), gr_opts, '');
        title(['adjoint mode (omega=' num2str(om(k)) '), real(rho)'])
        if saveplo, saveas(gcf,[matrixpth,figdir,'adjoint/','adj-om-' num2str(om(k),'%7.5f') '-rho-re.fig']), close, end

        figure, DOF = 4;
        uy = plotvarsFF(ffdata, real(eveckrs), DOF, om(k), gr_opts, '');
        title(['adjoint mode (omega=' num2str(om(k)) '), real(p)'])
        if saveplo, saveas(gcf,[matrixpth,figdir,'adjoint/','adj-om-' num2str(om(k),'%7.5f') '-p-re.fig']), close, end

        save([matrixpth,figdir,'adjointmodes/','adj-om-',num2str(om(k),'%7.5f'),'.mat'],'eveck');
        save([matrixpth,figdir,'adjointmodes/','adjrs-om-',num2str(om(k),'%7.5f'),'.mat'],'eveckrs');
        clear eveck
        clear eveckrs

    end

end

figure(105)
plot(real(evals), imag(evals), 'ro')
xlabel('\omega_r')
ylabel('\omega_i','rotation',0)
set(gca,'DataAspectRatio',[1 pi 1])
pause(0.1)

save( fullfile(matrixpth,figdir,'adjointmodes.mat'), 'evals' )

saveas(105,[matrixpth,figdir,'adjointmodes.fig'])

wilfriedwritevectortofile(real(evals(isfinite(evals))) ,[matrixpth,figdir,'adjointwr.dat']);
wilfriedwritevectortofile(imag(evals(isfinite(evals))) ,[matrixpth,figdir,'adjointwi.dat']);
