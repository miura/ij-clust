var var_headless =	"HEADLESS=\"\/home\/miura\/test\/headless.jar\"\n";
var var_ijjar =		"IJ_JAR=\"\/home\/miura\/test\/ij-1.44h.jar\"\n";
var var_ijpath = 	"IJ_PATH=\"\/home\/miura\/test\"\n";
var var_batchfile =	"BATCH_FILE=\"\/home\/miura\/test\/headlesstest2.ijm\"\n";
//var var_batcharg =	"BATCH_ARG=\"\/home\/miura\/test\"\n";
var var_batcharg =	"BATCH_ARG=";

var vars = var_headless
	+ var_ijjar
	+ var_ijpath
	+ var_batchfile
	+ var_batcharg;
var jobfilePrefix = "job_";
	
arg = getArgument();
argA = split(arg, ":");
srcdir = argA[0];
destdir = argA[1];
argjobprefix = argA[2];
if (lengthOf(argjobprefix)>2){
	jobfilePrefix = argjobprefix;
}

vars += "\"" + srcdir + File.separator;
print("input: " + srcdir);
print("output: " + destdir);

if (!File.isDirectory(srcdir)) {
	print("Abort: source directory does not exist!");
	exit();
}
if (!File.isDirectory(destdir)) {
	File.makeDirectory(destdir);
}
filesA = getFileList(srcdir);
jobfilename = "job_";
for (i = 0; i< filesA.length; i++){
	jobfilename = generateJobScript(filesA[i], i, destdir);
}

jobarraystring = "#!/bin/sh\n"
		+ "\n"
		+ "#PBS -J 1-" + filesA.length + "\n"
		+ "#PBS -q clusterng\n"
		+ destdir+  File.separator 
		+ jobfilePrefix + "$PBS_ARRAY_INDEX.sh";
		
jobarrayfile_fullpath = destdir + File.separator + "jobarray.sh";

File.saveString(jobarraystring, jobarrayfile_fullpath);

function generateJobScript(filename, number, destdir){
	header = "#!/bin/sh\n#PBS -N TestPBS\n#PBS -l walltime=1:00:00\n";
	varslocal = vars +  filename + "\"";
	//print(varslocal);

	command = "\/usr\/struct\/bin\/java "
		+ "-cp $HEADLESS:$IJ_JAR -Djava.awt.headless=true "
		+ "ij.ImageJ -ijpath $IJ_PATH -batch $BATCH_FILE $BATCH_ARG";
	job = header + "\n\n" + varslocal + "\n" + command + "\n";
	print(job);
	jobname = jobfilePrefix+ (number+1) + ".sh";
	fullpath = destdir + File.separator + jobname;
	File.saveString(job, fullpath);
	return 	 ("job_" + filename);
}




//if (srcname = "") exit();
//filelistA = getFileList(srcdir);
//destpath = srcdir + File.separator + "processed"; 
//for (i = 0; i < filelistA.length; i++){
//	open(srcdir + File.separator + filelistA[i]);
//	open(srcdir + File.separator + "C2_testfile.tif");	
//	run("PreProcess Chromosome Stack");
//	saveAs("Tiff", destpath + File.separator + "FFT"+filelistA[i]);
//	saveAs("Tiff", destpath + File.separator + "FFT"+"C2-emm12z100on190810.lif - Pos003_S003cc.tif");
//	close();
//}


