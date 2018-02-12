# Utilities to help cryoEM data analysis

Available utilities so far:

- `count_particles.awk`: count particles contributing to each class of a class2D
  or class3D job from [RELION][relion], by reading a `run_it*_data.star` file.
  Dependencies: awk.
- `multi_count_particles.sh`: loop wrapper for `count_particles.awk`, to
  automatically apply it to all `*_data.star` files in the current directory and
  save results in tsv files. Dependencies: bash, `count_particles.awk`.
- `monitor_relion_classification.R`: plot number of particles as a function of
  iteration number for each class of a RELION class2D or class3D job, reading
  the summary files from `multi_count_particles.sh`. Dependencies: [R][r],
  [Tidyverse][tidyverse], `multi_count_particles.sh`.
- `dm4_to_mrc.sh`: convert a dm4 file to mrc format (useful to convert gain
  reference images to a format [MotionCor2][motioncor2] can read). Dependencies:
  bash, [EMAN2][EMAN2].


[relion]: https://github.com/3dem/relion
[motioncor2]: http://msg.ucsf.edu/em/software/motioncor2.html
[EMAN2]: http://blake.bcm.edu/emanwiki/EMAN2
[tidyverse]: https://www.tidyverse.org/packages
[r]: https://www.r-project.org
