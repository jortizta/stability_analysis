function wilfriedwritevectortofile(v, fileout)

fid = fopen(fileout, 'wt');
fprintf(fid, '%016.9e\n', v);
fclose(fid);

