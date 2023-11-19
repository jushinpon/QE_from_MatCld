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

my $filefold = "QEall_set";

my $currentPath = getcwd();# dir for all scripts

my $forkNo = 1;#although we don't have so many cores, only for submitting jobs into slurm
my $pm = Parallel::ForkManager->new("$forkNo");

my @all_files = `find $currentPath/$filefold -maxdepth 2 -mindepth 2 -type f -name "*.sh" `;
#my @all_files = `find $currentPath/$filefold -maxdepth 2 -mindepth 2 -type f -name "*.sh" -exec readlink -f {} \\;|sort`;
map { s/^\s+|\s+$//g; } @all_files;

for my $i (@all_files){
    #print "\$i: $i\n";
    my $dirname = `dirname $i`;
    chomp $dirname;
    chdir($dirname);
    `sbatch $i`;
    chdir($currentPath);
}#  

