#!/bin/bash
#
# Use current working directory
#$ -cwd
# Join stdout and stderr
#$ -j y
# Use bash shell
#$ -S /bin/bash



source ./compute_case.sh

GROUP='test_kmax'
SUFFX=''
XMAX='5'
YMAX='5'

RE='10000'
INVFR='1'



DIRWIL='/Users/wil/Documents/Work/Projects/Stratified-Wakes/Stability/'
DIRJOSE_ws='/home/jose/Desktop/Stability/'
DIRJOSE_mb='/Users/Jose/Desktop/Stability/'

compute_case

#sh compute_case.sh
