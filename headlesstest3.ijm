//2010 06 30 updated
//Kota Miura (miura@embl.de)

srcfile = getArgument();	//for use with CUI
//srcfile = File.openDialog("choose a file");	//for testing in GUI
srcdir = File.getParent(srcfile);
srcfoldername = File.getName(srcdir);
srcdirpar = File.getParent(srcdir);
outdir = "" + srcdirpar + File.separator + srcfoldername + "_proc";
print("input file:" + srcfile);
print("output dir:" + outdir);
getDateAndTime(year, month, dayOfWeek, dayOfMonth, shour, sminute, ssecond, msec);
timestamp ="**** Start: "+ year + "-" + month + "-" + dayOfMonth + "-" + shour + ":" + sminute + ":" + ssecond + "." +msec;
print(timestamp);
if (!File.exists(srcfile)) {
	print("Could not fine the file: " + srcfile);
	exit();
}

//outpath = srcdir + File.separator + "processed";
if (!File.isDirectory(outdir))
	File.makeDirectory(outdir);

open(srcfile);	
run("Preprocess ChromosomeDots");
	//run("Inverter");
saveAs("Tiff", outdir + File.separator + "FFT"+File.name);

getDateAndTime(year, month, dayOfWeek, dayOfMonth, ehour, eminute, esecond, msec);
timestamp2 ="*** END: "+ year + "-" + month + "-" + dayOfMonth + "-" + ehour + ":" + eminute + ":" + esecond + "." +msec;
print(timestamp2);
durtext = durationCalc2(shour, sminute, ssecond,ehour, eminute, esecond);
print(durtext);

//	close();
function durationCalc2(shour, sminute, ssecond,ehour, eminute, esecond){
	st = shour * 60 * 60 + sminute * 60 + ssecond;
	et = ehour * 60 * 60 + eminute * 60 + esecond;
	dt = et - st;
	dhour = floor(dt/3600);
	dmin = floor((dt - dhour *60 * 60) / 60 );
	dsec = dt % 60;
	durtext = "\nduration: HH:MM:SS " + leftPad(dhour, 2) + ":" + leftPad(dmin, 2) + ":" + leftPad(dsec, 2);
	return durtext;	 	 
}

function leftPad(n, width) {
    s =""+n;
    while (lengthOf(s)<width)
        s = "0"+s;
    return s;
}
