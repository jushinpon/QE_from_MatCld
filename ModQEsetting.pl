use warnings;
use strict;
use Cwd;

my $currentPath = getcwd();
my $QE_folder = "QE_trimmed";#folder where you place all your QE input files
my $out_folder = "QEall_set";#folder having all subfolders (the same prefixes as QE input file) with the QE input
`rm -rf $currentPath/$out_folder`;
`mkdir $currentPath/$out_folder`;
## set Temperature and press 
my @tempw = (50,600);
my @press = (0);
my %para =(#you may set QE parameters you want to modify here. Keys should be the same as used in QE
     cell_dofree => '"all"',
     cell_dynamics => '"pr"',
     dt => 20
);

my @keys = keys %para;#get all keys 

my @allQEin = `find $currentPath/$QE_folder -type f -name "*.in"`;#all QE template files
map { s/^\s+|\s+$//g; } @allQEin;

for my $f (@allQEin){
    my $data_path = `dirname $f`;
    my $data_name = `basename $f`;
    $data_name =~ s/\.in//g;
    chomp ($data_path, $data_name);
    #load QE_template file to trim
    open my $in ,"< $f" or die "No $f";      
    my @QE_template =<$in>;
    close $in;
    map { s/^\s+|\s+$//g; } @QE_template;
    my @keylines;
    #modify some settings first
    for my $k (@keys){
        for my $kl (0..$#QE_template){
            if($QE_template[$kl] =~ /$k/){
                $QE_template[$kl] = "$k = $para{$k}";
                last;
            }
        }
    }
    # the above settings have been done. 
    for my $t (@tempw){
        for my $p (@press){
            for my $kl (0..$#QE_template){
                if($QE_template[$kl] =~ /tempw/){
                    $QE_template[$kl] = "tempw = $t";                    
                }
                elsif($QE_template[$kl] =~ /press/){
                     $QE_template[$kl] = "press = $p";
                }
            }#T and P done!
            # make a folder to write into
            my $foldname = "$data_name-T$t-P$p";
            `mkdir -p $currentPath/$out_folder/$foldname`;
            my $trimmed = join("\n",@QE_template);
            chomp $trimmed;
            open(FH, ">$currentPath/$out_folder/$foldname/$foldname.in" ) or die $!;
            print FH $trimmed;
            close(FH);
        }
    }
}



