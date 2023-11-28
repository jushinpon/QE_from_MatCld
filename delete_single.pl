use strict;
use warnings;
use Cwd;
use POSIX;

my $currentPath = getcwd();
my $dataname;

my @datafile = `find $currentPath/cifs -name "*.cif"`;#find all data files
chomp @datafile;
die "No data files\n" unless(@datafile);

foreach $dataname(@datafile){
  
    #print "$dataname\n";

    if ($dataname =~ m/s\/(.*?)_mp/) {
        #print "yes\n";
        if($1 eq "B"||$1 eq "Li"||$1 eq "Ru"){
            `rm -f $dataname`;
        }
        
    }
} 
    
   

