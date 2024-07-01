#!/bin/bash

# Settings for all the IXPE sources and their file names

# 1. Choose a name YOUR_SOURCE_NAME and make a new block beginning with YOUR_SOURCE_NAME)
# 2. Fill out the following fields
#   - OBS: Observation ID of the .fits file within event_l1.
#   - SETNUM: the observation set ID (the name of the directory containing the auxil, hk, event_l1, etc. directories). Usually the same as $OBS unless you used split.sh to change $OBS, or if the observation came in multiple chunks.
#   - VERSION: the vXX version number of these event_l1 fits files. Zero if you used split.sh.
#   - ATTNUM: the version of the *_att_* files in the hk directory (usually 01)
#   - PAYNUM1: the version of the payload file for detector 1. The payload files begin with *_pay_132X_vYY*, where X is the detector number and YY is the version number.
#   - PAYNUM2 and PAYNUM3: the same for detectors 2 and 3.

# Make sure you end your code block in a double semicolon.

#export HEADAS=/home/groups/rwr/jtd/heasoft-6.32.1/x86_64-pc-linux-gnu-libc2.17
export HEADAS=/home/groups/rwr/jtd/heasoft-6.33.2/x86_64-pc-linux-gnu-libc2.17
export CALDB=/home/groups/rwr/jtd/caldb
export CC=/share/software/user/open/gcc/9.1.0/bin/gcc
export CXX=/share/software/user/open/gcc/9.1.0/bin/g++
export FC=/share/software/user/open/gcc/9.1.0/bin/gfortran
export PERL=/share/software/user/open/perl/5.26.0/bin/perl
export PYTHON=/share/software/user/open/python/3.9.0/bin/python3
unset CFLAGS CXXFLAGS FFLAGS LDFLAGS
export PREFIX="$PWD/"

case $SOURCE in 

    b05401)
	export OBS='02001201'
	export SETNUM='02001299'
        export VERSION1='03'
        export VERSION2='04'
        export VERSION3='02'
        export ATTNUM='03'
        export PAYNUM1='03'
        export PAYNUM2='03'
        export PAYNUM3='03'
        export PPGNUM='01'
        ;;

    b05402)
	export OBS='02001202'
        export SETNUM='02001299'
        export VERSION1='02'
        export VERSION2='03'
        export VERSION3='02'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    gcf1)
        export OBS='02007901'
        export SETNUM='02007999'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='02'
        ;;

    gcf2)
        export OBS='02007902'
        export SETNUM='02007999'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    gcf3)
        export OBS='02007903'
        export SETNUM='02007999'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='02'
        ;;

    gx301)
        export OBS='01002601'
        export SETNUM=$OBS
        export VERSION='02'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    gx301mom)
        export USE_MOM="use"
        export OBS='01002601'
        export SETNUM="m1002601"
        export VERSION='02'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    4u)
        export OBS='02002302'
        export SETNUM=$OBS
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    gx99)
        export OBS='01002401'
        export SETNUM=$OBS
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    lmc)
        export OBS='02001901'
        export SETNUM=$OBS
        export ATTNUM='02'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    cirx1)
        export OBS='02002602'
        export VERSION='02'
        export SETNUM=$OBS
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    scox1)
        export OBS='02002401'
        export SETNUM=$OBS
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    sim)
        export OBS='sim'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    crab1)
        export OBS='01001010'
        export SETNUM='01001001'
        export VERSION='00'
        export ATTNUM='12'
        export PAYNUM1='09'
        export PAYNUM2='10'
        export PAYNUM3='08'
        export PPGNUM='01'
        ;;
    
    crab2)
        export OBS='01001020'
        export SETNUM='01001001'
        export VERSION='00'
        export ATTNUM='12'
        export PAYNUM1='09'
        export PAYNUM2='10'
        export PAYNUM3='08'
        export PPGNUM='01'
        ;;

    crab3)
        export OBS='01001030'
        export SETNUM='01001001'
        export VERSION='00'
        export ATTNUM='12'
        export PAYNUM1='09'
        export PAYNUM2='10'
        export PAYNUM3='08'
        export PPGNUM='01'
        ;;


    crab4)
        export OBS='01001040'
        export SETNUM='01001002'
        export VERSION='00'
        export ATTNUM='11'
        export PAYNUM1='08'
        export PAYNUM2='09'
        export PAYNUM3='07'
        export PPGNUM='01'
        ;;
    
    crab5)
        export OBS='01001050'
        export VERSION='00'
        export SETNUM='01001002'
        export ATTNUM='11'
        export PAYNUM1='08'
        export PAYNUM2='09'
        export PAYNUM3='07'
        export PPGNUM='01'
        ;;

    crab6)
        export OBS='01001060'
        export VERSION='00'
        export SETNUM='01001002'
        export ATTNUM='11'
        export PAYNUM1='08'
        export PAYNUM2='09'
        export PAYNUM3='07'
        export PPGNUM='01'
        ;;

    crab7)
        export OBS='02001010'
        export VERSION='00'
        export ATTNUM='01'
        export SETNUM='02001001'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    crab8)
        export OBS='02001020'
        export VERSION='00'
        export SETNUM='02001001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    crab9)
        export OBS='02001030'
        export SETNUM='02001001'
        export VERSION='00'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    crab10)
        export OBS='02001040'
        export VERSION='00'
        export SETNUM='02001001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    crab11)
        export OBS='02001050'
        export VERSION='00'
        export SETNUM='02001001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    crab12)
        export OBS='02001060'
        export VERSION='00'
        export SETNUM='02001001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    crab13)
        export OBS='02006010'
        export VERSION='00'
        export SETNUM='02006001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    crab14)
        export OBS='02006020'
        export VERSION='00'
        export SETNUM='02006001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;
    
    crab15)
        export OBS='02006030'
        export VERSION='00'
        export SETNUM='02006001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        export PPGNUM='01'
        ;;

    *)
        echo "This source "$SOURCE" was not identified."
        ;;

esac


