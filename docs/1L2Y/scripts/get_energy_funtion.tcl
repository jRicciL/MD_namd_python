
proc gte_kin_energy_all {psfName velName} {
	mol new $psfName
	mol addfile $velName type namdbin waitfor all

	set all [atomselect top all]

	set fil [open energy_kin_all.dat w]
	foreach m [$all get mass] v [$all get {x y z}] {
	puts $fil [expr 0.5* $m * [vecdot $v $v]]
	}
	close $fil
}

proc gte_kin_energy_rigidWater {psfName velName} {
	mol new $psfName
	mol addfile $velName type namdbin waitfor all

	set waters [atomselect top "water"]
	set oxiWater [atomselect top "water and noh"]
	set prot [atomselect top "all and not water"]

	set fil [open energy_kin_rigidWater.dat w]
	foreach m [$prot get mass] v [$prot get {x y z}] {
	puts $fil [expr 0.5* $m * [vecdot $v $v]]
	}
	set hMass 1.008
	foreach w [$oxiWater get mass] v [$oxiWater get {x y z}] {
	puts $fil [expr 0.5* ($w+(2*$hMass)) * [vecdot $v $v]]
	}
	close $fil
}
