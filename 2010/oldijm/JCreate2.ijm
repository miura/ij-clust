/* ImageJ macro for generating shell scripts to be used by qsub array
	Kota miura (miura@embl.de) 2010

	...better be written as a shell script in future. 

 to use this macro, adjust path variables BASEP, IJMACROFILE, IJP, SUN_JAVA
 you might probably need to change the name of imageJ jar file of var_ijjar

 requres three arguments separated by colon. 
 arg[0]: path to the folder cotaining images to be processed
 arg[1]: path to the folder where scripts will be saved
 arg[2]: prefix of job shell scrips. should be longer than 2 chars 

 Example command for execution
 /usr/struct/bin/java -cp headless.jar:ij-1.44h.jar -Djava.awt.headless=true ij.ImageJ -batch JCreate.ijm /home/miura/test/testsrc:/home/miura/test/testdest:jobbb
*/

/* path where batch file (IJ macro) is placed,*/
//var BASEP = "\/home\/miura\/test\/ij";
var BASEP = "\/g\/almf\/miura\/pub";

/* file name of IJ macro*/
var IJMACROFILE = "headlesstest3.ijm";

/* path to folder where ij.jar and plugins folder is*/
//var IJP = "\/home\/miura\/test\/ij";
var IJP = "\/g\/almf\/miura\/pub";

/* path to SUN java*/
var SUN_JAVA = "\/usr\/struct\/bin\/java";

var var_headless =  "HEADLESS=" + IJP + "\/headless.jar\n";
var var_ijjar =     "IJ_JAR=" + IJP + "\/ij-1.44h.jar\n";
var var_ijpath =    "IJ_PATH=" + IJP + "\n";
var var_batchfile = "BATCH_FILE=" + BASEP + "\/" + IJMACROFILE + "\n";
var var_batcharg =  "BATCH_ARG=";

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

vars += srcdir + File.separator;
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
	generateJobScript(filesA[i], i, destdir);
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
	header = "#!/bin/sh\n"
	+ "#PBS -N TestPBS\n"
	+ "#PBS -l walltime=1:00:00\n";
	varslocal = vars +  filename;

	command = SUN_JAVA + " "
		+ "-Xmx1300m -cp $HEADLESS:$IJ_JAR -Djava.awt.headless=true "
		+ "ij.ImageJ -ijpath $IJ_PATH -batch $BATCH_FILE $BATCH_ARG";
	job = header + "\n\n" + varslocal + "\n" + command + "\n";
	print(job);
	jobname = jobfilePrefix+ (number+1) + ".sh";
	fullpath = destdir + File.separator + jobname;
	File.saveString(job, fullpath);
}


