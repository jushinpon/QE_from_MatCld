use strict;
use warnings;
print "You need to modify the element set in mp_get_cif.py for yourown system\n";

#remove all folders
system("rm -rf cifs cif2data data2QE4MatCld QEinByMatCld QE_trimmed");

print "1. getting all cif files from materials project into cifs \n";
system("python mp_get_cif.py");
die;
print "2. converting all cif files to data files into cif2data \n";
system("perl cif2data.pl");

print "3. converting all data files to QE input into data2QE4MatCld\n";
system("perl data2QE4MatCld.pl");

print "4. getting corresponding QE input from Materials Cloud into QEinByMatCld\n";
system("perl QEinputByMatCld.pl");

print "5. final trim for QE input files in QE_trimmed\n";
system("perl Final_QEinTrim.pl");