#!/bin/sh
#script for imageJ cluster calculation
#clust5 argument must be the name of a directory in current pwd. 
# (not the full path)

imgdir=$1
if test -d ${imgdir}
then
	echo ${imgdir}" ...input directory"
else
	echo ${imgdir}" ...no such directory."
	exit 1
fi
outdir=${imgdir}"_proc"
if test -d ${outdir}
then
	echo ${outdir}" ...output directory"
else
	mkdir ${outdir}
	echo ${outdir}" ...output directory created"
fi
jobdir=${imgdir}"_jobs"
if test -d ${jobdir}
then
	echo ${jobdir}" ...job scripts dir"
else
	mkdir ${jobdir}
	echo ${jobdir}" ...job scripts directory created"
fi

curdir=`pwd`

# path to IJ jar file
IJJARS="/g/almf/miura/pub"

# path to images and stacks
#SRCPATH="/home/miura/test/testsrc"
#SRCPATH="/g/almf/miura/testsmalls"
SRCPATH=${curdir}"/"${imgdir}

#path to output directory
OUTPATH=${curdir}"/"${outdir}

# path to job array generator macro
#JOBGENPATH="/home/miura/test/ij"
JOBGENPATH="/g/almf/miura/pub"

# name of job array generator
JOBGENNAME="JCreate3.ijm"

# path to save job scripts and job array script
#JOBPATH="/home/miura/test/job3"
JOBPATH=${curdir}"/"${jobdir}

# base name (prefix) of job script generated for each images/stacks
JOBPREF="job_"${imgdir}

# path to image processing IJ macro
#IJMACROPATH="/home/miura/test/ij"
IJMACROPATH="/g/almf/miura/pub"

# image processing IJ macro name
IJMACRONAME="headlesstest3.ijm"

echo "IJ full-path ${IJJARS}/headless.jar"

#timer
jobstart=$(date +%s)
#jobstartN=$(date +%N)

macroarg=${SRCPATH}:${OUTPATH}:${JOBPATH}:${JOBPREF}:${IJJARS}:${IJMACROPATH}:${IJMACRONAME}
echo ${macroarg}

/usr/struct/bin/java -cp ${IJJARS}/headless.jar:${IJJARS}/ij-1.44h.jar -Djava.awt.headless=true ij.ImageJ -batch ${JOBGENPATH}/${JOBGENNAME} ${macroarg}

chmod +x ${JOBPATH}/${JOBPREF}*

qsub ${JOBPATH}/jobarray.sh

# timer
jobend=$(date +%s)
#jobendN=$(date +%N)
echo "Time: $((jobend-jobstart)) secs."
#echo "Time: $((jobendN-jobstartN)) nano-sec."

