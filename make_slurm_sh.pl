=b
make lmp input files for all strucutres in labelled folders.
You need to use this script in the dir with all dpgen collections (in all_cfgs folder)
perl ../tool_scripts/cfg2lmpinput.pl 
=cut
use warnings;
use strict;
use JSON::PP;
use Data::Dumper;
use List::Util qw(min max);
use Cwd;
use POSIX;
use Parallel::ForkManager;
use List::Util qw/shuffle/;

my $submitJobs = "yes";
my %sbatch_para = (
            nodes => 1,#how many nodes for your lmp job
            cpus_per_task => 1,
            partition => "All",#which partition you want to use
            runPath => "mpiexec /opt/QEGCC_MPICH4.0.3_thermoPW_intel/bin/pw.x -ndiag 1",          
            );

my $currentPath = getcwd();# dir for all scripts
chdir("..");
my $mainPath = getcwd();# main path of Perl4dpgen dir
chdir("$currentPath");

my $forkNo = 1;#although we don't have so many cores, only for submitting jobs into slurm
my $pm = Parallel::ForkManager->new("$forkNo");

my @alllmpin = `find $currentPath -maxdepth 3 -type f -name "*.in" -exec readlink -f {} \\;|sort`;
map { s/^\s+|\s+$//g; } @alllmpin;

my $jobNo = 0;
for my $i (@alllmpin){
    my $basename = `basename $i`;
    my $dirname = `dirname $i`;
    $basename =~ s/\.in//g; 
    chomp ($basename,$dirname);
    `rm -f $dirname/$basename.sh`;
    $jobNo++;
my $here_doc =<<"END_MESSAGE";
#!/bin/sh
#SBATCH --output=$basename.sout
#SBATCH --job-name=$basename
#SBATCH --nodes=$sbatch_para{nodes}
#SBATCH --cpus-per-task=$sbatch_para{cpus_per_task}
#SBATCH --partition=$sbatch_para{partition}
##SBATCH --exclude=node23

rm -rf pwscf*
threads=$sbatch_para{cpus_per_task}
export OMP_NUM_THREADS=\$threads

$sbatch_para{runPath} -in $basename.in

END_MESSAGE

    open(FH, "> $dirname/$basename.sh") or die $!;
    print FH $here_doc;
    close(FH);
    if($submitJobs eq "yes"){
        chdir($dirname);
        `sbatch $basename.sh`;
        chdir($currentPath);
    }    
}#  
