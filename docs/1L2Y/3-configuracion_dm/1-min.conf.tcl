#############################################################
## MINIMIZACION: Prueba 1L2Y                            ##
#############################################################

## Escribe aquí los comentarios necesarios para describir el trabajo

#############################################################
## ADJUSTABLE PARAMETERS                                   ##
#############################################################

## Declara el nombre del archivo .pdb y psf (sin extenciones)
set inputname      tc5b_wb
## Lee los archivos de coordenadas (pdb) y topologia (psf)
structure          $inputname.psf
coordinates        $inputname.pdb
# set restart        min_eq

## Nombre de los archivos de salida
outputName         ${inputname}_min
set temperature    0

# Continua una simulacion desde un archivo restart 0 = NO, 1 = SI
if {0} {
binCoordinates     $restart.restart.coor
# Si se incluyen velocidades se debe remover temperatura
# Pues esta esta ya dada por la velocidad de los atomos del archivo restart
binVelocities      $restart.restart.vel
extendedSystem	   $restart.restart.xsc
} 

binaryoutput       off
firsttimestep      0


#############################################################
## SIMULATION PARAMETERS                                   ##
#############################################################

# Archivos de parametros de Charmm
paraTypeCharmm	    on
parameters          ./par_all27_prot_lipid.prm ; # Dirección de los parámetros default

## NOTE: Do not set the initial velocity temperature if you 
## have also specified a .vel restart file!
temperature         $temperature
 
## Periodic Boundary conditions
## NOTE: Do not set the periodic cell basis if you have also 
## specified an .xsc restart file!
if {1} {
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


# Constant Pressure Control (variable volume)
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


restartfreq         10000     ;# 500steps = every 1ps
dcdfreq             10000
xstFreq             10000
outputEnergies      10000
outputPressure      10000


# Fixed Atoms Constraint (set PDB beta-column to 1)
if {0} {
fixedAtoms          on
fixedAtomsFile      fixed_water.pdb
fixedAtomsCol       B
}


# IMD Settings (can view sim in VMD)
if {0} {
IMDon           on
IMDport         3000    ;# port number (enter it in VMD)
IMDfreq         1       ;# send every 1 frame
IMDwait         no      ;# wait for VMD to connect before running?
}

#Harmonic Restraints
if {0} {
constraints        on
consexp            2
consref            $inputname.pdb
conskfile          $inputname.pdb
conskcol           B
constraintScaling  0.05
}

#############################################################
## EXECUTION SCRIPT                                        ##
#############################################################

# Minimization de 10000 pasos
minimize            10000
exit



