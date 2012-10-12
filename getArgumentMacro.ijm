/*
ImageJ macro for comman line processing

description: processes image passed by argument (full path to the file)
and save the processed image in the same directory with name appended with mod.tif

Kota Miura (cmci.embl.de)
20101103
*/

imgfullpath = getArgument();
print(imgfullpath);
open(imgfullpath);
run("Gaussian Blur...", "sigma=10");
run("Invert");
run("Subtract Background...", "rolling=50");
savepath=imgfullpath+"mod.tif";
saveAs("Tiff", savepath);
print("Output saved: "+savepath);
//close();
