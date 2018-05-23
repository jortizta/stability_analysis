pth = '/Users/wil/Documents/Work/Projects/Stratified-Wakes/dat/x/x/';

analysistype = 'spectrumdirect';

ISsaveplots       = 1;
ISpatchloadmeshff = 0;

Stmax = 1.00;

shiftvecdirect = pi*linspace(0, Stmax, 11);
%shiftvecdirect(1) = pi*1.0e-3;

nevdirect = 5;

Lx = load('xmax.dat');
Ly = load('ymax.dat');

addpath('../');

matrixpth = [pth, 'stab/'];
meshpth   = [pth, 'base/'];

figdir = 'figs/';

if (isdir([matrixpth, figdir]) == 0)
    mkdir([matrixpth, figdir])
end

