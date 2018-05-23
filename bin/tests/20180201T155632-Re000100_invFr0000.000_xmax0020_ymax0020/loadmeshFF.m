function [ffdata] = loadmeshFF(pth,ffdata,ISpatch)
%
% loadmeshFF.m
%
%

tic

n    = ffdata.n;
n0   = ffdata.n0;
nvar = ffdata.nvar;


% nb of coordinates
meshtri1 = load([pth,'connectivity.dat']);% - 1;
meshtri2 = load([pth,'connectivity-2.dat']);% - 1;
disp([num2str(length(meshtri1)) ' triangles in p1 mesh'])
disp([num2str(length(meshtri2)) ' triangles in p2 mesh'])
meshpts1 = load([pth,'coordinates.dat']);
meshpts2 = load([pth,'coordinates-2.dat']);

np1 = length(meshpts1(:,1));
np2 = length(meshpts2(:,1));
ffdata.np1 = np1;
ffdata.np2 = np2;


% determine variable types (e.g. P2/P2/P1)
vartype={};
for k=1:nvar
   if ( n0(k)==np1 )
       vartype = [vartype,{'p1'}];
       disp(['variable ' num2str(k) ': ' num2str(n(k)) ' DOFs, type: P1'])
   elseif ( n0(k)==np2 )
       vartype = [vartype,{'p2'}];
       disp(['variable ' num2str(k) ': ' num2str(n(k)) ' DOFs, type: P2'])
   else
       disp(['Error: variable ' num2str(k) ' neither P1 nor P2'])
       disp(['n0: ' num2str(n0(k)) ', np1:' num2str(np1) ', np2:' num2str(np2) ', n:' num2str(n(k))])
   end
end
ffdata.vartype = vartype;


% associate DOFs with mesh points
% xyp1 = [];
% xyp2 = [];
% for k=1:ffdata.np1
%     xyp1 = [xyp1; meshpts1(k,:)];
%     xyp2 = [xyp2; meshpts2(k,:)];
% end
xyp1 = meshpts1;
xyp2 = meshpts2;

flag00partofmeshp1 = 0;
for j=1:size(xyp1,1) % remove trailing zeros
    if all(xyp1(j,:)==[0 0])
        display('The origin (0,0) is part of the p1 mesh');
        flag00partofmeshp1 = 1;
    end
end

flag00partofmeshp2 = 0;
for j=1:size(xyp2,1) % remove trailing zeros
    if all(xyp2(j,:)==[0 0])
        display('The origin (0,0) is part of the p2 mesh');
        flag00partofmeshp2 = 1;
    end
end

varorder = {};
xydof = ffdata.xydof;
for k=1:nvar
   tmp = xydof(:,:,k);
   xyd = [];
   jlast = 0;
   flag00inxydandnotonlastline = 0;
   for j=2:(size(tmp,1)-1) % remove trailing zeros
       if all(tmp(j,:)==[0 0])
           if all(tmp(j+1,:)==[0 0])
               jlast = j-1;
               break
           else
               flag00inxydandnotonlastline = 1;
           end
       end
   end

    if (ISpatch == 1)
        if     strcmp(vartype{k},'p1') && (flag00partofmeshp1 == 1) && (flag00inxydandnotonlastline == 0)
            display('The origin (0,0) is on the last line of xyd');
            xyd = tmp(1:jlast+1,:);
        elseif strcmp(vartype{k},'p2') && (flag00partofmeshp2 == 1) && (flag00inxydandnotonlastline == 0)
            display('The origin (0,0) is on the last line of xyd');
            xyd = tmp(1:jlast+1,:);
        else
            xyd = tmp(1:jlast,:);
        end
    else
       xyd = tmp(1:jlast,:);
    end


   [dummy, indi] = sortrows(xyd,[1 2]);
   if       strcmp(vartype{k},'p1'), [dummy,indm] = sortrows(xyp1,[1 2]);
   elseif   strcmp(vartype{k},'p2'), [dummy,indm] = sortrows(xyp2,[1 2]);
   end
   [dummy,ii]   = sort(indi);
   iii      = ii(indm);
   [dummy,iiii] = sort(indi(iii));
   varorder = [varorder,{indi(iiii)}];
end
ffdata.varorder = varorder;

meshp1.meshpts = meshpts1;
meshp1.meshtri = meshtri1;
meshp2.meshpts = meshpts2;
meshp2.meshtri = meshtri2;
ffdata.meshp1 = meshp1;
ffdata.meshp2 = meshp2;

toc

end
