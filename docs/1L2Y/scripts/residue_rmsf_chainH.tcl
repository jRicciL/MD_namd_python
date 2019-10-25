#RMSF para E6 más una alfa hélice
# Asumiendo que E6 es la chain H
#Los RMSF sólo me interesa hacerlos con la dinámica

#--- Alinea todos los frames para calcular el RMSF

#--- selección de los frmaes y los átomos
# Usa el frame 0 como frame de referencia para el alineamiento
set reference [atomselect top "chain H" frame 0]
# the frame being compared
set compare [atomselect top "chain H"]
#make a selection with all atoms
set all [atomselect top all]
#get the number of frames
set num_steps [molinfo top get numframes]
#open file for writing

#--- Loop que alinea frame a frame
for {set frame 0} {$frame < $num_steps} {incr frame} {
	puts "Alineando $frame ..."
	# get the correct frame
	$compare frame $frame
        $all frame $frame
	# compute the transformation
	set trans_mat [measure fit $compare $reference]
	# do the alignment
	$all move $trans_mat
}

#--- Obtiene los valores de RMSF
set prot [[atomselect top "protein and chain H and alpha"] get resid]
set output [open residue_rmsf_chainH.dat w]
set i 1
foreach res $prot {
	#Selecciona el carbono alfa del residuo
	set resAlpha [atomselect top "protein and chain H and alpha and resid $res"]
	#mide el el RMSF de todos los frames del Ca del residuo
	set value [measure rmsf $resAlpha]
	puts " $i $value"
	#Guarda el valor en residue_rmsf.dat
	puts $output " $value"
	incr i
	#$value delete
}
close $output


#Evaluando
# 	set res1 [atomselect top "protein and alpha and resid 2" frame 0]
# 	set res2 [atomselect top "protein and alpha and resid 2" frame 1]
# 	measure rmsd $res2 $res1
# 	measure rmsf $res1