
#################################################################
# If you used this script in your work, please cite:          #
# 
#
#Kumar S, Sahu P, Jena L. An In silico approach to identify
#potential inhibitors against multiple drug targets of 
#Mycobacterium tuberculosis. Int J Mycobacteriol.
#2019 Jul-Sep;8(3):252-261.
#doi: 10.4103/ijmy.ijmy_109_19. PMID: 31512601.
#
#                                                              #
# O. Trott, A. J. Olson,                                        #
# AutoDock Vina: improving the speed and accuracy of docking    #
# with a new scoring function, efficient optimization and       #
# multithreading, Journal of Computational Chemistry 31 (2010)  #
# 455-461                                                       #
#                                                               #
# DOI 10.1002/jcc.21334                                         #
#                                                               #
# Please see http://vina.scripps.edu for more information.      #
#################################################################


#This PERL program (RUN_VS.pl) is developed for virtual screenling: multiple proteins against multiple ligands using autodock_vina in linux
#Download autodock vina for linux
#Put all ligands(ligands.pdbqt) in INPUT/LIGANDS directory
#Put all proteins(proteins.pdbqt) in INPUT/PROTEINS directory
#add active site residues for each protein in INPUT/active_site.text (e.g. acpM	LEU67,ARG68)
#run perl RUN_VS.pl
#output will be saved in OUTPUT directory 
#OUTPUT directory contains PROTGEIN_LIGAND_DOCKING_RES.csv and DOCKING directory containg docking configuration files 

#download example INPUT directory along with RUN_VS.pl to test sample run

#if any query, send email to lingaraja.jena@gmail.com
