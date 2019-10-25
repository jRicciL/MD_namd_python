#RMSF para E6 más una alfa hélice
# Asumiendo que E6 es la chain H, y que sólo quiero los átomos del pocket
# Atom select necesita sólamente la secuencia del primer y último número del aminoácido
#Los RMSF sólo me interesa hacerlos con la dinámica

#--- Alinea todos los frames para calcular el RMSF

#--- selección de los frmaes y los átomos
# Usa el frame 0 como frame de referencia para el alineamiento... 
set reference [atomselect top "protein" frame 0]
# the frame being compared
set compare [atomselect top "protein"]
#make a selection with all atoms
set all [atomselect top all]
#get the number of frames
set num_steps [molinfo top get numframes]
#open file for writing

#--- Loop que alinea frame a frame... Alinea ambas cadenas H y B
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

#--- Obtiene los valores de RMSF: Primero para el pocket
set pocketAtoms [[atomselect top "protein and chain H and resid 38 to 138 and alpha"] get resid]
set output [open residue_rmsf_pocket_allAtoms.dat w]
set i 1
foreach atom $pocketAtoms {
	#Selecciona todos los átomos del residuo
	set resAtoms [atomselect top "protein and resid $res"]
	#mide el el RMSF de todos los frames del Ca del residuo
	set value [measure rmsf $resAtoms]
	puts " $i"
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