=b
1. check_QEjobs.pl: check all your job status under a specific folder (!!!!!need to modify it for your case) and place check results into QEjobs_status.  
2. find_data4relax.pl: find the data files in all data_files folders under a specific folder (!!!!!need to modify it for your case) and move it to folder, data4relax.
3. ModQEin4Dead.pl: modify QE input setting for dead cases recorded by Dead.txt in QEjobs_status folder. 
=cut


use strict;
use warnings;
print "You need to modify the element set in mp_get_cif.py for yourown system\n";

#remove all folders
system("rm -rf cifs cif2data data2QE4MatCld QEinByMatCld QE_trimmed");

print "1. getting all cif files from materials project into cifs \n";
system("python mp_get_cif.py");

print "2. converting all cif files to data files into cif2data \n";
system("perl cif2dataOvito.pl");

print "3. converting all data files to QE input into data2QE4MatCld\n";
system("perl data2QE4MatCld.pl");

print "4. getting corresponding QE input from Materials Cloud into QEinByMatCld\n";
system("perl QEinputByMatCld.pl");

print "5. final trim for QE input files using MatCld input and place them in QE_trimmed\n";
system("perl Final_QEinTrim.pl");

print "6. Modify some QE setting for QE input files and place them in QEall_set\n";
system("perl ModQEsetting.pl");

#print "7. make sbatch file in each subfolder of QEall_set\n";
#system("perl make_slurm_sh.pl");
#
#print "8. submit the job in each subfolder of QEall_set\n";
#system("perl submit_allslurm_sh.pl");
