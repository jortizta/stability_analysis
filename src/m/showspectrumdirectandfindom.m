function showspectrumdirectandfindom

params;

modes_d = load(fullfile(matrixpth,figdir,'direct.mat'));

evalsr = real(modes_d.evals(isfinite(modes_d.evals)));
evalsi = imag(modes_d.evals(isfinite(modes_d.evals)));

figure(499)
hold on
plot(evalsr/pi, evalsi, ...
    'o', 'Color', rgb('black'), 'MarkerFaceColor', rgb('skyblue'), ...
    'MarkerSize', 8)
xlabel('$St = \omega_{r}/\pi$')
ylabel('$\omega_i$','rotation',0)
drawnow

disp('Click on 1 eigenvalue!')

[posr,posi] = ginput(1);

posr = posr*pi;

evalsm = [evalsr, evalsi];

distpos = sqrt((evalsr-posr).^2 + (evalsi-posi).^2);

evalsmd = [evalsr, evalsi, distpos];

evalsmd = sortrows(evalsmd,3);

om_d = evalsmd(1,1) + 1i*evalsmd(1,2);

display([num2str(real(om_d),'%08.5f'), ' ', num2str(imag(om_d),'%08.5f')])

figure(499)
plot(real(om_d)/pi, imag(om_d), ...
    'o', 'Color', rgb('black'), 'MarkerFaceColor', rgb('magenta'), ...
    'MarkerSize', 8)
