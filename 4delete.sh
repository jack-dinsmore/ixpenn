#!/bin/bash

source source_select.sh
source $PREFIX"src/mlixpe.sh"
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

export DET='1'
source src/deleteione.sh

export DET='2'
source src/delete-one.sh

export DET='3'
source src/delete-one.sh
