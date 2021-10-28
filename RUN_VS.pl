#!/usr/local/bin/perl
#PERL program for virtual screenling: multiple proteins against multiple ligands using autodock_vina in linux
#Download autodock vina for linux
#Put all ligands(ligands.pdbqt) in INPUT/LIGANDS directory
#Put all proteins(proteins.pdbqt) in INPUT/PROTEINS directory
#add active site residues for each protein in INPUT/active_site.text (e.g. acpM	LEU67,ARG68)
#run perl RUN_VS.pl
#output will be saved in OUTPUT directory 
#OUTPUT directory contains PROTGEIN_LIGAND_DOCKING_RES.csv and DOCKING directory containg docking configuration files

#give the path for vina
$vina_dir_path="autodock_vina_1_1_2_linux_x86/bin";

system("ls INPUT/PROTEINS > PROTEIN_LIST");
system("ls INPUT/LIGANDS > LIGAND_LIST");
system("mkdir OUTPUT");
system("mkdir OUTPUT/DOCKING");

open(pfile, "PROTEIN_LIST") || die "PROTEIN_LIST not found..Please check";
@proteins=<pfile>;
close(pfile);
$total_proteins=(@proteins);

print "Total Proteins:$total_proteins\n";

open(lfile, "LIGAND_LIST") || die "LIGAND_LIST not found..Please check";
@ligands=<lfile>;
close(lfile);
$total_ligands=(@ligands);
print "Total Ligands:$total_ligands\n";

open(actfile, "INPUT/active_site.txt") || die "active_site.text not found..Please check";
@active=<actfile>;
close(actfile);
$total_active=(@active);

open(FILETAB,">OUTPUT/PROTGEIN_LIGAND_DOCKING_RES.csv");
print FILETAB "PROTEIN,LIGAND,MODE,BINDING ENERGY,RMSD LB, RMSD UB\n";

for($p=0;$p<$total_proteins;$p++)
{
$protein_file=$proteins[$p];
$protein_file=~s/\n//g;
$active_site_chk=0;
	for($a=0;$a<$total_active;$a++)
	{
	$active[$a]=~s/\n//g;
	@active_pos=split(/\t/,$active[$a]);
	$protein_id=$active_pos[0];

		if($protein_file eq $protein_id)
		{
		$active_sites=$active_pos[1];
		$active_site_chk=1;
		last;
		}
	}
if($active_site_chk ==0)
{
print "Active site residues not specified for $protein_file\n";
}
else
{
$active_sites=uc($active_sites);
@active_site_res=split(/\,/,$active_sites);
@xp=();
@yp=();
@zp=();


foreach $res(@active_site_res)
{
	$res_nm=$res;
	$res_nm=substr($res_nm,0,3);
	$res_pos=$res;
	$res_pos=~s/$res_nm//g;
	open(file1,"INPUT/PROTEINS/$protein_file");
	@prot_cont=<file1>;
	close(file1);
	foreach $line(@prot_cont)
	{
		$line=~s/\n//g;
		@line_c=split(/\s+/,$line);
		$resn=$line_c[3];
		$resp=$line_c[4];
		if(($resn eq $res_nm) && ($resp==$res_pos))
		{
		$x=$line_c[5];
		$y=$line_c[6];
		$z=$line_c[7];
		push(@xp,$x);
		push(@yp,$y);
		push(@zp,$z);
		}
	}
}
	@xp=sort { $a <=> $b } @xp;
	@yp=sort { $a <=> $b } @yp;
	@zp=sort { $a <=> $b } @zp;
	$x1=$xp[0];
	$x2=$xp[-1];
	$y1=$yp[0];
	$y2=$yp[-1];
	$z1=$zp[0];
	$z2=$zp[-1];
	$x=($x1+$x2)/2;
	$y=($y1+$y2)/2;
	$z=($z1+$z2)/2;

$doc_dir=$protein_file;
$doc_dir=~s/\.(.*)//g;
system("mkdir OUTPUT/DOCKING/$doc_dir");
foreach $l_file(@ligands)
{
$l_file=~s/\n//g;
open(file1,">conf.txt");
print file1 "receptor = INPUT/PROTEINS/$protein_file\n";
print file1 "ligand = INPUT/LIGANDS/$l_file\n";
print file1 "out = OUTPUT/DOCKING/$doc_dir/$l_file\n";
print file1 "center_x = $x\n";
print file1 "center_y = $y\n";
print file1 "center_z = $z\n";
print file1 "size_x = 60.0\n";
print file1 "size_y = 60.0\n";
print file1 "size_z = 60.0\n";
print file1 "num_modes = 9\n";
close(file1);
system("$vina_dir_path/vina  --config conf.txt --log result.txt");
########################################################
open(FILET,"result.txt");
@res_c=<FILET>;
close(FILET);
$total_line=(@res_c);
for($i=0;$i<$total_line;$i++)
{
if($res_c[$i]=~m/-----+/)
{
$m=$i+1;
}
if($res_c[$i]=~m/Writing output/)
{
$n=$i;
}
}
for($i=$m;$i<$n;$i++)
{
$res_c[$i]=~s/\n//g;
@conf=split(/\s+/,$res_c[$i]);
print FILETAB "$protein_file,$l_file,$conf[1],$conf[2],$conf[3],$conf[4]\n";
}
########################################################
}

}
}
close(FILETAB);











