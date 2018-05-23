#!/bin/bash
#
# Use current working directory
#$ -cwd
# Join stdout and stderr
#$ -j y
# Use bash shell
#$ -S /bin/bash



source ./compute_case.sh



GROUP='tests'
SUFFX=''
XMAX='20'
YMAX='20'

RE='100'
INVFR='0.00'
compute_case

