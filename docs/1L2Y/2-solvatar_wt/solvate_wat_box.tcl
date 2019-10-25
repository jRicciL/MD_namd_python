### Script para solvatar a la proteína en un acaja de agua
### lo suficientemente grande para cubrirla completamente

set molname tc5b

# Abrir los archivos de topología y coordenadas de la proteína
mol new ${molname}.psf
mol addfile ${molname}.pdb

# Solvatar la proteína en una caja de agua con un padding de 10 A
package require solvate
solvate ${molname}.psf ${molname}.pdb -t 15 -o ${molname}_temp

## Selecciona todos los átomos del sistema
set sistema [atomselect top all]
## Obtener la carga del sistema
# USAR: 
source ./get_charge.tcl
get_total_charge top

## Neutralizar el sistema
package require autoionize
autoionize -psf ${molname}_temp.psf -pdb ${molname}_temp.pdb -neutralize -o ${molname}_wb

## Observar que ahora tendrán tres sistemas en el VMD Main, y que el último corresponde al sistema
## Neutralizado con Cl
## Observar el número de átomos de cada sistema
## Visualizar el ión en el VMD

#################### MEDIDAS DE LA CAJA
mol delete all
set molname tc5b

# Abrir los archivos de topología y coordenadas de la proteína
mol new ${molname}_wb.psf
mol addfile ${molname}_wb.pdb

set sist_neutro [atomselect top all]

# Coordenadas mínimas y máximas xyz del sistema
set box_size [measure minmax $sist_neutro]

# Coordenadas xyz del centro del sistema
set box_center [measure center $sist_neutro]

## Guarda en un archivo las dimensiones y centro de la caja
set file [open box_dims.txt w]
# Dimenciones [maximo - minimo]
set x_dim [expr [lindex [lindex $box_size 1] 0] - [lindex [lindex $box_size 0] 0]]
set y_dim [expr [lindex [lindex $box_size 1] 1] - [lindex [lindex $box_size 0] 1]]
set z_dim [expr [lindex [lindex $box_size 1] 2] - [lindex [lindex $box_size 0] 2]]
puts $file "cellBasisVector1\t$x_dim\t0.0\t0.0"
puts $file "cellBasisVector2\t0.0\t$y_dim\t0.0"
puts $file "cellBasisVector3\t0.0\t0.0\t$z_dim"
set x_center [lindex $box_center 0]
set y_center [lindex $box_center 1]
set z_center [lindex $box_center 2]
puts $file "cellOrigin\t$x_center\t$y_center\t$z_center"
close $file
