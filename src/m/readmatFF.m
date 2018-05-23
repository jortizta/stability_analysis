function MAT = readmatFF(fullfilename,filetype)
%
% readmatFF.m
%
% Read FreeFem++ matrix from .mat or .dat file.
%
% inputs: fullfilename > full path (e.g. sthg like: fullfile(pathname,filename))
%         filetype     > 'mat' or 'dat'
%
%

% disp 'readmatFF'
tic;

%pwd0 = pwd;
%cd(fold1);

%format long;

switch filetype
    case 'mat'
        load([fullfilename '.mat']);

    case 'dat'
        %--- open file
        %disp(' '); disp(['read file ' filename]);
        fid = fopen([fullfilename '.dat']);

        %--- read header lines (matrix size, symmetry, nb of non-zero entries)
        nn    = textscan(fid,'%f',1,'HeaderLines',3);   nn       = nn{1};
        mm    = textscan(fid,'%f',1);                   mm       = mm{1};
        issym = textscan(fid,'%u',1);                   issymNSL = issym{1};
        ncoef = textscan(fid,'%f',1);                   ncoef    = ncoef{1};
        disp(['read ' num2str(ncoef) ' non-zero coeffs (among ' num2str(nn) 'x' num2str(mm) '=' num2str(nn*mm) ' DOFs...)'])
        if (issymNSL), disp('symmetric'), else disp('non-symmetric'), end

        %--- read data line by line
%         ii  = zeros(ncoef,1);
%         jj  = zeros(ncoef,1);
%         aij = zeros(ncoef,1);
%         for kk=1:ncoef
%             tmp = textscan(fid,'%d %d %c %f %c %f %c',1);
%             ii(kk)  = tmp{1};
%             jj(kk)  = tmp{2};
%             aij(kk) = tmp{4} + 1i*tmp{6};
%         end

        %CHANGED: read formatted data
        % to avoid memory problems, read and store in blocks of 1e6 lines
        % at a time
        MAT = spalloc(nn,mm,ncoef);
        ii  = zeros(ncoef,1);
        jj  = zeros(ncoef,1);
%       aij = zeros(ncoef,1);
        aij = complex(zeros(ncoef,1),zeros(ncoef,1));
        nblock = floor(ncoef/1e6);
        for iblock=1:nblock
            a=fscanf(fid,'%d %d (%e,%e)',[4 1000000]);
%           a=fscanf(fid,'%d %d %e',[3 1000000]);
            a=a.';
            ii((iblock-1)*1e6+1:iblock*1e6)=a(:,1);
            jj((iblock-1)*1e6+1:iblock*1e6)=a(:,2);
%           aij((iblock-1)*1e6+1:iblock*1e6)=a(:,3); % for m=0 real matrix
            aij((iblock-1)*1e6+1:iblock*1e6)=a(:,3)+1i*a(:,4);
        end
        clear a
        % read remaining lines
        a=fscanf(fid,'%d %d (%e,%e)',[4 inf]);
%       a=fscanf(fid,'%d %d %e',[3 inf]);
        a=a.';
        ii(nblock*1e6+1:ncoef)=a(:,1);
        jj(nblock*1e6+1:ncoef)=a(:,2);
%       aij(nblock*1e6+1:ncoef)=a(:,3);% for m=0 real matrix
        aij(nblock*1e6+1:ncoef)=a(:,3)+1i*a(:,4);
        clear a
        fclose(fid);
%       disp('ONLY VALID FOR M=0: all matrices considered real.');
%       disp(' For m>0, change commented imag parts in lines 54, 57, 62, 66 and 71 of readmatFF.m!');

        %--- build matrix
        MAT = sparse(ii,jj,aij,nn,mm);
        clear('aij','ii','jj');

        %--- save matrix
        save([fullfilename '.mat'], 'MAT');
 end

toc
