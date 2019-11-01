path = './dm_sources_1L2Y/0-inputs/ramchandran_references'
files = ['general', 'glycine', 
         'proline', 'preproline']

for file in files:
    a = np.loadtxt(F'{path}/pref_{file}.data.txt')
    a = a.T
    for i in range(0, 6):
        a[2][(a[2]  > 10**(-i-1)) & (a[2]  < 10**(-i))] = 10 * (2**(-i+1)) / 2
    a[2][(a[2]  < 0.001)] = 0
    a = np.compress(a[2] != 0, a, axis=1)
    # Guarda el archivo
    save_path = F'{path}/pref_{file}'
    np.save(save_path, a)
