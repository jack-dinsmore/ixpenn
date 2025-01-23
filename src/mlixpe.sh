module purge
module load system
module load viz
module load gcc/12.1.0
module load py-numpy/1.24.2_py39
module load py-matplotlib/3.7.1_py39
module load py-scipy/1.10.1_py39
module load ncurses
module load x11
module load perl
module load readline/7.0
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

#export PATH="/share/software/user/open/readline/7.0/include/readline:"$PATH
# ./configure --x-includes /share/software/user/open/x11/7.7/include/
