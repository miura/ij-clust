/* for listing parameters associated with LIF file
2010.10.26

Kota Miura (miura@embl.de
*/
srcfile = getArgument();
	run("Bio-Formats Macro Extensions");
	id = srcfile;//File.openDialog("Choose a file");
	Ext.setId(id);
	Ext.getSeriesCount(seriesCount);
	Ext.getCurrentFile(file);
	print("File:"+ file);
	print("series number" + seriesCount);
	print("****************** ");

	for (s=0; s<seriesCount; s++) {
	  Ext.setSeries(s);
	Ext.getSeriesName(seriesName);
	Ext.getImageCount(n);
	Ext.getDimensionOrder(dimOrder);
	  Ext.getSizeX(sizeX);
	  Ext.getSizeY(sizeY);
	  Ext.getSizeZ(sizeZ);
	  Ext.getSizeC(sizeC);
	  Ext.getSizeT(sizeT);	
/* parts to be tested for getting metadata
*/
//	XscaleKey = seriesName+ "- Sequential Setting 2 - dblVoxelX - Voxel-Width";
//	YscaleKey = seriesName+ " - Sequential Setting 2 - dblVoxelY - Voxel-Height";
//	ZscaleKey = seriesName+ " - Sequential Setting 2 - dblVoxelZ - Voxel-Depth";

	XscaleKey = "HardwareSetting|ScannerSettingRecord|dblVoxelX 1";
	YscaleKey = "HardwareSetting|ScannerSettingRecord|dblVoxelY 1";
	ZscaleKey = "HardwareSetting|ScannerSettingRecord|dblVoxelZ 1";

	testkey = "Instrument ID";
	Ext.getMetadataValue(testkey, testval);
	print("TESTVAL = " + testval);
	
	Ext.getMetadataValue(XscaleKey, xscale);
	Ext.getMetadataValue(YscaleKey, yscale);
	Ext.getMetadataValue(ZscaleKey, zscale);

	print(seriesName);
	print("Series #" + s + ": image resolution is " + sizeX + " x " + sizeY);
	print("image number "+n);
	print(dimOrder);
	print("Focal plane count = " + sizeZ);
	print("Channel count = " + sizeC);
	print("Time point count = " + sizeT);
	
	print("X pixel width = " +xscale);
	print("Y pixel width = " +yscale);
	print("Z pixel width = " +zscale);
	}
	Ext.close();
