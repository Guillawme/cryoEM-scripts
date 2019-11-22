# CryoEM scripts

Various utilities to help cryoEM data analysis

Available utilities so far:

- `count_particles.awk`: count particles contributing to each class of a class2D
  or class3D job from [RELION][relion], by reading a `run_it*_data.star` file.
  Dependencies: awk.
  automatically apply it to all `*_data.star` files in the current directory and
- `multi_count_particles.sh`: loop wrapper for `count_particles.awk`, to
  save results in tsv files. Dependencies: bash, `count_particles.awk`.
- `monitor_relion_classification.R`: plot number of particles as a function of
  iteration number for each class of a RELION class2D or class3D job, reading
  the summary files from `multi_count_particles.sh`. Dependencies: [R][r],
  [Tidyverse][tidyverse], `multi_count_particles.sh`.
- `dm4_to_mrc.sh`: convert a dm4 file to mrc format (useful to convert gain
  reference images to a format [MotionCor2][motioncor2] can read). Dependencies:
  bash, [EMAN2][EMAN2].
- `star2box.awk`: convert particle coordinates from RELION `*pick.star` format
  to EMAN2 `.box` format. Dependencies: awk.
- `setup_cryolo.sh`, `run_cryolo_training.sh`, `run_cryolo_picking.sh`,
  `cryolo_config.json`, `run_janni_denoise.sh`: set up a directory structure to
  train and/or perform particle picking with crYOLO. Dependencies: bash,
  [crYOLO][cryolo].
- `randomly_pick_micrographs.py`: select a random subset of micrographs to
  constitute a training set for crYOLO. Dependencies: Python3, `numpy`.
- `imgstats.sh`: gather pixel intensity statistics from motion-corrected
  micrographs. Dependencies: [IMOD][imod].
- `exclude_low_res_micrographs.awk`: filter a `micrographs_ctf.star` file from
  RELION to keep only micrographs with a rlnCtfMaxResolution equal to or better
  than a user-provided threshold. Dependencies: awk.


[relion]: https://github.com/3dem/relion
[motioncor2]: http://msg.ucsf.edu/em/software/motioncor2.html
[EMAN2]: http://blake.bcm.edu/emanwiki/EMAN2
[tidyverse]: https://www.tidyverse.org/packages
[r]: https://www.r-project.org
[cryolo]: http://sphire.mpg.de/wiki/doku.php?id=downloads:cryolo_1
[imod]: https://bio3d.colorado.edu/imod/
