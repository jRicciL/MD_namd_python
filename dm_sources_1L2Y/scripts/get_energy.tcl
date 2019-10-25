
mol new e6_p03h_wb.psf
mol addfile e6_p03h_wb_1_sa.restart.vel type namdbin waitfor all
mol addfile e6_p03h_wb_1_sa.restart.vel type namdbin waitfor all

set waters [atomselect top "water"]
set oxiWater [atomselect top "water and noh"]
set prot [atomselect top "all and not water"]

#Juntos
set fil [open energyKic-p03-hx.dat w]
foreach m [$prot get mass] v [$prot get {x y z}] {
puts $fil [expr 0.5* $m * [vecdot $v $v]]
}
set hMass 1.008
foreach w [$oxiWater get mass] v [$oxiWater get {x y z}] {
puts $fil [expr 0.5* ($w+(2*$hMass)) * [vecdot $v $v]]
}
close $fil

#Para obtener de  la E6+Hélice
mol new p03_hx_wb.psf
mol addfile p03_hx_wb_1_sa.restart.vel type namdbin waitfor all
mol addfile new p03_hx_wb_1_sa.restart.vel type namdbin waitfor all
