# Utilities to help cryoEM data analysis

Most of these scripts extract information from output files of [RELION][relion].
It does not need to be installed.

Available utilities so far:

- `count_particles.awk`: count particles contributing to each class of a class2D
  or class3D job (note that for class2D jobs, each particle can contribute to
  several classes with weights adding up to 1, therefore the sum of the reported
  particle number per class will exceed the total number of particles).

[relion]: https://github.com/3dem/relion
