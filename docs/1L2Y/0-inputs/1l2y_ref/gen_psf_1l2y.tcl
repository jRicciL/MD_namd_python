# Script para crear el archivo de topologia .psf
package require psfgen
topology ./top_all27_prot_lipid.inp

pdbalias residue HIS HSE
pdbalias atom ILE CD1 CD
segment T {pdb 1l2y.pdb}
coordpdb 1l2y.pdb T
guesscoord

writepdb 1l2y_Hs.pdb
writepsf 1l2y_Hs.psf