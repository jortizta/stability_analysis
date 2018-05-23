import numpy as np
import re 
import os 

dirdat = "/Users/wil/Documents/Work/Projects/Stratified-Wakes/Stability/dat/tests/20180201T155632-Re000100_invFr0000.000_xmax0020_ymax0020/stab/"

vector = np.loadtxt(dirdat + "BCvec.dat")
idx    = np.nonzero(vector)[0] + 1

counter = 1 # This will give us the lines of file A to be substituted

print('Reading matrices ...')

with open(dirdat + 'HH.dat', 'r') as fH:
    linesofH = fH.readlines()

with open(dirdat + 'LNS.dat', 'r') as fA, open(dirdat + 'LNStemp.dat', 'w') as foutput:
    for line in fA:
        if counter <=4:
            foutput.write(line)
        if counter > 4:
            try:
                firstnumber = re.findall(r'\d+', line)[0]
                firstnumber = int(firstnumber)
                if firstnumber in idx:
#                    print counter
#                    print linesofH[counter-1]
                    foutput.write(linesofH[counter-1])
                else:
                    foutput.write(line)
            except:
                () # do nothing
        counter += 1

# Rename and remove to leave everything as if nothing had happened

os.remove(dirdat + 'LNS.dat');
os.rename(dirdat + 'LNStemp.dat', dirdat + 'LNS.dat');

print('Matrices operated ...')

