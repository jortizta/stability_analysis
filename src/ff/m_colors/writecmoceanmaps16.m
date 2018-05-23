cmapnames = { 'balance', 'delta', 'curl', 'phase', 'thermal', 'haline', 'solar', 'ice', ...
'gray', 'oxy', 'deep', 'dense', 'algae', 'matter', 'turbid', 'speed', 'amp', 'tempo'};

N = 16;

for n = 1:length(cmapnames)

    cmaplong = flipud(cmocean(cmapnames{n},N));

    cmap = cmaplong(1:N, :);

    cmaphsv = rgb2hsv(cmap);

    fid = fopen(['cmoceanmaps.edp'], 'at');
    fprintf(fid, ['real[int] cmaphsv', cmapnames{n}, ' = [\n']);
    fprintf(fid, '%05.3f, %05.3f, %05.3f,\n', cmaphsv(1:end-1,:)');
    fprintf(fid, '%05.3f, %05.3f, %05.3f\n',  cmaphsv(end,    :)');
    fprintf(fid, '];\n\n');
    fclose(fid);

    clear cmaplong
    clear cmap

end

