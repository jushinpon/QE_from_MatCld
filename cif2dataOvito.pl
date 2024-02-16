use strict;
use warnings;
use Cwd;
use POSIX;
#use lib '.';
#use elements;
my $maxNum = 64;#maximum number allowed in cif files
my $currentPath = getcwd();
my @ciffiles = `find $currentPath/cifs -name "*.cif"`;
map { s/^\s+|\s+$//g; } @ciffiles;
#my @ciffiles =("/home/jsp/QE_from_MatCld/cifs/Al3(BRu2)2_mp-541849.cif");

`rm -rf cif2data`;
`mkdir cif2data`;

for my $cif (@ciffiles){
    #modify special characters to modify (() to -)
    my $tempf = $cif;
    if($tempf =~ s/\(/-/ or $tempf =~ s/\)/-/){
        $tempf =~ s/\(/-/;
        $tempf =~ s/\)/-/;
        `mv '$cif' '$tempf'`;
        $cif = $tempf;
        print "Originl cif has specifial character,like ( or )\n";
    }
    my $data_path = `dirname '$cif'`;
    $data_path =~ s/^\s+|\s+$//g;
    my $data_name = `basename '$cif'`;
    $data_name =~ s/^\s+|\s+$//g;
    $data_name =~ s/\.cif//g;

    chomp ($data_path, $data_name);
    
    my $outputdata = "cif2data/$data_name.data";
    unlink "$outputdata";

    #system("atomsk $cif -alignx -unskew -wrap $output");
    system("cp $cif input.cif; python ovito_cif2data.py; rm -f input.cif; mv output.data $outputdata");
}    
