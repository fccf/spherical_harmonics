"""
Plot the sparsity pattern of mesh
"""
from __future__ import division
import matplotlib.pyplot as pl
import numpy as np

a = np.loadtxt(file('../data/a.txt'))
ax = np.loadtxt(file('../data/ax.txt'))
ay = np.loadtxt(file('../data/ay.txt'))
az = np.loadtxt(file('../data/az.txt'))


pl.spy(a)
pl.title('A')
pl.savefig('../data/A.png')
pl.show()


pl.spy(ax)
pl.title('Ax')
pl.savefig('../data/Ax.png')
pl.show()


pl.spy(ay)
pl.title('Ay')
pl.savefig('../data/Ay.png')
pl.show()


pl.spy(az)
pl.title('Az')
pl.savefig('../data/Az.png')
pl.show()
