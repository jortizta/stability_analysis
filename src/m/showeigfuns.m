params;

loadoperatorsandmesh;

[ xr, yr] = makerectgrid(Lx,Ly,4,4);
[xxr,yyr] = meshgrid(xr,yr);

wilfriedwritevectortofile(xr,[matrixpth,figdir,'xr.dat'])
wilfriedwritevectortofile(yr,[matrixpth,figdir,'yr.dat'])

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

om_d = evalsmd(1,1) + 1i*evalsmd(1,2)

figure(499)
plot(real(om_d)/pi, imag(om_d), ...
    'o', 'Color', rgb('black'), 'MarkerFaceColor', rgb('magenta'), ...
    'MarkerSize', 8)

q_d = load([matrixpth,figdir,'direct/','w_',num2str(om_d,'%7.5f'),'.mat'],'eveck');
q_d = q_d.eveck;

[Cp_d,Ce_d,Ct_d,Cv_d] = splitvarsFF(ffdata, q_d);

p_p0p_d = Cp_d{1};
e_p0p_d = Ce_d{1};
t_p0p_d = Ct_d{1};
  p0p_d = Cv_d{1};

p_u1p_d = Cp_d{2};
e_u1p_d = Ce_d{2};
t_u1p_d = Ct_d{2};
  u1p_d = Cv_d{2};

p_u2p_d = Cp_d{3};
e_u2p_d = Ce_d{3};
t_u2p_d = Ct_d{3};
  u2p_d = Cv_d{3};

p_u3p_d = Cp_d{4};
e_u3p_d = Ce_d{4};
t_u3p_d = Ct_d{4};
  u3p_d = Cv_d{4};

p_rop_d = Cp_d{5};
e_rop_d = Ce_d{5};
t_rop_d = Ct_d{5};
  rop_d = Cv_d{5};

% Normalize such that pressure has always same value at outlet:
inorm = tri2grid(p_p0p_d, t_p0p_d, p0p_d, Lx, 0.0);

  q_d =   q_d * inorm';
p0p_d = p0p_d * inorm';
u1p_d = u1p_d * inorm';
u2p_d = u2p_d * inorm';
u3p_d = u3p_d * inorm';
rop_d = rop_d * inorm';

% Although Q is real, there seems to be a very small imaginary part of the
% norm. We therefore take the real part.
normq_d = sqrt(real(q_d'*ffdata.Q*q_d));

  q_d =   q_d/normq_d;
p0p_d = p0p_d/normq_d;
u1p_d = u1p_d/normq_d;
u2p_d = u2p_d/normq_d;
u3p_d = u3p_d/normq_d;
rop_d = rop_d/normq_d;

%figure(400), pdeplot(p_p0p_d, e_p0p_d, t_p0p_d, 'xydata', imag(p0p_d)), colormap bluewhitered, axis equal, axis tight
%figure(401), pdeplot(p_u1p_d, e_u1p_d, t_u1p_d, 'xydata', real(u1p_d)), colormap bluewhitered, axis equal, axis tight
%figure(402), pdeplot(p_u2p_d, e_u2p_d, t_u2p_d, 'xydata', real(u2p_d)), colormap bluewhitered, axis equal, axis tight
%figure(403), pdeplot(p_u3p_d, e_u3p_d, t_u3p_d, 'xydata', real(u3p_d)), colormap bluewhitered, axis equal, axis tight
%figure(404), pdeplot(p_rop_d, e_rop_d, t_rop_d, 'xydata', real(rop_d)), colormap bluewhitered, axis equal, axis tight

F_p0p_d_r = TriScatteredInterp(p_p0p_d(1,:)', p_p0p_d(2,:)', real(p0p_d));
F_p0p_d_i = TriScatteredInterp(p_p0p_d(1,:)', p_p0p_d(2,:)', imag(p0p_d));

F_u1p_d_r = TriScatteredInterp(p_u1p_d(1,:)', p_u1p_d(2,:)', real(u1p_d));
F_u1p_d_i = TriScatteredInterp(p_u1p_d(1,:)', p_u1p_d(2,:)', imag(u1p_d));

F_u2p_d_r = TriScatteredInterp(p_u2p_d(1,:)', p_u2p_d(2,:)', real(u2p_d));
F_u2p_d_i = TriScatteredInterp(p_u2p_d(1,:)', p_u2p_d(2,:)', imag(u2p_d));

F_u3p_d_r = TriScatteredInterp(p_u3p_d(1,:)', p_u3p_d(2,:)', real(u3p_d));
F_u3p_d_i = TriScatteredInterp(p_u3p_d(1,:)', p_u3p_d(2,:)', imag(u3p_d));

F_rop_d_r = TriScatteredInterp(p_rop_d(1,:)', p_rop_d(2,:)', real(rop_d));
F_rop_d_i = TriScatteredInterp(p_rop_d(1,:)', p_rop_d(2,:)', imag(rop_d));

p0p_d_r_xy = F_p0p_d_r(xxr, yyr);
p0p_d_i_xy = F_p0p_d_i(xxr, yyr);

u1p_d_r_xy = F_u1p_d_r(xxr, yyr);
u1p_d_i_xy = F_u1p_d_i(xxr, yyr);

u2p_d_r_xy = F_u2p_d_r(xxr, yyr);
u2p_d_i_xy = F_u2p_d_i(xxr, yyr);

u3p_d_r_xy = F_u3p_d_r(xxr, yyr);
u3p_d_i_xy = F_u3p_d_i(xxr, yyr);

rop_d_r_xy = F_rop_d_r(xxr, yyr);
rop_d_i_xy = F_rop_d_i(xxr, yyr);

       xxrD = [xxr; xxr];
       yyrD = [-flipud(yyr);yyr];
p0p_d_r_xyD = [flipud(p0p_d_r_xy); p0p_d_r_xy];
p0p_d_i_xyD = [flipud(p0p_d_i_xy); p0p_d_i_xy];
u1p_d_r_xyD = [flipud(u1p_d_r_xy); u1p_d_r_xy];
u1p_d_i_xyD = [flipud(u1p_d_i_xy); u1p_d_i_xy];
u2p_d_r_xyD = [flipud(u2p_d_r_xy); u2p_d_r_xy];
u2p_d_i_xyD = [flipud(u2p_d_i_xy); u2p_d_i_xy];
u3p_d_r_xyD = [flipud(u3p_d_r_xy); u3p_d_r_xy];
u3p_d_i_xyD = [flipud(u3p_d_i_xy); u3p_d_i_xy];
rop_d_r_xyD = [flipud(rop_d_r_xy); rop_d_r_xy];
rop_d_i_xyD = [flipud(rop_d_i_xy); rop_d_i_xy];

figure(410), pcolor(yyrD,xxrD,p0p_d_r_xyD), shading interp, colormap bluewhitered, colorbar
figure(411), pcolor(yyrD,xxrD,u1p_d_r_xyD), shading interp, colormap bluewhitered, colorbar
figure(412), pcolor(yyrD,xxrD,u2p_d_r_xyD), shading interp, colormap bluewhitered, colorbar
figure(413), pcolor(yyrD,xxrD,u3p_d_r_xyD), shading interp, colormap bluewhitered, colorbar
figure(414), pcolor(yyrD,xxrD,rop_d_r_xyD), shading interp, colormap bluewhitered, colorbar

