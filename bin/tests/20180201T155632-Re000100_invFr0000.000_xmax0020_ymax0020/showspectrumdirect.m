function showspectrumdirect(varargin)

switch nargin
case 0
    colorname = 'skyblue';
case 1
    colorname = varargin(1);
end

params;

shiftvec = shiftvecdirect;

load(fullfile(matrixpth,figdir,'direct.mat'), 'evals')

figure(111)
hold on
%plot(real(shiftvec), imag(shiftvec), ...
%    'o', 'Color', rgb('beige'), 'MarkerFaceColor', rgb('beige'), ...
%    'MarkerSize', 16)
plot(real(evals), imag(evals), ...
    'o', 'Color', rgb('black'), 'MarkerFaceColor', rgb(colorname), ...
    'MarkerSize', 8)
xlabel('$\omega_r$')
ylabel('$\omega_i$','rotation',0)
drawnow
saveas(111, [matrixpth,figdir,'direct.fig'])

figure(112)
hold on
%plot(real(shiftvec)/pi, imag(shiftvec), ...
%    'o', 'Color', rgb('beige'), 'MarkerFaceColor', rgb('beige'), ...
%    'MarkerSize', 16)
plot(real(evals)/pi, imag(evals), ...
    'o', 'Color', rgb('black'), 'MarkerFaceColor', rgb(colorname), ...
    'MarkerSize', 8)
xlabel('$St = \omega_{r}/\pi$')
ylabel('$\omega_i$','rotation',0)
drawnow
saveas(112, [matrixpth,figdir,'directSt.fig'])

