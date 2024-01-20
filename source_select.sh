export PREFIX="/home/groups/rwr/ixpenn/"

case $SOURCE in 

    gx301)
        export OBS='01002601'
        export SETNUM=$OBS
        export VERSION='02'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    gx301mom)
        export OBS='01002601'
        export SETNUM=$OBS
        export VERSION='02'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    4u)
        export OBS='02002302'
        export SETNUM=$OBS
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    gx99)
        export OBS='01002401'
        export SETNUM=$OBS
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    lmc)
        export OBS='02001901'
        export SETNUM=$OBS
        export ATTNUM='02'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    cirx1)
        export OBS='02002602'
        export VERSION='02'
        export SETNUM=$OBS
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    scox1)
        export OBS='02002401'
        export SETNUM=$OBS
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    sim)
        export OBS='sim'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab1)
        export OBS='01001010'
        export SETNUM='01001001'
        export VERSION='00'
        export ATTNUM='12'
        export PAYNUM1='09'
        export PAYNUM2='10'
        export PAYNUM3='08'
        ;;
    
    crab2)
        export OBS='01001020'
        export SETNUM='01001001'
        export VERSION='00'
        export ATTNUM='12'
        export PAYNUM1='09'
        export PAYNUM2='10'
        export PAYNUM3='08'
        ;;

    crab3)
        export OBS='01001030'
        export SETNUM='01001001'
        export VERSION='00'
        export ATTNUM='12'
        export PAYNUM1='09'
        export PAYNUM2='10'
        export PAYNUM3='08'
        ;;


    crab4)
        export OBS='01001040'
        export SETNUM='01001002'
        export VERSION='00'
        export ATTNUM='11'
        export PAYNUM1='08'
        export PAYNUM2='09'
        export PAYNUM3='07'
        ;;
    
    crab5)
        export OBS='01001050'
        export VERSION='00'
        export SETNUM='01001002'
        export ATTNUM='11'
        export PAYNUM1='08'
        export PAYNUM2='09'
        export PAYNUM3='07'
        ;;

    crab6)
        export OBS='01001060'
        export VERSION='00'
        export SETNUM='01001002'
        export ATTNUM='11'
        export PAYNUM1='08'
        export PAYNUM2='09'
        export PAYNUM3='07'
        ;;

    crab7)
        export OBS='02001010'
        export VERSION='00'
        export ATTNUM='01'
        export SETNUM='02001001'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab8)
        export OBS='02001020'
        export VERSION='00'
        export SETNUM='02001001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab9)
        export OBS='02001030'
        export SETNUM='02001001'
        export VERSION='00'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab10)
        export OBS='02001040'
        export VERSION='00'
        export SETNUM='02001001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab11)
        export OBS='02001050'
        export VERSION='00'
        export SETNUM='02001001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab12)
        export OBS='02001060'
        export VERSION='00'
        export SETNUM='02001001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab13)
        export OBS='02006010'
        export VERSION='00'
        export SETNUM='02006001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab14)
        export OBS='02006020'
        export VERSION='00'
        export SETNUM='02006001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;
    
    crab15)
        export OBS='02006030'
        export VERSION='00'
        export SETNUM='02006001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    *)
        echo "This source "$SOURCE" was not identified."
        ;;

esac


