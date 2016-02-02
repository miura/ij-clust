// more simplified, juts to check Meta data
// no check to access metadata.txt and folder for the output
// prints out information in the commandline

//bach command example
/*
/usr/struct/bin/java -cp /g/almf/software/ij/headless.jar:/g/almf/software/ij/ij-1.44h.jar -Djava.awt.headless=true ij.ImageJ -ijpath /g/almf/software/ij -batch /g/almf/software/ij/LifOpenerCUI.ijm /g/almf/miura/lif/laminedapi23012.lif
*/

//	srcfile = getArgument();		//cui
	srcfile = File.openDialog("Select a LIF File"); //gui	
	requires("1.43d");
	run("Bio-Formats Macro Extensions");

	path = srcfile;
	name = File.getName(path);
	dir = File.getParent(path);	
	DAPIch = 0;//getNumber("DAPI ch=?", 0);
	FISHch = 1;//getNumber("FISH ch=?", 1);

	q = File.separator; //090912
	workdir = File.getParent(srcfile);  //getDirectory("Choose a work space directory to save resulting files");


	Ext.setId(path);
	Ext.getSeriesCount(seriesCount);
	Ext.getCurrentFile(file);
	Ext.close();	
	print("File:"+ file);
	print("series total number" + seriesCount);

	for (s=0; s<seriesCount; s++) {

		seriesNum = s;

		IJ.log("series "+ s + " :ch1");
		seriesName = OpenLIFSeriesOneChannel(path, name, seriesNum, DAPIch, 0, metastr);	//modified 090925
		IJ.log("series "+ s + " :ch2");
		OpenLIFSeriesOneChannel(path, name, seriesNum, FISHch, 0, metastr);

	}


//working  maybe memory flashing problem, but not sure. 
/* 090907 
	090908
	- save tif file in a specified directory
	- problem with DAPI appearance in the resulting window.  ---> seperate 2D analysis files in other macro?
*/
function OpenLIFSeriesOneChannel(id, name, seriesNum, ch, datasetOpened, metastr){
	run("Bio-Formats Macro Extensions");

	//if (datasetOpened ==0) Ext.setId(id);
	Ext.setId(id);
	Ext.setSeries(seriesNum);
	Ext.getSeriesName(seriesName); print(seriesName);
	Ext.getSizeZ(sizeZ);
	Ext.getSizeC(sizeC);
	Ext.getSizeT(sizeT);
  Ext.getDimensionOrder(dimOrder)
	Ext.getImageCount(imageCount);
	print("ImageCount:"+imageCount);
	calculatedCount = sizeZ*sizeC*sizeT;
	print("...calculated"+sizeZ*sizeC*sizeT);
	if (imageCount != calculatedCount) {
		print();
		exit();
	}
  print(dimOrder);
	sizeT = imageCount/sizeC/sizeZ;
	print("C:"+sizeC+" Z:"+sizeZ+" T:"+sizeT);
	newname = name+"_"+seriesNum+"_ch"+ch+".tif";
	setBatchMode(true);
	for (j=0; j<sizeT; j++){		
		for (i=0; i<sizeZ; i++){
			currentZch0 = i*sizeC;
			currentPlane = j*sizeZ*sizeC + i*sizeC;
			print("\t\tt"+j+"_z"+i + "---"+ currentPlane+ch);
			// if ((i==0) && (j==0))
				// stackID=getImageID();
			// else	{
				// run("Copy");
				// close;
				// selectImage(stackID);
				// run("Add Slice");
				// run("Paste");
			//}
			//print(currentPlane);
		}
	}
/*	rename(newname);
	xscale = returnXscale(metastr);
	yscale = returnYscale(metastr);
	zscale = returnZscale(metastr);	
	tscale = 1;//returnTscale(metastr);		
	xscalemicron = parseFloat(xscale) * pow(10, 6);
	yscalemicron = parseFloat(yscale) * pow(10, 6);
	zscalemicron = parseFloat(zscale) * pow(10, 6);
	op = "channels=1 slices="+sizeZ+" frames="+sizeT+" unit=micron pixel_width="+xscalemicron +" pixel_height="+yscalemicron +" voxel_depth="+zscalemicron +" frame=[0 sec] origin=0,0";
	//since run("Properties...", op); cannot be used (AWT problem in headless)
	//follwoing is a new plugin for setting image properties. 
	// ImpProp.class
	SsizeC = ""+1;
	SsizeZ = ""+sizeZ;
	SsizeT = ""+sizeT;
	Sxscalemicron = ""+xscalemicron;
	Syscalemicron = ""+yscalemicron;
	Szscalemicron = ""+zscalemicron;			
	call("ImpProps.setCalibration", 
		SsizeC, SsizeZ, SsizeT, "micron", 
		Sxscalemicron, Syscalemicron, Szscalemicron);

	setBatchMode(false);
	//if (datasetOpened ==0) Ext.close();
	Ext.close();
*/	
	return seriesName;	
}

//zscale in micron
function returnZscale(metastr){
	metaA = split(metastr, "\n");
	zscale = 1;
	for (i=0; i<metaA.length; i++){
		if (startsWith(metaA[i], "HardwareSetting|ScannerSettingRecord|dblStepSize")){
			lineA = split(metaA[i], " ");
			//for (j=0; j<lineA.length; j++)print(lineA[j]);
			if (lineA.length>=3) {
				zscale = parseFloat(lineA[2]);
				print(zscale);
			}
		}
	}
	return zscale;		 
}

//Xscale in micron
function returnXscale(metastr){
	metaA = split(metastr, "\n");
	xscale = 1;
	for (i=0; i<metaA.length; i++){
		if (startsWith(metaA[i], "HardwareSetting|ScannerSettingRecord|dblVoxelX")){
			lineA = split(metaA[i], " ");
			//for (j=0; j<lineA.length; j++)print(lineA[j]);
			if (lineA.length>=3) { 
				xscale = parseFloat(lineA[2]);
				print(xscale);
			}
		}
	}
	return xscale;		 
}

function returnYscale(metastr){
	metaA = split(metastr, "\n");
	yscale = 1;
	for (i=0; i<metaA.length; i++){
		if (startsWith(metaA[i], "HardwareSetting|ScannerSettingRecord|dblVoxelY")){
			lineA = split(metaA[i], " ");
			//for (j=0; j<lineA.length; j++)print(lineA[j]);
			if (lineA.length>=3){
				yscale = parseFloat(lineA[2]);
				print(yscale);
			}
		}
	}
	return yscale;			 
}

function returnTscale(){
	metaA = split(metastr, "\n");
	for (i=0; i<metaA.length; i++){
	if (startsWith(metaA[i], "HardwareSetting|ScannerSettingRecord|dblStepSize")){
		lineA = split(metaA[i], " ");
		//for (j=0; j<lineA.length; j++)print(lineA[j]);
		if (lineA.length>=3) print(parseFloat(lineA[2]));
	}
	}		 
}
