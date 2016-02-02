/* ImageJ macro for generating shell scripts to be used by qsub array
	Kota miura (miura@embl.de) 2010

	...better be written as a shell script in future. 

 to use this macro, adjust path variable SUN_JAVA if required
 you might probably need to change the name of imageJ jar file of var_ijjar

 requres three arguments separated by colon. 
 arg[0]: path to the folder cotaining images to be processed
 arg[1]: path to the output folder for processed images
 arg[2]: path to the folder where scripts will be saved
 arg[3]: prefix of job shell scrips. should be longer than 2 chars 
 arg[4]: path to ij jars
 arg[5]: path to IJ macro
 arg[6]: IJ macro name

 Example command for execution
 /usr/struct/bin/java -cp headless.jar:ij-1.44h.jar -Djava.awt.headless=true ij.ImageJ -batch JCreate.ijm /home/miura/test/testsrc:/home/miura/test/testdest:jobbb
*/

/* path where batch file (IJ macro) is placed,*/
var BASEP = "\/g\/almf\/software\/ij";

/* file name of IJ macro*/
var IJMACROFILE = "headlesstest3.ijm";

/* path to folder where ij.jar and plugins folder is*/
var IJP = "\/g\/almf\/softwarei\/ij";

/* path to SUN java*/
var SUN_JAVA = "\/usr\/struct\/bin\/java";

var var_headless;
var var_ijjar;
var var_ijpath;
var var_batchfile;
var var_batcharg;
var vars;
var jobfilePrefix = "job_";
	
arg = getArgument();
print(arg);
argA = split(arg, ":");
//for (i=0; i<argA.length; i++) print(argA[i]);
if (argA.length != 7){
	print("Number of Arguments:" + argA.length);
	print("Abort Generator: There should be exactly 7 arguments for running script generator.");
	exit();
}
srcdir = argA[0];
outdir = argA[1];
destdir = argA[2];
argjobprefix = argA[3];
if (lengthOf(argjobprefix)>2){
	jobfilePrefix = argjobprefix;
}
IJP = argA[4];
BASEP = argA[5];
IJMACROFILE = argA[6];

print("variables taken from arguments");

setVariables();

vars += srcdir + File.separator;

print("input: " + srcdir);
print("output: " + outdir);
print("jobs: " + destdir);
print("ImageJ Path: " + IJP);
print("ImageJ macro Path: " + BASEP);
print("ImageJ macro Name: " + IJMACROFILE);


if (!File.isDirectory(srcdir)) {
	print("Abort: source directory does not exist!");
	exit();
}
if (!File.isDirectory(outdir)) {
	print("Abort: output directory does not exist!");
	exit();
}
if (!File.isDirectory(destdir)) {
	File.makeDirectory(destdir);
}
if (!File.isDirectory(IJP)) {
	print("Abort: ImageJ directory does not exist!");
	exit();	
}
if (!File.isDirectory(BASEP)) {
	print("Abort: ImageJ Image Processing Macro directory does not exist!");
	exit();	
}
if (!File.exists(BASEP + File.separator + IJMACROFILE)) {
	print("Abort: Image Processing Macro File does not exist!");
	exit();	
}

filesA = getFileList(srcdir);
jobfilename = "job_";
for (i = 0; i< filesA.length; i++){
	generateJobScript(filesA[i], i, destdir);
}

jobarraystring = "#!/bin/sh\n"
		+ "\n"
		+ "#PBS -J 1-" + filesA.length + "\n"
		//+ "#PBS -q clusterng\n"
		+ "#PBS -q clng_new\n"
		+ destdir+  File.separator 
		+ jobfilePrefix + "$PBS_ARRAY_INDEX.sh";
		
jobarrayfile_fullpath = destdir + File.separator + "jobarray.sh";

File.saveString(jobarraystring, jobarrayfile_fullpath);

function setVariables(){
	var_headless =  "HEADLESS=" + IJP + "\/headless.jar\n";
	var_ijjar =     "IJ_JAR=" + IJP + "\/ij-1.44h.jar\n";
	var_ijpath =    "IJ_PATH=" + IJP + "\n";
	var_batchfile = "BATCH_FILE=" + BASEP + "\/" + IJMACROFILE + "\n";
	var_batcharg =  "BATCH_ARG=";

	vars = var_headless
		+ var_ijjar
		+ var_ijpath
		+ var_batchfile
		+ var_batcharg;
}


function generateJobScript(filename, number, destdir){
	header = "#!/bin/sh\n"
	+ "#PBS -N TestPBS\n"
	+ "#PBS -l walltime=1:00:00\n";
	varslocal = vars +  filename;

	command = SUN_JAVA + " "
		+ "-Xms32m -Xmx6000m -cp $HEADLESS:$IJ_JAR -Djava.awt.headless=true "
		+ "ij.ImageJ -ijpath $IJ_PATH -batch $BATCH_FILE $BATCH_ARG";
	job = header + "\n\n" + varslocal + "\n" + command + "\n";
	print(job);
	jobname = jobfilePrefix+ (number+1) + ".sh";
	fullpath = destdir + File.separator + jobname;
	File.saveString(job, fullpath);
}



