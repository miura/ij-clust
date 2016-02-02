srcname = getArgument();
//if (srcname = "") exit();
open(srcname);
destpath = "/home/miura/test/"; 

run("Add Noise");
//run("Enhance Contrast");
//run("Auto Threshold", "method=MaxEntropy white");
//saveAs("Tiff", destpath + File.separator + "blobprocessed.tif");
saveAs("Tiff", destpath + "blobprocessed.tif");

