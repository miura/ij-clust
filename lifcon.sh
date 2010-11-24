#!/bin/sh
#script for converting Lif file to tif, and set physical scale. 
# takes single argument, full path to the lif file. 
imgfullpath=$1

# path to IJ jar file
IJJARS="/g/almf/software/ij"

# path to image 
IMGFILE="${imgfullpath##*/}"
IMGPATH="${imgfullpath%/*}"
METAFULLPATH="${imgfullpath}.meta.txt"
echo ${METAFULLPATH}
# Lif converting IJ macro name
IJMACRONAME="LifOpenerCUIijm"

#arg2=$2
#if test -f ${arg2}
#then
#IJMACRONAME=${arg2}
#fi

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
