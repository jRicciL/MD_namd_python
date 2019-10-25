#Script para leer los valores por residuo

proc color_res_by_value {name} {
	set file [open "$name" r]
	#abre el arcivo de valores por residuo
	#Debe haber solo una columna de valores
	set fileData [read $file]
	close $file
	set data [split $fileData "\n"]
	#Guarda cada valor como un valor independiente en un arreglo $data

	set num_steps [molinfo top get numframes]
	set sel_resid [[atomselect top "protein and alpha"] get resid]
	#inicializa un contador i
	for {set frame 0} {$frame < $num_steps} {incr frame} {
		set i 1	
		puts "$frame "
		#Modifica el valor de  num_frames para un intervalo de frames específico
		if {$frame >= 101} {
			break
		}
		foreach r $data {
		#for {set res 1} {$res < $sel_resid} {incr res} 	
			#Para cada valor r en el arreglo $data
			
			#puts "$i "
			set res_b [atomselect top "protein and backbone and resid  $i" frame "$frame"]
			#Obtiene los átomos correspondientes a cada residuo i
			#puts "$i $res_b"
			#---Sólo para verificar que el cilo funciona
			$res_b set user $r
			$res_b delete
			#Asigna a cada reisuo res_b el valor de RMSF (o el asiganado)
			#del $data 
			#$res_b delete
			
			incr i
			#incrementa i + 1
		}
		set i 1
	}

}
