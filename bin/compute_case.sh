function compute_case
{
    printf -v STRRE    "%06d"   $RE
    printf -v STRINVFR "%08.3f" $INVFR
    printf -v STRXMAX  "%04d"   $XMAX
    printf -v STRYMAX  "%04d"   $YMAX
    #
    CAS='Re'$STRRE'_invFr'$STRINVFR'_xmax'$STRXMAX'_ymax'$STRYMAX$SUFFX
    DTHR=$(date +%Y%m%dT%H%M%S)
    #
    CURRDIR=$(pwd)
    cd ..
    WORKDIR=$(pwd)
    cd $CURRDIR
    echo 'The working directory is' $WORKDIR
    #

    echo '$GROUP:'$GROUP'$RE:'$RE
    echo 'The case directory is' $GROUP/$DTHR-$CAS
    mkdir -p $GROUP/$DTHR-$CAS
    #
    cp -R ../src/ff/*.edp $GROUP/$DTHR-$CAS
    cp -R ../src/ff/*.py  $GROUP/$DTHR-$CAS
    cp -R ../src/m/*.m    $GROUP/$DTHR-$CAS
    #
    cd $GROUP/$DTHR-$CAS
#    #
#    sed -i '' 's/^Re .*/Re = '$RE';/'          params.edp
#    sed -i '' 's/^invFr .*/invFr = '$INVFR';/' params.edp
#    #
#    sed -i '' 's/^xmax .*/xmax = '$XMAX';/' params.edp
#    sed -i '' 's/^ymax .*/ymax = '$YMAX';/' params.edp
#    #

    #
    sed -i 's/^Re .*/Re = '$RE';/'          params.edp
    sed -i 's/^invFr .*/invFr = '$INVFR';/' params.edp
    #
    sed -i 's/^xmax .*/xmax = '$XMAX';/' params.edp
    sed -i 's/^ymax .*/ymax = '$YMAX';/' params.edp
    #



# Original Wil paths

#    sed -i '' 's#^dirdat .*#dirdat = "/Users/wil/Documents/Work/Projects/Stratified-Wakes/Stability/dat/'$GROUP'/'$DTHR'-'$CAS'/";#' params.edp
#    sed -i '' 's#^dirsrc .*#dirsrc = "/Users/wil/Documents/Work/Projects/Stratified-Wakes/Stability/src/";#' params.edp
#    sed -i '' 's#^dirdat .*#dirdat = "/Users/wil/Documents/Work/Projects/Stratified-Wakes/Stability/dat/'$GROUP'/'$DTHR'-'$CAS'/stab/"#' operatematrices.py
#    sed -i '' 's#^pth = .*#pth = '"'"'/Users/wil/Documents/Work/Projects/Stratified-Wakes/Stability/dat/'$GROUP'/'$DTHR'-'$CAS'/'"'"';#' params.m
    


# Macbook paths

#    sed -i '' 's#^dirdat .*#dirdat = "/Users/Jose/Desktop/Stability/dat/'$GROUP'/'$DTHR'-'$CAS'/";#' params.edp
#    sed -i '' 's#^dirsrc .*#dirsrc = "/Users/Jose/Desktop/Stability/src/";#' params.edp
##    sed -i '' 's#^dirdat .*#dirdat = "/Users/wil/Documents/Work/Projects/Stratified-Wakes/Stability/dat/'$GROUP'/'$DTHR'-'$CAS'/stab/"#' operatematrices.py
#    sed -i '' 's#^pth = .*#pth = '"'"'/Users/Jose/Desktop/Stability/dat/'$GROUP'/'$DTHR'-'$CAS'/'"'"';#' params.m
 

# Boreas paths

   sed -i 's#^dirdat .*#dirdat = "/home/jose/Desktop/Stability/dat/'$GROUP'/'$DTHR'-'$CAS'/";#' params.edp
   sed -i 's#^dirsrc .*#dirsrc = "/home/jose/Desktop/Stability/src/";#' params.edp
##    sed -i '' 's#^dirdat .*#dirdat = "/Users/wil/Documents/Work/Projects/Stratified-Wakes/Stability/dat/'$GROUP'/'$DTHR'-'$CAS'/stab/"#' operatematrices.py
   sed -i 's#^pth = .*#pth = '"'"'/home/jose/Desktop/Stability/dat/'$GROUP'/'$DTHR'-'$CAS'/'"'"';#' params.m






# Testing with an environment variable, does not work

#    sed -i '' 's#^dirdat .*#dirdat = '$DIRWIL'/dat/'$GROUP'/'$DTHR'-'$CAS'/";#' params.edp
#    sed -i '' 's#^dirsrc .*#dirsrc = '$DIRWIL'/src/";#' params.edp
#    #
#    sed -i '' 's#^dirdat .*#dirdat = '$DIRWIL'/dat/'$GROUP'/'$DTHR'-'$CAS'/stab/"#' operatematrices.py
#    #
#    sed -i '' 's#^pth = .*#pth = '"'"''$DIRWIL'/dat/'$GROUP'/'$DTHR'-'$CAS'/'"'"';#' params.m
#    #

#    sed -i '' 's#^dirdat .*#dirdat = '$DIRJOSE_mb'/dat/'$GROUP'/'$DTHR'-'$CAS'/";#' params.edp
#    sed -i '' 's#^dirsrc .*#dirsrc = '$DIRJOSE_mb'/src/";#' params.edp
    #
#    #sed -i '' 's#^dirdat .*#dirdat = '$DIRJOSE_mb'/dat/'$GROUP'/'$DTHR'-'$CAS'/stab/"#' operatematrices.py
    
#    sed -i '' 's#^pth = .*#pth = '"'"''$DIRJOSE_mb'/dat/'$GROUP'/'$DTHR'-'$CAS'/'"'"';#' params.m
    #

#    sed -i '' 's#^dirdat .*#dirdat = '$DIRJOSE_ws'/dat/'$GROUP'/'$DTHR'-'$CAS'/";#' params.edp
#    sed -i '' 's#^dirsrc .*#dirsrc = '$DIRJOSE_ws'/src/";#' params.edp
#    #
#    #sed -i '' 's#^dirdat .*#dirdat = '$DIRJOSE_ws'/dat/'$GROUP'/'$DTHR'-'$CAS'/stab/"#' operatematrices.py
#    
#    sed -i '' 's#^pth = .*#pth = '"'"''$DIRJOSE_ws'/dat/'$GROUP'/'$DTHR'-'$CAS'/'"'"';#' params.m
# 

    echo 'Warning: Change the paths in ../src/ff/params.edp'





    echo $RE    >> Re.dat
    echo $INVFR >> invFr.dat
    echo $XMAX  >> xmax.dat
    echo $YMAX  >> ymax.dat
    #
    echo 'FreeFem++ Base flow'
    ff-mpirun -np 1 main_base.edp -glut ffglut 2>&1 | tee './_logffbase.txt'
    #
    echo 'FreeFem++ Modes'
    FreeFem++ main_stab.edp > './_logffstab.txt'
    #
    echo 'MATLAB Direct modes'
    sed -i 's/^analysistype = .*/analysistype = '"'"'spectrumdirect'"'"';/' params.m
#    matlabR2015b -nosplash -nodesktop -nodisplay -logfile './_logmstab.txt' -r "runstab;exit"

#    matlabR2014a -nosplash -nodesktop -nodisplay -logfile './_logmstab.txt' -r "runstab;exit"

    matlab -nosplash -nodesktop -nodisplay -logfile './_logmstab.txt' -r "runstab;exit"

    #
    cd ..
    cd ..
}



