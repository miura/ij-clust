print('=== testing GUI environment ===');
open('/g/cmci/tmp/tt.tif');
print('opened file successfully');
run("Gaussian Blur...", "sigma=10");
print('Gaussian Blurred successfully');
run("Invert", "stack");
print('inverted successfully');
run("Subtract Background...", "rolling=50");
