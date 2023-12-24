use strict;
use warnings;
use Cwd;
use POSIX;
#use lib '.';
#use elements;
unlink "cif_summary.txt";
my $maxNum = 64;#maximum number allowed in cif files
open(my $DATA, ">cif_summary.txt");
my $currentPath = getcwd();
my @ciffiles = `find $currentPath/cifs -name "*.cif"`;
#my @ciffiles =("/home/jsp/QE_from_MatCld/cifs/Al3(BRu2)2_mp-541849.cif");
chomp @ciffiles;

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
    my $data_name = `basename '$cif'`;
    $data_name =~ s/\.cif//g;
    chomp ($data_path, $data_name);
    
    my $output = "cif2data/$data_name.lmp";
    my $outputdata = "cif2data/$data_name.data";
    unlink "$output";
    #system("atomsk $cif -alignx -unskew -wrap $output");
    system("atomsk \"$cif\" -alignx -unskew $output");
    my $atomnum = `grep atoms $output|awk '{print \$1}'`;
    $atomnum =~ s/^\s+|\s+$//g;
    print "$atomnum , $maxNum, $cif\n";
    if($atomnum <= 4){
        print $DATA "atom number of $cif (current $atomnum) <= 4, using 2 2 1 supercell\n";
        unlink "$output";
        system("atomsk $cif -alignx -unskew -duplicate 2 2 1 $output");
    }elsif($atomnum > 4 and $atomnum <= $maxNum){
        print $DATA "***atom number of $cif (current $atomnum) <= $maxNum and > 4,no supercell is used.\n";
        unlink "$output";         
        system("atomsk $cif -alignx -unskew  $output");
    }
    else{
        print $DATA "!!!!atom number of $cif (current $atomnum) >= $maxNum, not use this cif\n";        
        print "$atomnum , $maxNum, $cif\n";
        unlink "$output";     
        next;
    }
    my @temp = `cat $output`;
    map { s/^\s+|\s+$//g; } @temp;
    my $temp = join("\n",@temp);
    chomp $temp;
    unlink "$output";
    unlink "$outputdata";
    open(my $DATA1, ">$outputdata");
    print $DATA1 "$temp\n";
  
    close($DATA1);   
}

close($DATA);
print "\n***Pleae check cif_summary.txt or the following content of cif_summary.txt:\n";
print "\n***printing cif_summary.txt!!!\n";
system("cat ./cif_summary.txt");
#print "\n\n*** If the above is empty, no cif is skipped or using supercell for data file.\n";
