srcdir = getArgument();
print("Plugins path:", call("ij.Menus.getPlugInsPath"));
//List.setCommands;
//list = List.getList;
//print(list);

//if (srcname = "") exit();
//filelistA = getFileList(srcdir);
destpath = srcdir + File.separator + "processed";
if (!File.isDirectory(destpath))
	File.makeDirectory(destpath);
//for (i = 0; i < filelistA.length; i++){
//	open(srcdir + File.separator + filelistA[i]);
	open(srcdir + File.separator + "C2_testfile.tif");	
	//run("PreProcess Chromosome Stack");
	run("Preprocess ChromosomeDots");
	//run("Image Inverter");
//	saveAs("Tiff", destpath + File.separator + "FFT"+filelistA[i]);
	saveAs("Tiff", destpath + File.separator + "FFT"+"C2processed.tif");
//	close();

