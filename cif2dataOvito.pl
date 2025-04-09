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
unlink "cif_summary.txt";
open(my $DATA, ">cif_summary.txt");

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
        print $DATA "Originl cif has specifial character,like ( or ) in $cif\n";
        print "Originl cif has specifial character,like ( or )\n";
        #next;
    }
    my $data_path = `dirname '$cif'`;
    $data_path =~ s/^\s+|\s+$//g;
    my $data_name = `basename '$cif'`;
    $data_name =~ s/^\s+|\s+$//g;
    $data_name =~ s/\.cif//g;

    chomp ($data_path, $data_name);
    
    my $outputlmp = "cif2data/$data_name.lmp";
    my $outputdata = "cif2data/$data_name.data";
    unlink "$outputdata";

    #system("atomsk $cif -alignx -unskew -wrap $output");
    #system("cp $cif input.cif; python ovito_cif2data.py; rm -f input.cif; mv output.data $outputdata");
    system("cp $cif input.cif; python ovito_cif2data.py; rm -f input.cif; mv output.data $outputlmp");
    my $atomnum = `grep atoms $outputlmp|awk '{print \$1}'`;
    $atomnum =~ s/^\s+|\s+$//g;
    #print "$atomnum , $maxNum, $cif\n";
    #die;
    if($atomnum < 4){
        print $DATA "atom number of $cif (current $atomnum) <= 4, using 2 2 1 supercell\n";
        print "***atom number of $cif (current $atomnum) <= 4, using 2 2 1 supercell\n";
        unlink "$outputdata";
        my $temp = "temp.lmp";
        unlink "$temp";
        system("atomsk $outputlmp -alignx -unskew -duplicate 2 2 1 $temp");
        system("mv $temp $outputdata && rm -f $temp");

    }elsif($atomnum >= 4 and $atomnum <= $maxNum){
        print $DATA "***atom number of $cif (current $atomnum) <= $maxNum and > 4,no supercell is used.\n";
        unlink "$outputdata";         
        #system("atomsk $cif -alignx -unskew  $output");
        system("mv $outputlmp $outputdata");
    }
    else{
        print $DATA "!!!!atom number of $cif (current $atomnum) >= $maxNum, not use this cif\n";        
        print "Atom Number more than max ($maxNum): atom number ($atomnum) in $cif\n";
        unlink "$outputlmp";     
        next;
    }
    #system("cp $cif input.cif; python ovito_cif2data.py; rm -f input.cif; mv output.data $outputdata");

}    
