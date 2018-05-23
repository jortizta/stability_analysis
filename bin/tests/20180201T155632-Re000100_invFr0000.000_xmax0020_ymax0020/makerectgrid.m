function [xr, yr] = makerectgrid(Lx,Ly,nx,ny)

xrmin = -Lx;
xrmax =  Lx;
yrmin = -Ly;
yrmax =  Ly;

Nxr = nx*(xrmax-xrmin)+1;
Nyr = ny*(yrmax-yrmin)+1;

xr = linspace(xrmin, xrmax, Nxr);
yr = linspace(yrmin, yrmax, Nyr);

