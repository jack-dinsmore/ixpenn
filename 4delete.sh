#!/bin/bash

source source_select.sh
source $PREFIX"src/mlixpe.sh"
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

export DET='1'
source det_delete.sh

export DET='2'
source det_delete.sh

export DET='3'
source det_delete.sh
