use strict;
use warnings;
use Cwd;
use Data::Dumper;
my $data=`cat *.sout`;
my @energy=`grep "!" *.sout |awk '{print \$5}'`;
my @pressure=`grep "P=" *.sout |awk '{print \$6}'`;
my @density=`grep "density =" *.sout |awk '{print \$3}'`;
my $data_quantity = 3; #number of data

my $output_file_name="energy_pressure_density.py";
my $output_sout_file = "sout_data.txt";
my $xlabel='Strain';
my $ylabel="'total energy (keV)','Stress (kbar)','density(g/cm^3)'";

chomp @energy;
chomp @pressure;
chomp @density;
my @energy_ev;
my $ax='';
my $ax_1;
my $currentPath = getcwd();
open my $sout_data ,"> ./$output_sout_file";
for (0..$#energy){
    my $k=$_+1;
    @energy_ev[$_]=$energy[$_]*0.013605684958731;
    print $sout_data "$k\t  $energy_ev[$_]\t $pressure[$_]\t $density[$_]\n";
}
close ($sout_data);


for(1..$data_quantity){
    $ax_1='ax'.$_;
    $ax="$ax"."$ax_1";
    if($_ != $data_quantity){
        $ax="$ax".",";
    }
}


my %plot_png_para = (
            read_txt => $output_sout_file,
            xlabel => $xlabel,
            ylabel => $ylabel,  
            data_quantity =>$data_quantity,
            ax => $ax,    
            output_file => $output_file_name,
            S => '(\S+)\.png',
            );
&plot_png(\%plot_png_para);



sub plot_png
{
my ($plot_png_hr) = @_;
my $plot_png = <<"END_MESSAGE";
import matplotlib.pyplot as plt
import os
import re
import os.path
import shutil
xlabel='$plot_png_hr->{xlabel}'
ylabel=[$plot_png_hr->{ylabel}]
image_color=['red','green','blue','yellow','cyan','magenta','white','black']
key = 0
value_lenght = 0
path = "./PNG"
X_value=[]
ax=[]
fig, (($plot_png_hr->{ax})) = plt.subplots($plot_png_hr->{data_quantity})
ax=[$plot_png_hr->{ax}]


with open('$plot_png_hr->{read_txt}', 'r') as f:#1
    lines = f.readlines()#2
    for line in lines:#3
        value = [float(s) for s in line.split()]#4
        value_lenght = len(value)
        if key == 0:
            value_total_lenght = len(value)   
        for i in range(value_lenght):
            if key == 0:
                globals()['number'+str(i)] = []                
        key = 1 
        if key == 1:
            for i in range(value_lenght):
                globals()['number'+str(i)].append(value[i])  
                    

for i in range(value_total_lenght-1):
    value_lenght_2=len(globals()['number'+str(i+1)])
    for j in range(value_lenght_2):
        X_value.append(j+1)
    ax[i].set_xlabel(xlabel,fontweight='bold')
    ax[i].set_ylabel(ylabel[i],color='black',fontweight='bold')
    ax[i].plot(X_value,globals()['number'+str(i+1)],label='total energy',color=image_color[i],marker='s',markevery=5)
    ax[i].grid()
    X_value=[]


fig.tight_layout()
plt.savefig("sout.png") 

dir_path = os.path.dirname(os.path.realpath(__file__))
all_file_name = os.listdir(dir_path)
txt_data=[]

for i in range(len(all_file_name)):
    if(re.match(r'$plot_png_hr->{S}',all_file_name[i]) ):
        txt = re.match(r'$plot_png_hr->{S}',all_file_name[i])  
        txt_data.append(txt.group(1))
        
try:
    shutil.rmtree(path)
except OSError as error:
    key=0
if not os.path.isdir(path): os.makedirs(path)
for j in range(len(txt_data)):
    shutil.move('./'+ txt_data[j]+".png" ,path+'/')
# %%

END_MESSAGE

    open(FH, '>', $plot_png_hr->{output_file}) or die $!;
    print FH $plot_png;
    close(FH);
    chdir("$currentPath");
    system("python $plot_png_hr->{output_file}");
}
