#############################################################
## CALENTAMIENTO NVT: Prueba 1L2Y                          ##
#############################################################

## Escribe aquí los comentarios necesarios para describir el trabajo

#############################################################
## ADJUSTABLE PARAMETERS                                   ##
#############################################################

## Declara el nombre del archivo .pdb y psf (sin extenciones)
set inputname      tc5b_wb
## Lee los archivos de coordenadas (pdb) y topologia (psf)
structure          ../$inputname.psf
coordinates        ../$inputname.pdb
## Ahora si se utiliza un archivo restart, el de la minimizacion
set restart        ../1_min/${inputname}_min

## Nombre de los archivos de salida
outputName         ./${inputname}_sa
set temperature    0

# Continua una simulacion desde un archivo restart 0 = NO, 1 = SI
if {1} {
binCoordinates     $restart.restart.coor
## Si se incluyen velocidades se debe remover temperatura
## Pues esta esta ya dada por la velocidad de los atomos del archivo restart
## No se utilizan velocidades pues el restart de la minimizacion no las genera
# binVelocities      $restart.restart.vel
extendedSystem	   $restart.restart.xsc
} 

binaryoutput       off
firsttimestep      0


#############################################################
## SIMULATION PARAMETERS                                   ##
#############################################################

# Archivos de parametros de Charmm
paraTypeCharmm	    on
parameters          ../par_all27_prot_lipid.prm ; # Dirección de los parámetros default (dir padre ..)

## NOTE: Do not set the initial velocity temperature if you 
## have also specified a .vel restart file!
temperature         $temperature
 
## Periodic Boundary conditions
## NOTE: Do not set the periodic cell basis if you have also 
## specified an .xsc restart file!
## En este caso ponemos "0" pues el archivo restart contiene también las dim del sistema
if {0} { 
cellBasisVector1	61.51300048828125	0.0	0.0
cellBasisVector2	0.0	63.739999771118164	0.0
cellBasisVector3	0.0	0.0	51.224998474121094
cellOrigin	19.30879020690918	25.521724700927734	5.089336395263672
}

wrapWater           on
wrapAll             on

## Force-Field Parameters
exclude             scaled1-4
1-4scaling          1.0
cutoff              12.
switching           on
switchdist          10.
pairlistdist        13.5

## Integrator Parameters
timestep            1.0  ; # t de integracion en fs
rigidBonds          water  ; # all/ none /water
nonbondedFreq       1
fullElectFrequency  2  
stepspercycle       10

## PME (for full-system periodic electrostatics)
## The grid size partially determines the accuracy and efficiency of PME. For
## speed, PMEGridSizeX should have only small integer factors (2, 3 and 5).
if {1} {
PME                 yes
PMEGridSizeX        64 ;# 3^5*3
PMEGridSizeY        64 ;# 5^2*2^2
PMEGridSizeZ        64 ;# 3*3*5
}


# Constant Temperature Control
langevin            on    ;# do langevin dynamics
langevinDamping     5     ;# damping coefficient (gamma) of 5/ps
langevinTemp        $temperature
langevinHydrogen    no    ;# don't couple langevin bath to hydrogens


## Constant Pressure Control (variable volume)
## Si estos parametros se ejecutan ( = "1") se realizara una simulacion NPT
## De otro modo, si = "0", se realiza una simulacion NVT
if {0} {
useGroupPressure      yes ;# needed for 2fs steps
useFlexibleCell       no  ;# no for water box, yes for membrane
useConstantArea       no  ;# no for water box, yes for membrane

langevinPiston        on
langevinPistonTarget  1.01325 ;#  in bar -> 1 atm
langevinPistonPeriod  100.0
langevinPistonDecay   50.0
langevinPistonTemp    $temperature
}

## Intervalo de guardado de las coordenadas y archivos
restartfreq         10000     ;# 500steps = every 1ps
dcdfreq             10000
xstFreq             10000
outputEnergies      10000
outputPressure      10000

## Fixed Atoms Constraint (set PDB beta-column to 1)
## Si se desea mantener fijos ciertos atomos, se ejecuta este bloque
if {0} {
fixedAtoms          on
fixedAtomsFile      fixed_water.pdb
fixedAtomsCol       B
}

if {0} {
constraints        on
consexp            2
consref            $inputname.pdb
conskfile          $inputname.pdb
conskcol           B
constraintScaling  0.05
}

#############################################################
## EXECUTION SCRIPT: SIMULATED ANNEALING                   ##
#############################################################

##	 Asigna velocidades a la temperatura dada
reinitvels          $temperature

## Ejecuta por 10000 pasos = 10 ps
## run 10000

##	temperatura mínima de inicio
set temp_min 0
##	tempratura máxima
set temp_max 350
##	temperatura final de la DM
set temp_final 310

## ------------------------
##	PARTE 1: Incrementar en 50 intervalos de 0 a 400K durante 100 ps
###	Número  total de pasos, intervalos, incremento y pasos por intervalo para dcada ciclo
set stps 100000
set intv 50
set incremento_temp [expr ($temp_max - $temp_min)/$intv]
set stps_by_intv [expr $stps/$intv]

for { set temperature $temp_min } { $temperature <= $temp_max } { incr temperature $incremento_temp } {
	
	reassignTemp $temperature
	langevinTemp $temperature
	run $stps_by_intv
}

# -------------------------
#	PARTE 2: Mantiene la temperatura a 400K por 100 ps
run 100000

# -------------------------
#	PARTE 3: Disminuye en 50 intervalos la Temp de 400K a 310K en 0.2 ns
#	temperature == 400
set temp_final 310

set stps 200000
set intv 50
set decremento_temp [expr ($temp_final - $temp_max)/$intv]
set stps_by_intv [expr $stps/$intv]

for { set temperature $temp_max } { $temperature >= $temp_final } { incr temperature $decremento_temp } {
	
	reassignTemp $temperature
	langevinTemp $temperature
	run $stps_by_intv
}

# -------------------------
#	PARTE 4: Templado - > Mantiene a 310K por 600 000 fs por 0.6 ns
run 600000

# -----
# Tiempo total de Simulated annealing : 1 ns


