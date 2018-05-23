function wilfriedwritematrixtofile(M, fileout)

dlmwrite(fileout, M, 'delimiter', ' ', 'precision', '%016.9e');

