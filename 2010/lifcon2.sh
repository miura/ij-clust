#!/bin/sh
# script for converting Lif file to tif, and set physical scale. 
# takes single argument, full path to the lif file. 
# 2010.11.24 modified so that instead of imagej macro Lif opner, bfconvert is used. 
# ... but is still not usable since bfconvert does not automatically set scale.
imgfullpath=$1

# path to image 
IMGFILE="${imgfullpath##*/}"
IMGPATH="${imgfullpath%/*}"
OUTPATH="${imgfullpath}_tifStack"
echo ${OUTPATH}

if [ ! -d ${OUTPATH} ]
then
	mkdir ${OUTPATH}	
	echo "Output Directory Created"
fi
#echo "Output Directory..."${OUTPATH}
OUTFILE="${OUTPATH}/${IMGFILE}_%s_ch%c.tif"
echo "Output Files ... "${OUTFILE}
#arg2=$2
#if test -f ${arg2}
#then
#IJMACRONAME=${arg2}
#fi

#timer
jobstart=$(date +%s)
#jobstartN=$(date +%N)

/g/almf/software/bin2/bfconvert ${imgfullpath} ${OUTFILE} 


# timer
jobend=$(date +%s)
#jobendN=$(date +%N)
echo "Time: $((jobend-jobstart)) secs."
#echo "Time: $((jobendN-jobstartN)) nano-sec."
