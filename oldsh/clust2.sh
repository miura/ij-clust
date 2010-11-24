#!/bin/sh
#script for imageJ cluster calculation

# path to IJ jar file
IJJARS="/home/miura/test/ij"

# path to images and stacks
SRCPATH="/home/miura/test/testsrc"

# path to job array generator macro
JOBGENPATH="/home/miura/test/ij"

# name of job array generator
JOBGENNAME="JCreate2.ijm"

# path to save job scripts and job array script
JOBPATH="/home/miura/test/testdest"

# base name (prefix) of job script generated for each images/stacks
JOBPREF="jobbb"

# path to image processing IJ macro
IJMACROPATH="/home/miura/test/ij"

# image processing IJ macro name
IJMACRONAME="headlesstest3.ijm"

echo "IJ full-path ${IJJARS}/headless.jar"

#timer
jobstart=$(date +%s)
#jobstartN=$(date +%N)

macroarg=${SRCPATH}:${JOBPATH}:${JOBPREF}
echo ${macroarg}

/usr/struct/bin/java -cp ${IJJARS}/headless.jar:${IJJARS}/ij-1.44h.jar -Djava.awt.headless=true ij.ImageJ -batch ${JOBGENPATH}/${JOBGENNAME} ${macroarg}

#chmod +x ${JOBPATH}/${JOBPREF}*

#qsub ${JOBPATH}/jobarray.sh

# timer
jobend=$(date +%s)
#jobendN=$(date +%N)
echo "Time: $((jobend-jobstart)) secs."
#echo "Time: $((jobendN-jobstartN)) nano-sec."

