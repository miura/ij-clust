#!/bin/sh
#script for single image file procesing by ImageJ 
#two arguments for full paths to (2) an image file and (1) a macro file is required
# assuming that macro file takes the fisrt argument as the macro and the second as the image file 
#Kota Miura (cmci.embl.de)
#20101103
echo "*** Single Image File Processing with ImageJ ***"
imgfile=$2
#if test -f ${imgfile}
if [ -e "${imgfile}" ]
then
	echo ${imgfile}" ...input image file"
else
	echo ${imgfile}" ...no such image file."
	exit 1
fi
macrofile=$1
#if test -f ${macrofile}
if [ -e "${macrofile}" ]
then
	echo ${macrofile}" ...macro to be used"
else
	echo ${macrofile}" ...no such macro file."
	exit 1
fi
# path to IJ jar file
IJJARS="/g/almf/software/ij"

#echo "IJ full-path ${IJJARS}/headless.jar"
echo "IJ full-path ${IJJARS}"

#timer
jobstart=$(date +%s)
#jobstartN=$(date +%N)
#/usr/struct/bin/java -cp ${IJJARS}/headless.jar:${IJJARS}/ij-1.44h.jar -Djava.awt.headless=true ij.ImageJ -batch ${macrofile} ${imgfile}
/usr/struct/bin/java -cp ${IJJARS}/headless.jar:${IJJARS}/ij-1.44h.jar -Djava.awt.headless=true ij.ImageJ -ijpath ${IJJARS} -batch ${macrofile} ${imgfile}
# timer
jobend=$(date +%s)
jobendN=$(date +%N)
echo "Time: $((jobend-jobstart)) secs."
echo "Time: $((jobendN-jobstartN)) nano-sec."
