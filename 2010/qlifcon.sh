#!/bin/sh
# qlifcon.sh is a CLUSTER version of lifcon.sh.
# script for converting Lif file to tif, and set physical scale. 
# no argument is taken. 
# 
# This script shuold be called as a script from qsub. 
# argument 'imgfullpath' is passed via -v option of 
# qsub.
#
# Author: Kota Miura (cmci.embl.de) 

# path to IJ jar file
IJJARS="/g/almf/software/ij"

if [ ! -e ${imgfullpath} ]
then
  echo ${imgfullpath}" ...file does not exists"
  exit 1
fi

# path to image 
IMGFILE="${imgfullpath##*/}"
IMGPATH="${imgfullpath%/*}"
METAFULLPATH="${imgfullpath}.meta.txt"
echo ${METAFULLPATH}

# Lif converting IJ macro name
IJMACRONAME="LifOpenerCUIijm"

#timer
jobstart=$(date +%s)
#jobstartN=$(date +%N)

sh /g/almf/software/bftools/showinf -nopix -nocore ${imgfullpath}>${METAFULLPATH}

chmod ugo+x ${METAFULLPATH}

/usr/struct/bin/java -Xmx4000m -cp ${IJJARS}/headless.jar:${IJJARS}/ij-1.44h.jar -Djava.awt.headless=true ij.ImageJ -ijpath ${IJJARS} -batch ${IJJARS}/LifOpenerCUI.ijm ${imgfullpath}

# timer
jobend=$(date +%s)
#jobendN=$(date +%N)
echo "Time: $((jobend-jobstart)) secs."
#echo "Time: $((jobendN-jobstartN)) nano-sec."
