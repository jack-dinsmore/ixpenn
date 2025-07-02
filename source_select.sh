#!/bin/bash

# Settings for all the IXPE sources and their file names

# 1. Choose a name YOUR_SOURCE_NAME and make a new block beginning with YOUR_SOURCE_NAME)
# 2. Fill out the following fields
#   - OBS: Observation ID of the .fits file within event_l1.
#   - SETNUM: the observation set ID (the name of the directory containing the auxil, hk, event_l1, etc. directories). Usually the same as $OBS unless you used split.sh to change $OBS, or if the observation came in multiple chunks.
#   - VERSION: the vXX version number of these event_l1 fits files. Zero if you used split.sh.
#   - ATTNUM: the version of the *_att_* files in the hk directory (usually 01). If the different detectors have different attitude numbers, you can instead use ATTNUM1, ATTNUM2, and ATTNUM3 to set different numbers for detectors 1, 2, and 3. Do not use both ATTNUM and the numbered ATTNUM# variables.
#   - PAYNUM: the version of the payload file. Again, PAYNUM1, 2, and 3 are available if the versions differ between detectors. The payload files begin with *_pay_132X_vYY*, where X is the detector
#   - PAYNUM2 and PAYNUM3: the same for detectors 2 and 3.

# Make sure you end your code block in a double semicolon.

#export HEADAS=/home/groups/rwr/jtd/heasoft-6.34/x86_64-pc-linux-gnu-libc2.17
export HEADAS=/home/groups/rwr/jtd/heasoft-6.35.2/x86_64-pc-linux-gnu-libc2.17
export CALDB=/home/groups/rwr/jtd/caldb
export CC=/share/software/user/open/gcc/9.1.0/bin/gcc
export CXX=/share/software/user/open/gcc/9.1.0/bin/g++
export FC=/share/software/user/open/gcc/9.1.0/bin/gfortran
export PERL=/share/software/user/open/perl/5.26.0/bin/perl
export PYTHON=/share/software/user/open/python/3.9.0/bin/python3
unset CFLAGS CXXFLAGS FFLAGS LDFLAGS CHUNK
export PREFIX="$PWD/"

case $SOURCE in
    lh)
        export OBS="04001301"
        export SETNUM=$OBS
        export VERSION="02"
        export ATTNUM="02"
        export PAYNUM="02"
        export ADCNUM="02"
        export SRC_RA=165.4424525
        export SRC_DEC=-61.0200908
        ;;
    mrk4211)
        export OBS="01003701"
        export SETNUM=$OBS
        export VERSION="03"
        export ATTNUM="02"
        export PAYNUM="01"
        export ADCNUM="01"
        export SRC_RA=166.1137500
        export SRC_DEC=38.2088889
        ;;
    mrk4212)
        export OBS="01003801"
        export SETNUM=$OBS
        export VERSION="01"
        export ATTNUM="02"
        export PAYNUM="01"
        export ADCNUM="01"
        export SRC_RA=166.1137500
        export SRC_DEC=38.2088889
        ;;
    mrk4213)
        export OBS="01003901"
        export SETNUM=$OBS
        export VERSION="01"
        export ATTNUM="04"
        export PAYNUM="01"
        export ADCNUM="01"
        export SRC_RA=166.1137500
        export SRC_DEC=38.2088889
        ;;
    kes75)
        export OBS='03001901'
        export SETNUM=$OBS
        export VERSION="02"
        export ATTNUM="02"
        export PAYNUM="02"
        export PPGNUM="02"
        export ADCNUM="02"
        export SRC_RA=281.6037500
        export SRC_DEC=-2.9750000
        ;;
    grb)
        export OBS='02250101'
        export SETNUM=$OBS
        export VERSION1="03"
        export VERSION2="02"
        export VERSION3="02"
        export ATTNUM1="11"
        export ATTNUM2="12"
        export ATTNUM3="11"
        export PAYNUM="08"
        export PPGNUM="01"
        export ADCNUM="09"
        export SRC_RA=288.2645833
        export SRC_DEC=19.7736111
        ;;
    andrew1)
        export OBS='03006701'
	    export SETNUM='03006799'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='02'
        export SRC_RA=260.8466667
        export SRC_DEC=-28.6325000
        ;;

    andrew2)
        export OBS='03006702'
	    export SETNUM='03006799'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='02'
        export SRC_RA=260.8466667
        export SRC_DEC=-28.6325000
        ;;

    andrew3)
        export OBS='03006703'
	    export SETNUM='03006799'
        export VERSION='01'
        export ATTNUM='02'
        export PAYNUM='01'
        export PPGNUM='01'
        export SRC_RA=260.8466667
        export SRC_DEC=-28.6325000
        ;;

    pks2155)
        export OBS='02005601'
	    export SETNUM='02005601'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='01'
        export SRC_RA=329.7170833
        export SRC_DEC=-30.2255556
        ;;

    1rxsJ17081)
        export OBS='01003101'
	    export SETNUM='01003199'
        export VERSION='02'
        export ATTNUM='03'
        export PAYNUM='03'
        export PPGNUM='03'
        export ADCNUM='03'
        export SRC_RA=257.1954167
        export SRC_DEC=-40.1477778
        ;;

    1rxsJ17082)
        export OBS='01003102'
	    export SETNUM='01003199'
        export VERSION='03'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='02'
        export SRC_RA=257.1954167
        export SRC_DEC=-40.1477778
        ;;

    1rxsJ17083)
        export OBS='01003103'
	    export SETNUM='01003199'
        export VERSION='02'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='02'
        export SRC_RA=257.1954167
        export SRC_DEC=-40.1477778
        ;;

    b05401)
    	export OBS='02001201'
	    export SETNUM='02001299'
        export VERSION1='03'
        export VERSION2='04'
        export VERSION3='02'
        export ATTNUM='03'
        export PAYNUM='03'
        export PPGNUM='01'
        export ADCNUM='03'
        export SRC_RA=85.0450000
        export SRC_DEC=-69.3316667
        ;;

    b05402)
	export OBS='02001202'
        export SETNUM='02001299'
        export VERSION1='02'
        export VERSION2='03'
        export VERSION3='02'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='01'
        export SRC_RA=85.0450000
        export SRC_DEC=-69.3316667
        ;;
	
    b05403)
	export OBS='02008801'
        export SETNUM='02008801'
        export VERSION1='01'
        export VERSION2='01'
        export VERSION3='01'
        export ATTNUM='03'
        export PAYNUM='02'
        export PPGNUM='03'
        export ADCNUM='02'
        export SRC_RA=85.0450000
        export SRC_DEC=-69.3316667
        ;;

    gcf1)
        export OBS='02007901'
        export SETNUM='02007999'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='02'
        export SRC_RA=266.5700000
        export SRC_DEC=-28.8900000
        ;;

    gcf2)
        export OBS='02007902'
        export SETNUM='02007999'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='01'
        export SRC_RA=266.5700000
        export SRC_DEC=-28.8900000
        ;;

    gcf3)
        export OBS='02007903'
        export SETNUM='02007999'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='02'
        export SRC_RA=266.5700000
        export SRC_DEC=-28.8900000
        ;;

    gcf4)
        export OBS='01003401'
        export SETNUM='01003499'
        export VERSION1='06'
        export VERSION2='04'
        export VERSION3='05'
        export ATTNUM1='15'
        export ATTNUM2='14'
        export ATTNUM3='14'
        export ADCNUM='04'
        export PAYNUM1='04'
        export PAYNUM2='03'
        export PAYNUM3='03'
        export PPGNUM='01'
        export SRC_RA=266.5700000
        export SRC_DEC=-28.8900000
        ;;

    gcf5)
        export CHUNK='01003412'
        export OBS='01003402'
        export SETNUM='01003499'
        export VERSION1='05'
        export VERSION2='04'
        export VERSION3='04'
        export ATTNUM1='15'
        export ATTNUM2='15'
        export ATTNUM3='14'
        export ADCNUM='04'
        export PAYNUM1='04'
        export PAYNUM2='03'
        export PAYNUM3='03'
        export PPGNUM='01'
        export SRC_RA=266.5700000
        export SRC_DEC=-28.8900000
        ;;

    gcf6)
        export CHUNK='01003422'
        export OBS='01003402'
        export SETNUM='01003499'
        export VERSION1='05'
        export VERSION2='04'
        export VERSION3='04'
        export ATTNUM1='15'
        export ATTNUM2='15'
        export ATTNUM3='14'
        export ADCNUM='04'
        export PAYNUM1='04'
        export PAYNUM2='03'
        export PAYNUM3='03'
        export PPGNUM='01'
        export SRC_RA=266.5700000
        export SRC_DEC=-28.8900000
        ;;

    gx301)
        export OBS='01002601'
        export SETNUM=$OBS
        export VERSION='02'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='01'
        export SRC_RA=186.6566667
        export SRC_DEC=-62.7702778
        ;;

    4u1)
        export OBS='02002301'
        export SETNUM='02002399'
        export VERSION='02'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='02'
        export SRC_RA=275.9191667
        export SRC_DEC=-30.3611111
        ;;

    4u)
        export OBS='02002302'
        export SETNUM='02002399'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='01'
        export SRC_RA=275.9191667
        export SRC_DEC=-30.3611111
        ;;


    gx99)
        export OBS='01002401'
        export SETNUM=$OBS
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='01'
        export SRC_RA=262.9341667
        export SRC_DEC=-16.9613889
        ;;

    lmc)
        export OBS='02001901'
        export SETNUM=$OBS
        export VERSION='02'
        export ATTNUM='02'
        export PAYNUM='01'
        export PPGNUM='01'
        export SRC_RA=84.9116667
        export SRC_DEC=-69.7433333
        ;;

    cirx1)
        export OBS='02002602'
        export SETNUM='02002699'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='01'
        export SRC_RA=230.1700000
        export SRC_DEC=-57.1669444
        ;;

    scox1)
        export OBS='02002401'
        export SETNUM=$OBS
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='01'
        export SRC_RA=244.9791667
        export SRC_DEC=-15.6400000
        ;;

    sim)
        export OBS='_pd1_spec2_ang0'
        export SETNUM='sim'
        export VERSION='01'
        #export ATTNUM='01'
        #export PAYNUM='01'
        #export PPGNUM='01'
        ;;

    crab1)
        export CHUNK='02006010'
        export OBS='02006001'
        export SETNUM=$OBS
        export VERSION='02'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='01'
        export SRC_RA=83.6331250
        export SRC_DEC=22.0145000
        ;;
    
    crab2)
        export CHUNK='02006020'
        export OBS='02006001'
        export SETNUM=$OBS
        export VERSION='02'
        export ATTNUM='01'
        export PAYNUM='01'
        export PPGNUM='01'
        export SRC_RA=83.6331250
        export SRC_DEC=22.0145000
        ;;

    *)
        echo "This source "$SOURCE" was not identified."
        ;;

esac

if [ -z "$ADCNUM" ]; then
    export ADCNUM='01'
fi

if [ -z "$CHUNK" ]; then
    export CHUNK=$OBS
fi
