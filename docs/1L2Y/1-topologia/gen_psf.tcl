# Script para crear el archivo de topologia .psf
package require psfgen
topology ../0-inputs/top_all27_prot_lipid.inp

pdbalias residue HIS HSE
pdbalias atom ILE CD1 CD
segment T {pdb TC5b_input.pdb}
coordpdb TC5b_input.pdb T
guesscoord

writepdb tc5b.pdb
writepsf tc5b.psf