#!/bin/sh
#
# *** Script for single image file procesing by ImageJ in cluster ***
#	using doIJ.sh, this script processes images using cluster. 
#		NOT FINISHED YET (use qdoIJ.sh instead)
#		should check if it really works 
#   two arguments for full paths to (2) an image file and (1) a macro file is required
#   assuming that macro file takes the fisrt argument as the macro file to be processed 
#	second argument to be the image file to be processed. Second argument 
#   Kota Miura (cmci.embl.de)
#   20101103
#   ****************************************************
#
macrofile=$1
imgfile=$2
#sh /g/almf/software/ij/doIJ.sh /g/almf/software/ij/getArgumentMacro.ijm /g/almf/miura/blobs.tif
sh /g/almf/software/ij/doIJ.sh ${macrofile} ${imgfile}
