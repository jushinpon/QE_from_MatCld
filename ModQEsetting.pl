use warnings;
use strict;
use Cwd;

my $currentPath = getcwd();
my $QE_folder = "QE_trimmed";#folder where you place all your QE input files
my $out_folder = "QEall_set";#folder having all subfolders (the same prefixes as QE input file) with the QE input
`rm -rf $currentPath/$out_folder`;
## set Temperature and press 
my @tempw = (50,600);
my @press = (0);
my %para =(#you may set QE parameters you want to modify here. Keys should be the same as used in QE
     cell_dofree => '"all"';
);
my @allQEin = `find $currentPath/$QE_folder -type f -name "*.in"`;#all QE template files
map { s/^\s+|\s+$//g; } @allQEin;

for my $f (@allQEin){
    my $data_path = `dirname $f`;
    my $data_name = `basename $f`;
    $data_name =~ s/\.in//g;
    chomp ($data_path, $data_name);



}



