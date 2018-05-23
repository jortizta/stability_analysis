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
p0bG = importdata([ddir, 'p0bG.dat'], ' ', 1);
u1bG = importdata([ddir, 'u1bG.dat'], ' ', 1);
u2bG = importdata([ddir, 'u2bG.dat'], ' ', 1);
u3bG = importdata([ddir, 'u3bG.dat'], ' ', 1);
TebG = importdata([ddir, 'TebG.dat'], ' ', 1);
ZtbG = importdata([ddir, 'ZtbG.dat'], ' ', 1);
xibG = importdata([ddir, 'xibG.dat'], ' ', 1);
sfbG = importdata([ddir, 'sfbG.dat'], ' ', 1);

  xG =   xG.data;
  yG =   yG.data;
p0bG = p0bG.data;
u1bG = u1bG.data;
u2bG = u2bG.data;
u3bG = u3bG.data;
TebG = TebG.data;
ZtbG = ZtbG.data;
xibG = xibG.data;
sfbG = sfbG.data;

Nx = ffnx*LLx+1;
Ny = ffny*LLy+1;

Zts = 1.0/(1.0+S/LeF);

  xG =   xG(1:dny:Ny,1:dnx:Nx);
  yG =   yG(1:dny:Ny,1:dnx:Nx);
p0bG = p0bG(1:dny:Ny,1:dnx:Nx);
u1bG = u1bG(1:dny:Ny,1:dnx:Nx);
u2bG = u2bG(1:dny:Ny,1:dnx:Nx);
u3bG = u3bG(1:dny:Ny,1:dnx:Nx);
TebG = TebG(1:dny:Ny,1:dnx:Nx);
ZtbG = ZtbG(1:dny:Ny,1:dnx:Nx);
xibG = xibG(1:dny:Ny,1:dnx:Nx);
sfbG = sfbG(1:dny:Ny,1:dnx:Nx);

  xGD = [xG;xG];
  yGD = [-flipud(yG);yG];
p0bGD = [flipud(p0bG);p0bG];
u1bGD = [flipud(u1bG);u1bG];
u2bGD = [flipud(u2bG);u2bG];
u3bGD = [flipud(u3bG);u3bG];
TebGD = [flipud(TebG);TebG];
ZtbGD = [flipud(ZtbG);ZtbG];
xibGD = [flipud(xibG);xibG];
sfbGD = [flipud(sfbG);sfbG];


%figure(301)
%pcolor(yGD,xGD,1.0./TebGD)
%shading interp
%colormap parula
%colorbar
%axis equal
%axis tight
%axis([-LLy LLy 0 LLx])

psfb = 2.5;
sfbvec = linspace(0.0, (max(max(sfbGD)))^(1/psfb), 51).^psfb;


figure(201)

subplot(1,4,1)
pcolor(yGD,xGD,TebGD)
shading interp
colormap parula
colorbar
hold on
contour(yGD,xGD,ZtbGD,[Zts Zts],'k','LineWidth',2)
axis equal
axis tight
axis([-LLy LLy 0 LLx])
drawnow

subplot(1,4,2)
pcolor(yGD,xGD,u1bGD)
shading interp
colormap parula
colorbar
hold on
contour(yGD,xGD,ZtbGD,[Zts Zts],'k','LineWidth',2)
axis equal
axis tight
axis([-LLy LLy 0 LLx])
drawnow

subplot(1,4,3)
pcolor(yGD,xGD,u2bGD)
shading interp
colormap parula
colorbar
hold on
contour(yGD,xGD,ZtbGD,[Zts Zts],'k','LineWidth',2)
axis equal
axis tight
axis([-LLy LLy 0 LLx])
drawnow

subplot(1,4,4)
contour(yGD,xGD,ZtbGD,[Zts Zts],'k','LineWidth',2)
hold on
contour(yGD,xGD,sfbGD,sfbvec,'k','LineWidth',0.5)
axis equal
axis tight
axis([-LLy LLy 0 LLx])
drawnow

%wilfriedwritematrixtofile(u1bGD', [ddir,'VEUSZ_u1b.dat']);
%wilfriedwritematrixtofile(u2bGD', [ddir,'VEUSZ_u2b.dat']);
%wilfriedwritematrixtofile(TebGD', [ddir,'VEUSZ_Teb.dat']);
%wilfriedwritematrixtofile(ZtbGD', [ddir,'VEUSZ_Ztb.dat']);
%wilfriedwritematrixtofile(sfbGD', [ddir,'VEUSZ_sfb.dat']);
