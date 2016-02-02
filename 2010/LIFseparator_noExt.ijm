/*
Split LIF file and save each channel as a tif stack. 
20101020 Kota Miura
*/

srcfile = getArgument();	//for use with CUI
//fullp = File.openDialog(""); //to be replaced with argument in the headless mode
srcdir = File.getParent(srcfile);
srcfoldername = File.getName(srcdir);
srcdirpar = File.getParent(srcdir);
outdir = "" + srcdirpar + File.separator + srcfoldername + "_split";
print("input file:" + srcfile);
print("output dir:" + outdir);
setBatchMode(true);
sp = File.separator;
opopen = "open="+fullp+" open="+fullp+" color_mode=Default open_files view=[Standard ImageJ] stack_order=Default use_virtual_stack series_1";
run("Bio-Formats Importer", opopen);
print("opened");
getDimensions(width, height, channels, slices, frames);
orgname= File.name;
orgtitle = getTitle();
ophyp = "order=xyczt(default) channels="+channels+" slices="+slices+" frames="+frames+" display=Grayscale";
run("Stack to Hyperstack...", ophyp);
run("Split Channels");
for (i=0; i<channels; i++){
	chst = "C"+i+1 + "-";	
	selectWindow(chst+orgtitle);
//saveAs("Tiff", "["+outdir+sp+"C1-"+orgtitle+"]");
	saveAs("Tiff", outdir+sp+chst+orgname + ".tif");
	close;
}


