cmapnames = {... %'BrBG', 'PIYG', 'PRGn', 'PuOr', 'RdBu', 'RdGy', 'RdYlBu', 'RdYlGn', 'Spectral', ...
             %'Accent', 'Dark2', 'Paired', 'Pastel1', 'Pastel2', 'Set1', 'Set2', 'Set3', ...
             'Blues', 'BuGn', 'BuPu', 'GnBu', 'Greens', 'Greys', 'OrRd', 'Oranges', 'PuBu', ...
             'PuBuGn', 'PuRd', 'Purples', 'RdPu', 'Reds', 'YlGn', 'YlGnBu', 'YlOrBr', 'YlOrRd' };

N = 16;

for n = 1:length(cmapnames)

    cmaplong = flipud(brewermap(floor(1.15*N), cmapnames{n}));

    cmap = cmaplong(1:N, :);

    cmaphsv = rgb2hsv(cmap);

    fid = fopen(['brewermaps.edp'], 'at');
    fprintf(fid, ['real[int] cmaphsv', cmapnames{n}, ' = [\n']);
    fprintf(fid, '%05.3f, %05.3f, %05.3f,\n', cmaphsv(1:end-1,:)');
    fprintf(fid, '%05.3f, %05.3f, %05.3f\n',  cmaphsv(end,    :)');
    fprintf(fid, '];\n\n');
    fclose(fid);

    clear cmaplong
    clear cmap

end

