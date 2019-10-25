
mol new e6_p03h_wb.psf
mol addfile e6_p03h_wb_sa.restart.vel type namdbin waitfor all
mol addfile e6_p03h_wb_sa_b.restart.vel type namdbin waitfor all

set all [atomselect top all]

#Debo evaluar de forma independiente las moléculas de agua para evitar los grados de libertad
#Esto es porque usamos rigidsbonds, pero la ecuación de la energía cinética funciona sólo para las H2O flexibles

#Conador de átomos
set i 0
foreach atom [$oxiWater get mass] { incr i }
puts $i

set waters [atomselect top "water"]
set oxiWater [atomselect top "water and noh"]
set prot [atomselect top "all and not water"]

#Masa de un hidrógeno
1.0080000162124634

#Proteina
set fil [open energyProt.dat w]
foreach m [$prot get mass] v [$prot get {x y z}] {
puts $fil [expr 0.5* $m * [vecdot $v $v]]
}

#Agua
set fil [open energyWater_all.dat w]
set hMass 1.0080000162124634
foreach m [$waters get mass] v [$waters get {x y z}] {
puts $fil [expr 0.5* ($m) * [vecdot $v $v]]
}

#Juntos
set fil [open energy_WaterRig.dat w]
set hMass 1.008
foreach w [$oxiWater get mass] v [$oxiWater get {x y z}] {
puts $fil [expr 0.5* ($w+(2*$hMass)) * [vecdot $v $v]]
}
close $fil


#Todos
set all [atomselect top all]
set fil [open energy_all.dat w]
foreach m [$all get mass] v [$all get {x y z}] {
puts $fil [expr 0.5* $m * [vecdot $v $v]]
}
close $fil