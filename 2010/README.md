#Shell Scripts and ImageJ macro for headless-processing 
Kota Miura (cmci.embl.de)

##doFJ.sh
20120208

The script takes two argments, script file path and image file / directory path.
It might not work well with ImageJ macro (not tested), but with javascript most likely OK. In any case, avoid dialog window or image show() in the script.

example:

processing a image file
```sh
./doFJ /g/cmci/myscript.py /g/cmci/my/image.tif
```
processing image files in a directrory
```sh
./doFJ /g/cmci/myscript.py /g/cmci/my   
```##qsubFJ.sh
20120208

For submitting above command to the cluster via command qsub. If you need to use large memory, header lines should be adjusted. 

  * processing a image file
```sh
./qsubFJ /g/cmci/myscript.py /g/cmci/my/image.tif
```
  * processing image files in a directrory
```sh
./qsubFJ /g/cmci/myscript.py /g/cmci/my   
```
##BioformatOpenTest.ijm

test accessing LIF file. 
wrote for checking the loci_tools.jar
open an arbiturary plane and closes. 


##LifOpenerCUI_simple.ijm

Access LIF file using loci_tools.jar and prints out information for each stack, each plane.  


##LifOpenerCUI_meta.ijm

a bit more complex version than LifOpenerCUI_simple.ijm. Check the access to meta.txt data produced by showinf tool. Also creates output folder .tifStack. 

##doIJ.sh

script for single image file procesing by ImageJ 
two arguments for full paths to (2) an image file and (1) a macro file is required
assuming that macro file takes the fisrt argument as the macro and the second as the image file 

usage:
   sh doIJ <macrofile> <LIF file>
e.g.
```shell
 sh doIJ /g/almf/software/ij/LifOpenerCUI_meta.ijm /g/haering/Pombescreen/pb2/100927ExpNo2.lif > log_ver20100902_meta.txt
```
 
 
##lifcon.sh

shell script for converting Lif file to tif, and set physical scale. 
Uses showinf of "bftools" and IamgeJ loci_tools.jar. 
takes single argument, full path to the lif file. 

Usage:
e.g.
```shell 
sh /g/almf/software/ij/lifcon.sh /g/haering/Pombescreen/test.lif
```

###lifcon2.sh (not working yet) ===
bfconvert-only version but still not working. 

##qlifcon.sh
same as lifcon.sh but only usable from qsub. argument is passed to qlifcon.sh
by -v option of qsub (image file full path). 
This script is called by lifcovert

##lifconvert
bash script for running lif conversion in cluster. 
takes a single argument (full path to image file)

##clust5fullp.sh

for processing all files in a directory (passed as the argument). It creates jobfiles for each image file (using imageJ macro JCreate3.ijm), and the job is thrown to the cluster as a job array.


Useage:
e.g.
```shell
sh /g/almf/softwae/ij/clust5fullp.sh /g/haering/Pombescreen/test.lif_tifStack headlesstest3.ijm
```

##JCreate3.ijm

called from clust5fullp.sh to create job files for each image in the assigned directory. 

##headlesstest3.ijm

main part of the macro for preprocessing Bory's image stacks (for analysis with dot tracker). Job files created by JCreate3.ijm calls this macro. (clust5fullp.sh -> JCreate3.ijm -> headlesstest3.ijm)












