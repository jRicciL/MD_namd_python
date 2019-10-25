# Ese script genera el RMSD de cada residuo indicado para
# TODOS LOS ATOMOS

# --------- Parte de alineación de frmaes -------

# Usa el frame 0 como frame de referencia para el alineamiento... 
set reference [atomselect top "chain B" frame 0]
# the frame being compared
set compare [atomselect top "chian B"]
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
# ---------- Parte de generación de rmsf y de los archivos

# Cambiar por Pocket o hélice:
# Pocket de E616 38  39  57  58  59  60  61  62  67  68  69  70  71  72  73  74  75  76  77  78  79  80  81  82 109 112 136 137 138]
# Hélice [1] 369 370 371 372 373 374 375 376 377 378 379 380 381 382

# Lista de posiciones de los residuos a obtener el RMSD
set lista_de_indices [list 369 370 371 372 373 374 375 376 377 378 379 380 381 382]

foreach res $lista_de_indices {
  puts " Working on resid $res ..."
    set outDataFile [open $res.rmsd w]
    set sela [atomselect top "resid $res"]
    set selb [atomselect top "resid $res"]
    $sela frame 0
    for {set f 0} {$f<=$num_steps} {incr f} {
      $selb frame $f
      display update
      set val [measure rmsd $sela $selb]
      set resid $res
      puts $outDataFile "$val"
    }
    close $outDataFile
}