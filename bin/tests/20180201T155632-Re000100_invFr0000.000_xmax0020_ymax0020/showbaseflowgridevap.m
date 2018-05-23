params

dny = 1;
dnx = 1;

LLx = Lx;
LLy = Ly;

ddir = [meshpth,'grid/'];

ffnx = load([ddir, 'N1x.dat']);
ffny = load([ddir, 'N1y.dat']);

  xG = importdata([ddir, 'xG.dat'  ], ' ', 1);
  yG = importdata([ddir, 'yG.dat'  ], ' ', 1);
ZtbG = importdata([ddir, 'ZtbG.dat'], ' ', 1);
sfbG = importdata([ddir, 'sfbG.dat'], ' ', 1);

  xG =   xG.data;
  yG =   yG.data;
ZtbG = ZtbG.data;
sfbG = sfbG.data;

Nx = ffnx*LLx+1;
Ny = ffny*LLy+1;

  xG =   xG(1:dny:Ny,1:dnx:Nx);
  yG =   yG(1:dny:Ny,1:dnx:Nx);
ZtbG = ZtbG(1:dny:Ny,1:dnx:Nx);
sfbG = sfbG(1:dny:Ny,1:dnx:Nx);

  xGD = [xG;xG];
  yGD = [-flipud(yG);yG];
ZtbGD = [flipud(ZtbG);ZtbG];
sfbGD = [flipud(sfbG);sfbG];

psfb = 2.5;
sfbvec = linspace(0.0, (max(max(sfbGD)))^(1/psfb), 51).^psfb;

figure(999)
hold on
contour(yGD,xGD,sfbGD,sfbvec,'r','LineWidth',0.5)
hold on
contour(yGD,xGD,ZtbGD,[Zts Zts],'r','LineWidth',2)
axis equal
axis tight
axis([-LLy LLy 0 LLx])
drawnow




matrixpth = [pth, 'm0-adap-noevap/'];
meshpth   = [pth, 'base-adap-noevap/'];

ddir = [meshpth,'grid/'];

ffnx = load([ddir, 'N1x.dat']);
ffny = load([ddir, 'N1y.dat']);

  xG = importdata([ddir, 'xG.dat'  ], ' ', 1);
  yG = importdata([ddir, 'yG.dat'  ], ' ', 1);
ZtbG = importdata([ddir, 'ZtbG.dat'], ' ', 1);
sfbG = importdata([ddir, 'sfbG.dat'], ' ', 1);

  xG =   xG.data;
  yG =   yG.data;
ZtbG = ZtbG.data;
sfbG = sfbG.data;

Nx = ffnx*LLx+1;
Ny = ffny*LLy+1;

  xG =   xG(1:dny:Ny,1:dnx:Nx);
  yG =   yG(1:dny:Ny,1:dnx:Nx);
ZtbG = ZtbG(1:dny:Ny,1:dnx:Nx);
sfbG = sfbG(1:dny:Ny,1:dnx:Nx);

  xGD = [xG;xG];
  yGD = [-flipud(yG);yG];
ZtbGD = [flipud(ZtbG);ZtbG];
sfbGD = [flipud(sfbG);sfbG];

figure(999)
hold on
contour(yGD,xGD,sfbGD,sfbvec,'k','LineWidth',0.5)
hold on
contour(yGD,xGD,ZtbGD,[Zts Zts],'k','LineWidth',2)
axis equal
axis tight
axis([-LLy LLy 0 LLx])
drawnow

