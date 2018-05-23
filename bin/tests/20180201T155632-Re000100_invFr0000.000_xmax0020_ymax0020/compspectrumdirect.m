if (isdir([matrixpth,figdir,'direct/']) == 0)
    mkdir([matrixpth,figdir,'direct/'])
end

shiftvec = shiftvecdirect;

nev = nevdirect;

evals = [];

nshift = 0;

radiom = zeros(length(shiftvec),1);

for shift = shiftvec

    nshift = nshift + 1;

    disp(shift);

    [evec,om] = directMode(ffdata.L, ffdata.B, shift, nev);

    gr_opts.simmcolor = true;
    gr_opts.colormap  = 'bluewhitered';
    nconv = length(om);

    distom = sqrt((om-shift).*conj(om-shift));

    radiomnshift = max(distom);

    radiom(nshift) = radiomnshift;

    evals(end+1:end+nconv,1) = om;

    for k=1:nconv

        disp(['omega: ' num2str(om(k),'%7.5f')])

        eveck = evec(:,k);
        save([matrixpth,figdir,'direct/','w_',num2str(om(k),'%7.5f'),'.mat'],'eveck');
        clear eveck

        if (ISsaveplots == 1)

            figure(101)
            DOF = 1;
            p0 = plotvarsFF(ffdata, real(evec(:,k)), DOF, om(k), gr_opts, '');
            title(['direct mode (omega=' num2str(om(k),'%7.5f') '), real(p0p)'])
            saveas(gcf,[matrixpth,figdir,'direct/','w_',num2str(om(k),'%7.5f'),'_p0p-re.fig'])
            close

            figure(102)
            DOF = 2;
            u1 = plotvarsFF(ffdata, real(evec(:,k)), DOF, om(k), gr_opts, '');
            title(['direct mode (omega=' num2str(om(k),'%7.5f') '), real(u1p)'])
            saveas(gcf,[matrixpth,figdir,'direct/','w_',num2str(om(k),'%7.5f'),'_u1p-re.fig'])
            close

            figure(103)
            DOF = 3;
            u2 = plotvarsFF(ffdata, real(evec(:,k)), DOF, om(k), gr_opts, '');
            title(['direct mode (omega=' num2str(om(k),'%7.5f') '), real(u2p)'])
            saveas(gcf,[matrixpth,figdir,'direct/','w_',num2str(om(k),'%7.5f'),'_u2p-re.fig'])
            close

            figure(104)
            DOF = 4;
            u3 = plotvarsFF(ffdata, real(evec(:,k)), DOF, om(k), gr_opts, '');
            title(['direct mode (omega=' num2str(om(k),'%7.5f') '), real(u3p)'])
            saveas(gcf,[matrixpth,figdir,'direct/','w_',num2str(om(k),'%7.5f'),'_u3p-re.fig'])
            close

            figure(105)
            DOF = 5;
            ro = plotvarsFF(ffdata, real(evec(:,k)), DOF, om(k), gr_opts, '');
            title(['direct mode (omega=' num2str(om(k),'%7.5f') '), real(u3p)'])
            saveas(gcf,[matrixpth,figdir,'direct/','w_',num2str(om(k),'%7.5f'),'_rop-re.fig'])
            close

        end

    end

%       for ii=1:nconv
%           vec=(ffdata.L+1i*om(ii)*ffdata.B)*evec(:,ii);
%           residual(ii)=vec'*vec/(evec(:,ii)'*evec(:,ii));
%       end
%       residual

    save(fullfile(matrixpth,figdir,'direct.mat'), 'evals')

    figure(111)
    hold on
    plot(real(evals), imag(evals), ...
        'o', 'Color', rgb('darkblue'), 'MarkerFaceColor', rgb('skyblue'), ...
        'MarkerSize', 8)
    circles(real(shift), imag(shift), radiomnshift, ...
        'edgecolor', rgb('beige'), 'facecolor', rgb('beige'), 'facealpha', 0.5);
    xlabel('$\omega_r$')
    ylabel('$\omega_i$','rotation',0)
    drawnow
    saveas(111, [matrixpth,figdir,'direct.fig'])

    figure(112)
    hold on
    plot(real(evals)/pi, imag(evals), ...
        'o', 'Color', rgb('darkblue'), 'MarkerFaceColor', rgb('skyblue'), ...
        'MarkerSize', 8)
    xlabel('$St = \omega_{r}/\pi$')
    ylabel('$\omega_i$','rotation',0)
    drawnow
    saveas(112, [matrixpth,figdir,'directSt.fig'])


end

save(fullfile(matrixpth,figdir,'direct.mat'), 'evals')

figure(111), clf
hold on
plot(real(evals), imag(evals), ...
    'o', 'Color', rgb('darkblue'), 'MarkerFaceColor', rgb('skyblue'), ...
    'MarkerSize', 8)
circles(real(shiftvec)', imag(shiftvec)', radiom, ...
    'edgecolor', rgb('beige'), 'facecolor', rgb('beige'), 'facealpha', 0.5);
xlabel('$\omega_r$')
ylabel('$\omega_i$','rotation',0)
drawnow
saveas(111, [matrixpth,figdir,'direct.fig'])

figure(112), clf
hold on
plot(real(evals)/pi, imag(evals), ...
    'o', 'Color', rgb('darkblue'), 'MarkerFaceColor', rgb('skyblue'), ...
    'MarkerSize', 8)
xlabel('$St = \omega_{r}/\pi$')
ylabel('$\omega_i$','rotation',0)
drawnow
saveas(112, [matrixpth,figdir,'directSt.fig'])

wilfriedwritevectortofile(real(evals(isfinite(evals)))   ,[matrixpth,figdir,'directwr.dat']);
wilfriedwritevectortofile(imag(evals(isfinite(evals)))   ,[matrixpth,figdir,'directwi.dat']);
wilfriedwritevectortofile(real(evals(isfinite(evals)))/pi,[matrixpth,figdir,'directSt.dat']);

